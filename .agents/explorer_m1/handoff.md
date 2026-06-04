# Explorer M1 — Handoff Report: Test Failures & Analyzer Issues

**Agent**: Explorer M1 (Test Fix + Analyzer)
**Date**: 2026-06-04T07:15Z
**Status**: Hard handoff — investigation complete

---

## Summary

**8 tests fail across 2 files** (not 13 — the actual run shows 3 + 5 = 8 failures).
Three distinct root causes identified. **43 analyzer issues** cataloged across 8 lint rule types.

---

## 1. Observation — Test Failures

### File 1: `test/screens/belt_progression/belt_list_screen_test.dart`

**Test run result: 5 passed, 3 failed**

| # | Test Name | Error | Root Cause |
|---|-----------|-------|------------|
| 1 | `renders all 11 belt ranks` | `Expected: at least one matching candidate; Actual: Found 0 widgets with text "4th Kyu"` | **ListView virtualization** — only visible items rendered |
| 2 | `shows text labels for accessibility` | `Expected: at least one matching candidate; Actual: Found 0 widgets with text "Yonkyū — Yellow with Green stripe"` | **Same** — off-screen items not built |
| 3 | `shows loading state` | `A Timer is still pending even after the widget tree was disposed. Timer (duration: 1:00:00.000000)` | **Pending Timer** from `_LoadingProgressNotifier.build()` using `Future.delayed(Duration(hours: 1))` |

### File 2: `test/screens/review/flashcard_screen_test.dart`

**Test run result: 8 passed, 5 failed**

| # | Test Name | Error | Root Cause |
|---|-----------|-------|------------|
| 4 | `shows loading indicator initially` | `A Timer is still pending even after the widget tree was disposed. Timer (duration: 0:00:01.000000)` | **Pending Timer** from mock's `Future.delayed(Duration(seconds: 1))` at line 65 |
| 5 | `shows session statistics` | `A RenderFlex overflowed by 12 pixels on the bottom` at `flashcard_screen.dart:376:20` | **Column overflow** in `ReviewSummaryScreen` |
| 6 | `shows celebration for high retention` | Same RenderFlex overflow 12px | **Same** — Column at line 376 |
| 7 | `shows encouragement for low retention` | Same RenderFlex overflow 12px | **Same** |
| 8 | `done button pops navigation` | Same RenderFlex overflow 12px + deactivated widget ancestor lookup | **Same** (overflow error + secondary cascade error) |

---

## 2. Logic Chain — Root Cause Analysis

### Root Cause A: ListView Virtualization (2 tests)

**Affected tests**: #1 `renders all 11 belt ranks`, #2 `shows text labels for accessibility`

1. `BeltListScreen` uses `_BeltTimeline` → `ListView.builder` (line 73 of `belt_list_screen.dart`)
2. The default test surface is 800×600. Each `_BeltTimelineItem` is ~80-100px tall (IntrinsicHeight with Card + Row + padding).
3. With 11 items at ~90px each = ~990px total, only ~6-7 items fit on screen.
4. `ListView.builder` only builds visible items. Items like `kyu4` ("4th Kyu") and `kyu3`/`kyu2`/`kyu1`/`shodan` are off-screen.
5. The test loops through ALL `BeltRank.values` asserting `find.text(rank.displayName)` → fails when "4th Kyu" (and later ranks) are not built.
6. **The data model is correct** — `BeltRank.kyu4.displayName` = `'4th Kyu'`, `BeltRank.kyu4.japaneseName` = `'Yonkyū'`, `BeltRank.kyu4.colorDescription` = `'Yellow with Green stripe'`. The problem is purely viewport-based.

**Fix options (choose one)**:
- **Option A (recommended)**: Scroll the list in the test to ensure each item is visible before asserting. Use `tester.scrollUntilVisible(find.text(rank.displayName), 200)` inside the loop.
- **Option B**: Wrap `_BeltTimeline` body in `SingleChildScrollView + Column` instead of `ListView.builder`. This forces all children to build, but loses virtualization perf.
- **Option C**: Increase test surface size with `tester.view.physicalSize = Size(800, 2000)` in setUp. Reset in tearDown.

### Root Cause B: Pending Timer (2 tests)

**Affected tests**: #3 `shows loading state`, #4 `shows loading indicator initially`

**Test #3 — belt_list_screen_test.dart:120-133**:
- `_LoadingProgressNotifier.build()` (line 232-236) does `await Future.delayed(const Duration(hours: 1))`.
- The test does `pumpWidget` then immediately asserts `find.byType(CircularProgressIndicator)`.
- At test teardown, the 1-hour timer from `Future.delayed` is still pending → framework assertion fails.

**Fix**: Replace `Future.delayed(Duration(hours: 1))` with a `Completer<UserProgress?>` that never completes:
```dart
@override
Future<UserProgress?> build() {
  return Completer<UserProgress?>().future; // Never completes, no timer.
}
```

**Test #4 — flashcard_screen_test.dart:62-71**:
- The mock uses `Future.delayed(const Duration(seconds: 1), () => const Success([]))` at line 65.
- The test does `pumpWidget` then asserts `CircularProgressIndicator` without advancing time.
- The 1-second timer from `Future.delayed` is still pending at teardown.

**Fix**: Replace with a `Completer` that never completes:
```dart
when(() => mockService.getDueCards(any())).thenAnswer(
  (_) => Completer<Result<List<CardReviewState>>>().future,
);
```

### Root Cause C: RenderFlex Overflow in ReviewSummaryScreen (4 tests)

**Affected tests**: #5-#8 (all `ReviewSummaryScreen` tests + `done button pops navigation`)

1. `ReviewSummaryScreen.build()` at line 376 uses a `Column` with `mainAxisAlignment: MainAxisAlignment.center` inside `Center > Padding(all: 24)`.
2. The Column children total height exceeds the available 496px (800-56 appbar - 24*2 padding - some SafeArea):
   - Icon (64px) + SizedBox(24) + Text headline + SizedBox(32) + 4×(_statRow Card ~56px each + SizedBox(12)) = ~64+24+24+32+4*68+48+48 ≈ 512px
   - Available: ~496px → overflow by 12px.
3. The overflow is treated as a test failure because Flutter's test framework converts RenderFlex overflow exceptions into test failures.

**Fix (recommended)**: Wrap the `Column` children in a `SingleChildScrollView`:
```dart
// File: lib/screens/review/flashcard_screen.dart, lines 372-447
body: SafeArea(
  child: SingleChildScrollView(  // <-- Add this
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // <-- Change from max to min
          children: [ ... ],
        ),
      ),
    ),
  ),
),
```

---

## 3. Caveats

- The mission brief said "13 failing tests" but actual test runs show **8 failures** (3 + 5). The prior count may have included cascade failures or a different test run configuration.
- The `done button pops navigation` test (#8) has a secondary error (`Looking up a deactivated widget's ancestor is unsafe`) which is a cascade from the RenderFlex overflow — the overflow error triggers error reporting which tries to walk the widget tree after disposal. Fixing the overflow will fix this secondary error.
- I did not investigate whether the overflow is also visible in production on small devices — it likely is.

---

## 4. Analyzer Issues Catalog (43 total)

### Summary by Rule

| Rule | Count | Severity | Files Affected |
|------|-------|----------|---------------|
| `prefer_const_constructors` | 30 | info | `belt_detail_screen.dart` (5), `home_screen.dart` (4), `belt_list_screen_test.dart` (13), `belt_color_swatch_test.dart` (8) |
| `cascade_invocations` | 3 | info | `belt_card.dart` (1), `flashcard_screen.dart` (1), `belt_color_swatch.dart` (1) |
| `unnecessary_lambdas` | 3 | info | `app.dart` (1), `belt_list_screen_test.dart` (2) |
| `prefer_const_declarations` | 2 | info | `belt_list_screen.dart` (1), `quiz_result_screen_test.dart` (1) |
| `unnecessary_underscores` | 2 | info | `home_screen.dart` (2) |
| `use_decorated_box` | 1 | info | `belt_list_screen.dart` (1) |
| `use_null_aware_elements` | 1 | info | `dashboard_card.dart` (1) |
| `deprecated_member_use` | 1 | info | `quiz_config_screen.dart` (1) |
| `unused_local_variable` | 1 | warning | `belt_detail_screen.dart` (1) |

### Fix Pattern for Each Rule

#### `prefer_const_constructors` (30 issues)
**Pattern**: Add `const` keyword to constructor invocations where all arguments are compile-time constants.
```dart
// Before:
SizedBox(height: 16)
// After:
const SizedBox(height: 16)
```
**Affected files & lines**:
- `lib/screens/belt_progression/belt_detail_screen.dart`: 118, 122, 126, 130, 134
- `lib/screens/home/home_screen.dart`: 58, 88, 95, 102
- `test/screens/belt_progression/belt_list_screen_test.dart`: 212, 215, 221, 225, 240, 243, 249, 253, 266, 269, 275, 279
- `test/widgets/belt_color_swatch_test.dart`: 113, 114, 115, 117, 146, 147, 148, 150

#### `cascade_invocations` (3 issues)
**Pattern**: Use `..` cascade operator when calling multiple methods on the same receiver.
```dart
// Before:
ref.invalidate(dueCardsProvider);
ref.invalidate(reviewStatsProvider);
// After:
ref
  ..invalidate(dueCardsProvider)
  ..invalidate(reviewStatsProvider);
```
**Affected files & lines**:
- `lib/screens/belt_progression/widgets/belt_card.dart`: 115
- `lib/screens/review/flashcard_screen.dart`: 105
- `lib/widgets/belt_color_swatch.dart`: 127

#### `unnecessary_lambdas` (3 issues)
**Pattern**: Replace closures with tearoffs when the closure just forwards to a function.
```dart
// Before:
() => _LoadingProgressNotifier()
// After:
_LoadingProgressNotifier.new
```
**Affected files & lines**:
- `lib/app.dart`: 177
- `test/screens/belt_progression/belt_list_screen_test.dart`: 125, 140

#### `prefer_const_declarations` (2 issues)
**Pattern**: Replace `final` with `const` for variables initialized to compile-time constants.
```dart
// Before:
final belts = BeltRank.values;
// After:
const belts = BeltRank.values;
```
**Affected files & lines**:
- `lib/screens/belt_progression/belt_list_screen.dart`: 71
- `test/screens/quiz/quiz_result_screen_test.dart`: 15

#### `unnecessary_underscores` (2 issues)
**Pattern**: Replace `__` with `_` for unused parameters.
```dart
// Before:
(__, value) => ...
// After:
(_, value) => ...
```
**Affected files & lines**:
- `lib/screens/home/home_screen.dart`: 194, 218

#### `use_decorated_box` (1 issue)
**Pattern**: Replace `Container` that only has `decoration` with `DecoratedBox`.
```dart
// Before:
Container(decoration: BoxDecoration(...), child: card)
// After:
DecoratedBox(decoration: BoxDecoration(...), child: card)
```
**Affected file & line**:
- `lib/screens/belt_progression/belt_list_screen.dart`: 295

#### `use_null_aware_elements` (1 issue)
**Pattern**: Use `?` null-aware marker in collection literals instead of `if (x != null) x`.
```dart
// Before:
if (item != null) item
// After:
?item
```
**Affected file & line**:
- `lib/screens/home/dashboard_card.dart`: 98

#### `deprecated_member_use` (1 issue)
**Pattern**: Replace deprecated `value` parameter with `initialValue` on form field.
```dart
// Before:
DropdownButtonFormField(value: selectedValue, ...)
// After:
DropdownButtonFormField(initialValue: selectedValue, ...)
```
**Affected file & line**:
- `lib/screens/quiz/quiz_config_screen.dart`: 114

#### `unused_local_variable` (1 issue — warning)
**Pattern**: Remove or use the declared variable.
```dart
// Before:
final theme = Theme.of(context); // unused
// After:
// Remove the line, or use `theme` somewhere.
```
**Affected file & line**:
- `lib/screens/belt_progression/belt_detail_screen.dart`: 112

---

## 5. Conclusion — Recommended Fix Order

1. **Root Cause B (Pending Timer)**: Fix the 2 mock classes — replace `Future.delayed` with `Completer().future`. Easiest, zero production code changes.
2. **Root Cause C (RenderFlex overflow)**: Wrap `ReviewSummaryScreen` Column in `SingleChildScrollView`. This fixes a real UX bug on small screens + fixes 4 test failures.
3. **Root Cause A (ListView virtualization)**: Add `scrollUntilVisible` calls in the belt list tests. Pure test-side fix.
4. **Analyzer issues**: Batch fix by rule type. All are mechanical — `prefer_const_constructors` alone is 30 of 43.

**Total files to edit**: ~12 files (3 for test fixes, ~9 for analyzer fixes).

---

## 6. Verification Method

After implementing fixes, run:
```bash
export PATH="/usr/local/google/home/adesimpson/flutter-sdk/bin:$PATH"
flutter test test/screens/belt_progression/belt_list_screen_test.dart
flutter test test/screens/review/flashcard_screen_test.dart
flutter analyze
```
Expected: 0 test failures, 0 analyzer issues.
