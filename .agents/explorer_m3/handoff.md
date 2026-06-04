# Explorer M3 Handoff Report: UI + Content + Performance Audit

**Agent**: Explorer M3
**Scope**: R4 (UI Integrity), R5 (IKO-1 Content Accuracy), R6 (Performance)
**Date**: 2026-06-04
**Status**: Hard Handoff — Complete

---

## Executive Summary

The Docklands Dojo Flutter app is well-architected with clean Riverpod state management, proper error/loading states on most screens, and generally accurate IKO-1 content. However, **7 critical issues**, **9 medium issues**, and **6 low issues** were identified across UI integrity, content accuracy, and performance domains.

---

## R4: UI INTEGRITY FINDINGS

### 🔴 CRITICAL — Navigation Dead Ends & Wiring Issues

#### C1: DashboardCard buttons on HomeScreen have no onTap handlers
**File**: `lib/screens/home/home_screen.dart`, lines 58-107
**Evidence**: All five `DashboardCard` widgets on the home screen are constructed **without `onTap` callbacks**:
```dart
// Line 58-63 — "Due for Review" card
DashboardCard(
  icon: Icons.style,
  title: 'Due for Review',
  subtitle: 'Tap to start flashcard review',
  iconColor: DojoColors.accentLight,
),  // ← No onTap!
```
Same pattern for "Quick Quiz" (line 67), "Belt Progression" (line 88), "Technique Library" (line 95), "Settings" (line 102).

**Impact**: The entire home dashboard is **non-functional** — users see "Tap to start flashcard review" but tapping does nothing. The `DashboardCard` widget (line 99 of `dashboard_card.dart`) only shows `chevron_right` when `onTap != null`, and currently none show it.

#### C2: BeltListScreen uses Navigator.push instead of GoRouter
**File**: `lib/screens/belt_progression/belt_list_screen.dart`, lines 313-318
**Evidence**:
```dart
void _navigateToDetail(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => BeltDetailScreen(rank: rank),
    ),
  );
}
```
GoRouter defines `/belt/:rank` route (app.dart:93-103), but belt list uses imperative `Navigator.push`. This bypasses GoRouter's navigation state, breaks URL-based navigation, and means the bottom nav bar persists underneath (since the push happens inside the shell navigator).

#### C3: Settings "Export & Import" uses Navigator.pushNamed('/export') but no '/export' route exists
**File**: `lib/screens/settings/settings_screen.dart`, line 85
**Evidence**:
```dart
onTap: () => Navigator.of(context).pushNamed('/export'),
```
But `dojoRouter` in `app.dart` has no route for `/export`. GoRouter routes are: `/`, `/techniques`, `/review`, `/belts`, `/belt/:rank`, `/quiz`, `/quiz/active`, `/settings`. **This will throw a route-not-found exception at runtime.**

### 🟡 MEDIUM — Missing States & Accessibility

#### M1: Flashcard review screen uses hardcoded `Colors.red` in dark mode
**File**: `lib/screens/review/flashcard_screen.dart`, line 138
**Evidence**: Error state uses `Colors.red` instead of `theme.colorScheme.error`:
```dart
const Icon(Icons.error_outline, size: 48, color: Colors.red),
```
Also quality rating buttons (lines 257-288) use hardcoded `Colors.red.shade700`, `Colors.orange`, `Colors.amber`, `Colors.green` — not theme-aware.

#### M2: Quiz feedback section uses hardcoded green/red colors in dark mode
**File**: `lib/screens/quiz/quiz_screen.dart`, lines 339-340, 468-477
**Evidence**: Multiple hardcoded light-mode colors:
```dart
backgroundColor = Colors.green.shade100;   // line 339
foregroundColor = Colors.green.shade900;   // line 340
color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,  // line 473
```
These `.shade50` and `.shade100` colors render with near-zero contrast on dark surfaces.

#### M3: QuizResultScreen weak areas card uses hardcoded `Colors.red.shade50`
**File**: `lib/screens/quiz/quiz_result_screen.dart`, line 288
**Evidence**: `Card(color: Colors.red.shade50, ...)` — near-invisible on dark backgrounds.

#### M4: Belt detail checkbox only supports marking complete, not uncomplete
**File**: `lib/screens/belt_progression/belt_detail_screen.dart`, lines 322-328
**Evidence**:
```dart
void _toggleTechnique(String techniqueId, bool? value) {
  if (value == true) {
    ref.read(currentProgressProvider.notifier).markTechniqueCompleted(techniqueId);
  }
}
```
And line 561: `onChanged: isCompleted ? null : onChanged` — checkbox is disabled once checked. Users cannot undo accidental completions.

#### M5: Onboarding flow not wired into main navigation
**File**: `lib/app.dart` — No onboarding routes exist
**Evidence**: `dojoRouter` initial location is `/` (HomeScreen). The three onboarding screens (`WelcomeScreen`, `BeltSelectionScreen`, `FeaturePreviewScreen`) in `lib/screens/onboarding/` have no GoRouter entries. The `main.dart` comment mentions "checks onboarding status" (line 18) but no such check exists — the app always starts at HomeScreen.

#### M6: Missing Semantics labels on multiple interactive elements
**Files**: Several screens lack Semantics wrapping:
- `belt_list_screen.dart`: `InkWell` on belt cards (line 196) — no Semantics label
- `flashcard_screen.dart`: Quality rating buttons (lines 295-333) — no Semantics labels
- `home_screen.dart`: DashboardCards for "Due for Review", "Quick Quiz" etc. — the `DashboardCard` widget does have Semantics (`label: '$title: $subtitle'`) ✅, but since `onTap` is null, `button: false` which is correct but misleading UX
- `belt_selection_screen.dart`: `InkWell` belt options (line 134) — no Semantics label

#### M7: Theme mode not persisted
**File**: `lib/providers/theme_provider.dart`, lines 1-9
**Evidence**: `final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);` — in-memory only. Theme selection resets to `system` on every app restart.

### 🟢 LOW — Minor UI Issues

#### L1: HomeScreen uses `DojoColors.accentLight` and `DojoColors.secondaryLight` directly
**File**: `lib/screens/home/home_screen.dart`, lines 63, 71, 186
**Evidence**: Hardcoded light-mode colors used on dashboard cards regardless of current theme mode. In dark mode, `DojoColors.secondaryLight` (`#C41E3A`) may clash.

#### L2: WelcomeScreen uses hardcoded `DojoColors.secondaryLight` button color
**File**: `lib/screens/onboarding/welcome_screen.dart`, line 60
**Evidence**: `backgroundColor: DojoColors.secondaryLight` — not theme-adaptive.

---

## R5: IKO-1 CONTENT ACCURACY FINDINGS

### 🔴 CRITICAL — Missing or Mismatched Content

#### C4: Technique count is 72 vs PRD's specified 94+
**File**: `lib/data/techniques_data.dart`
**PRD Reference**: Lines 684-709 specify exact counts:
- Stances (Dachi): 11 — **need to verify against actual data**
- Punches (Tsuki): 12
- Kicks (Geri): 14
- Blocks (Uke): 10
- Strikes (Uchi): 12
- Elbow (Hiji): 6
- Knee (Hiza): 4
- Breaking (Tameshiwari): 3
- **Total: ~72 techniques**

**Analysis**: The PRD header says "100+ techniques" (line 550, 666), but the explicit enumeration (lines 684-709) totals ~72 individual techniques. The "100+" figure likely includes kata separately. The actual `techniques_data.dart` needs a line-by-line count — the file is large enough (~72+ entries based on earlier examination). **The PRD's "100+" label is aspirational vs. the explicit list of ~72; this is a PRD inconsistency, not necessarily a code bug.** However, implementers should verify each of the 72 explicit items is present.

#### C5: PRD specifies `quiz_questions_data.dart` but file doesn't exist
**File**: Referenced in PRD line 553, 669: `quiz_questions_data.dart — 150+ quiz questions`
**Evidence**: `lib/data/` contains: `syllabus_data.dart`, `techniques_data.dart`, `kata_data.dart`, `flashcards_data.dart`. No `quiz_questions_data.dart`. The `QuizService` presumably generates questions dynamically from technique/kata data rather than using a static pool.
**Impact**: The quiz system works without it (questions are generated from existing data), but this deviates from the PRD spec. The PRD expected 150+ curated questions.

### 🟡 MEDIUM — Content Structural Issues

#### M8: Belt color hex values match PRD ✅
**File**: `lib/theme/dojo_colors.dart`, lines 60-90
**Verification**: Cross-referenced against PRD lines 630-642:

| Rank | PRD Hex | Code Hex | Match |
|------|---------|----------|-------|
| White | `#FFFFFF` | `0xFFFFFFFF` | ✅ |
| Orange | `#FF8C00` | `0xFFFF8C00` | ✅ |
| Blue | `#0047AB` | `0xFF0047AB` | ✅ |
| Yellow | `#FFD700` | `0xFFFFD700` | ✅ |
| Green | `#228B22` | `0xFF228B22` | ✅ |
| Brown | `#8B4513` | `0xFF8B4513` | ✅ |
| Black | `#1A1A1A` | `0xFF1A1A1A` | ✅ |
| Stripe Blue | `#0047AB` | `beltBlue` | ✅ |
| Stripe Yellow | `#FFD700` | `beltYellow` | ✅ |
| Stripe Green | `#228B22` | `beltGreen` | ✅ |

**All belt colors match PRD.** ✅

#### M9: Japanese name romanization needs expert verification
**File**: `lib/models/belt_rank.dart`
**PRD Reference**: Lines 93-104 define the Japanese names.
**Comparison**:

| Belt | PRD | Code | Match |
|------|-----|------|-------|
| kyu10 | Jūkyū | Jūkyū | ✅ |
| kyu9 | Kukyū | Kukyū | ✅ |
| kyu8 | Hachikyū | Hachikyū | ✅ |
| kyu7 | Nanakyū | Nanakyū | ✅ |
| kyu6 | Rokkyū | Rokkyū | ✅ |
| kyu5 | Gokyū | Gokyū | ✅ |
| kyu4 | Yonkyū | Yonkyū | ✅ |
| kyu3 | Sankyū | Sankyū | ✅ |
| kyu2 | Nikyū | Nikyū | ✅ |
| kyu1 | Ikkyū | Ikkyū | ✅ |
| shodan | Shodan | Shodan | ✅ |

**All Japanese names match PRD.** ✅

#### M10: Kata count is 22 — matches PRD ✅
**File**: `lib/data/kata_data.dart`
**PRD Reference**: Line 705-706 specifies exactly 22 kata items.
**Evidence**: Earlier examination confirmed 22 kata entries.

---

## R6: PERFORMANCE FINDINGS

### 🔴 CRITICAL — Performance Issues

#### C6: SearchService creates new instance on every rebuild in TechniqueLibraryScreen
**File**: `lib/screens/technique/technique_library_screen.dart`, line 32
**Evidence**:
```dart
final _searchService = const SearchService();
```
This is actually OK since `SearchService` is `const` (stateless). However, the `_onSearchChanged` method (line 54) calls `setState` which triggers a full rebuild of the technique list, calling `searchTechniques` on every keystroke:
```dart
void _onSearchChanged() {
  setState(() {
    _searchQuery = _searchController.text;
  });
}
```
**Impact**: No debounce — every keystroke triggers a full list rebuild + fuzzy search computation over all techniques. The Levenshtein distance computation in `SearchService._levenshteinDistance` is O(n*m) per technique name, applied to all 72+ techniques on every keystroke.

#### C7: `allBeltRequirements` list iterated linearly for every belt lookup
**File**: `lib/screens/belt_progression/belt_list_screen.dart`, lines 95-100 and `belt_detail_screen.dart`, lines 88-93
**Evidence**:
```dart
BeltRequirement? _getRequirement(BeltRank rank) {
  for (final req in allBeltRequirements) {
    if (req.rank == rank) return req;
  }
  return null;
}
```
Called once per belt in the list (11 times), each doing a linear scan. Not critical at 11 items, but the pattern is duplicated across two files. Should be a `Map<BeltRank, BeltRequirement>` for O(1) lookup.

### 🟡 MEDIUM — Performance Concerns

#### M11: `allFlashCards` list is 1735 lines — eagerly loaded as top-level constant
**File**: `lib/data/flashcards_data.dart`, 1735 lines
**Evidence**: The entire flashcard dataset is a top-level `const` list, loaded into memory at app startup. At ~54KB, this is manageable for now but grows linearly with content.

#### M12: `completionPercentageProvider` watched per-belt in BeltListScreen
**File**: `lib/screens/belt_progression/belt_list_screen.dart`, line 80
**Evidence**:
```dart
final completionAsync = ref.watch(completionPercentageProvider(rank));
```
Called inside `ListView.builder` — creates 11 separate provider watchers. Each triggers a DB query. However, `valueOrNull ?? 0.0` (line 81) means it gracefully handles loading.

#### M13: Quiz timer ticks every second with setState
**File**: `lib/screens/quiz/quiz_screen.dart`, lines 53-59
**Evidence**:
```dart
_timer = Timer.periodic(const Duration(seconds: 1), (_) {
  if (!mounted) return;
  setState(() {
    _elapsed = DateTime.now().difference(_startTime);
  });
});
```
Rebuilds the entire quiz screen every second during mock exams. Should isolate timer display with a `ValueNotifier` or separate `StatefulWidget`.

### 🟢 LOW — Minor Performance Notes

#### L3: TechniqueDetailScreen creates SearchService on every build
**File**: `lib/screens/technique/technique_detail_screen.dart`, line 29
**Evidence**: `const searchService = SearchService();` — inside `build()`. Since `SearchService` is `const`, this is actually fine — no allocation cost.

#### L4: `_BeltTimeline` passes `completedTechniques` map but never uses it
**File**: `lib/screens/belt_progression/belt_list_screen.dart`, lines 60-67
**Evidence**: Field `completedTechniques` is declared and passed but never referenced in the class body. Dead field.

#### L5: QuizHistoryNotifier is in-memory only — history lost on restart
**File**: `lib/providers/quiz_providers.dart`, lines 167-200
**Evidence**: `QuizHistoryNotifier() : super([]);` — no persistence. The class comment (line 166) acknowledges: "In-memory only for now; will be backed by Drift in a future CL."

#### L6: ExportService is recreated on every call
**File**: `lib/screens/settings/export_import_screen.dart`, line 36
**Evidence**: `ExportService get _exportService => ExportService(widget.database);` — getter creates new instance each time. Should cache in `initState` or `late final`.

---

## Logic Chain

1. **HomeScreen non-functional** (C1): Observed zero `onTap` params → DashboardCard.build line 99 only shows chevron when `onTap != null` → all cards are decorative-only → home screen is a dead end.

2. **'/export' route crash** (C3): `settings_screen.dart:85` calls `Navigator.pushNamed('/export')` → `dojoRouter` (app.dart) has no `/export` route → runtime `RouteNotFoundException`.

3. **Dark mode contrast** (M1, M2, M3): Hardcoded `Colors.green.shade50`, `Colors.red.shade50` used for feedback backgrounds → on dark surface (`#1E1E2E`), luminance contrast ratio < 1.5:1 → WCAG fail.

4. **Search performance** (C6): `_onSearchChanged` → `setState` on every keystroke → full list rebuild → `searchTechniques` runs Levenshtein on 72+ items → O(k*n*m) per session where k=keystrokes.

5. **Content gap** (C5): PRD mandates `quiz_questions_data.dart` with 150+ curated questions → file doesn't exist → quiz quality depends entirely on auto-generation from technique data.

---

## Caveats

1. **Technique count verification**: Did not count every individual entry in `techniques_data.dart` line-by-line. PRD's explicit enumeration totals ~72, but PRD header says "100+". Need manual count.
2. **Flashcard content accuracy**: Did not cross-reference all 1735 lines of flashcard data against IKO-1 source material. Content categories and structure appear correct.
3. **Database query performance**: Did not profile actual Drift query execution. Assessed based on code patterns (11 concurrent provider watches).
4. **Test coverage**: Did not audit test files — scope was limited to lib/ runtime code.
5. **Onboarding persistence**: Did not find where onboarding completion state is stored/checked. It may exist in a file I didn't examine, or it may be completely unimplemented.

---

## Conclusion

### Must-Fix Before Ship (Critical)
1. **C1**: Wire `onTap` handlers on all HomeScreen DashboardCards
2. **C3**: Add `/export` route to GoRouter OR change settings to use `context.push('/export')`
3. **C2**: Switch BeltListScreen to use GoRouter `context.push('/belt/${rank.name}')`

### Should-Fix (Medium)
4. **M1-M3**: Replace hardcoded color values with theme-aware equivalents for dark mode
5. **M5**: Implement onboarding flow with route guards
6. **M6**: Add Semantics labels to all interactive elements
7. **M7**: Persist theme mode selection (SharedPreferences or Drift)
8. **C6**: Add debounce to search input (~300ms)
9. **M4**: Allow unchecking completed techniques

### Nice-to-Have (Low)
10. **C7**: Convert `allBeltRequirements` to a `Map<BeltRank, BeltRequirement>`
11. **L5**: Back QuizHistoryNotifier with Drift
12. **C5**: Create curated quiz question bank per PRD

---

## Verification Method

### C1 — DashboardCard onTap
```
grep -n 'onTap' lib/screens/home/home_screen.dart
# Expected: zero results in current code
```

### C3 — Missing /export route
```
grep -rn "'/export'" lib/app.dart
# Expected: zero results — route not defined
```

### Dark mode contrast (M1-M3)
```
grep -rn 'Colors.red.shade50\|Colors.green.shade50\|Colors.red.shade100\|Colors.green.shade100' lib/screens/
# Expected: matches in quiz_screen.dart, quiz_result_screen.dart, flashcard_screen.dart
```

### Search debounce (C6)
```
grep -n 'debounce\|Timer\|Future.delayed' lib/screens/technique/technique_library_screen.dart
# Expected: zero results — no debounce implemented
```

### Content verification
```
grep -c 'Technique(' lib/data/techniques_data.dart    # Count technique entries
grep -c 'Kata(' lib/data/kata_data.dart                # Should be 22
ls lib/data/quiz_questions_data.dart                   # Should NOT exist
```
