# Handoff Report: Logic Bug Audit — Docklands Dojo Services

**Agent**: Explorer M2 (Logic Bug Audit)
**Date**: 2026-06-04T00:15Z
**Status**: Hard Handoff — Investigation Complete

---

## Executive Summary

Audited all service-layer logic in the Docklands Dojo Flutter app. Found **14 issues** (2 critical, 3 high, 5 medium, 4 low). The most impactful: completion percentage ignores fitness/kumite/terminology requirements, enabling premature belt advancement. Training session duration is truncated to minutes on export, losing sub-minute data on round-trip.

---

## 1. Observation

### Files Audited

| File | Lines | Verdict |
|------|-------|---------|
| `lib/services/srs/sm2_algorithm.dart` | 80 | ✅ Clean — formula correct |
| `lib/services/srs/srs_algorithm.dart` | 88 | ✅ Clean |
| `lib/services/srs/review_service.dart` | 252 | 🟡 1 medium issue |
| `lib/services/quiz_service.dart` | 484 | 🟡 2 medium, 1 low |
| `lib/services/progress_service.dart` | 316 | 🔴 1 critical, 1 high, 1 medium |
| `lib/services/search_service.dart` | 302 | 🟡 1 medium |
| `lib/services/fuzzy_match_service.dart` | 198 | 🟢 1 low |
| `lib/services/export_service.dart` | 638 | 🟡 1 high, 1 medium |
| `lib/services/import_summary.dart` | 77 | ✅ Clean |
| `lib/models/belt_rank.dart` | 143 | ✅ Clean |
| `lib/models/quiz.dart` | 236 | 🟢 1 low |
| `lib/models/user_progress.dart` | 131 | 🟢 1 low |
| `lib/models/export_bundle.dart` | 70 | ℹ️ Stale type |

---

## 2. Bugs Found

### BUG-01: `calculateCompletionPercentage()` ignores fitness, kumite, terminology, ido geiko (CRITICAL)

**File**: `lib/services/progress_service.dart` **Lines**: 198–216
**PRD Spec**: §F1: "Visual progress indicator showing completed vs remaining requirements per belt"

```dart
final allRequired = [
  ...requirement.requiredKihon,
  ...requirement.requiredKata,
];
if (allRequired.isEmpty) return 0.0;
```

**The Bug**: Only kihon and kata IDs are counted toward completion. The `BeltRequirement` model also includes `fitnessRequirements`, `kumiteRequirements`, `terminology`, `idoGeiko`, and `minimumTrainingSessions` — **none contribute to completion %**.

This means `canAdvanceTo()` (line 243–247), which gates on `completion >= 1.0`, allows advancement without meeting fitness, kumite, or terminology requirements.

**Severity**: CRITICAL — Systematically under-reports requirements. Enables premature belt advancement.
**Recommended Fix**: Either include fitness/kumite/terminology as checkable items in completion, or add separate validation checks in `canAdvanceTo()`.

---

### BUG-02: `advanceBelt()` does not validate prerequisites (HIGH)

**File**: `lib/services/progress_service.dart` **Lines**: 265–299

```dart
/// Does NOT validate prerequisites — call [canAdvanceTo] first.
Future<Result<void>> advanceBelt(BeltRank to, {String? notes}) async {
```

**The Issue**: Documented but dangerous. Any caller can do `advanceBelt(BeltRank.shodan)` from white belt without validation. No defensive check.

**Severity**: HIGH — Belt skip possible from any UI/service code that doesn't remember to call `canAdvanceTo()` first.
**Recommended Fix**: Gate `advanceBelt()` on `canAdvanceTo()` internally, or add an `assert` in debug mode.

---

### BUG-03: Export serializes session duration as minutes, truncating precision (HIGH)

**File**: `lib/services/export_service.dart` **Lines**: 361–365 (serialize), 501–506 (deserialize)

```dart
// Serialize:
'durationMinutes': session.duration.inMinutes,  // Truncates!

// Deserialize:
duration: Duration(minutes: durationMinutes),
```

**The Bug**: `Duration.inMinutes` truncates to whole minutes. A 90-second session → 1 minute → on import becomes 60 seconds. **Silent data loss on export→import round-trip.**

**Severity**: HIGH — Data loss.
**Recommended Fix**: Use `inSeconds` instead:
```dart
'durationSeconds': session.duration.inSeconds,
```

---

### BUG-04: Quiz MC options may contain duplicates from distractors (MEDIUM)

**File**: `lib/services/quiz_service.dart` **Lines**: 218–236

```dart
final wrongAnswers = _getDistractors(technique, 3);
final options = [technique.englishName, ...wrongAnswers]..shuffle(_random);
```

**The Issue**: `_getDistractors()` (lines 415–443) doesn't filter out the correct answer. If a fallback technique from another category has the same `englishName` as the correct answer, duplicates appear.

**Severity**: MEDIUM — Unlikely with current data but architecturally unsound.
**Recommended Fix**: `distractors.remove(technique.englishName);` before returning.

---

### BUG-05: Kata move count MC can produce duplicate option values (MEDIUM)

**File**: `lib/services/quiz_service.dart` **Lines**: 386–394

```dart
final wrongCounts = [
  kata.moveCount + 2,
  kata.moveCount - 2,
  kata.moveCount + 5,
].map((c) => c.clamp(1, 200).toString()).toList();
final options = [kata.moveCount.toString(), ...wrongCounts]..shuffle(_random);
```

**The Bug**: If `moveCount=1`, then `moveCount-2` clamps to 1 → duplicate "1" in options. If `moveCount=3`, `moveCount-2=1` is fine. Only affects kata with very low move counts.

**Severity**: MEDIUM — Deterministic bug for moveCount ≤ 2.
**Recommended Fix**: Deduplicate and regenerate if needed.

---

### BUG-06: Search uses absolute Levenshtein threshold (≤2), not PRD's ≥80% similarity (MEDIUM)

**File**: `lib/services/search_service.dart` **Lines**: 186–190
**PRD Spec**: §F2: "Threshold: ≥ 80% similarity after normalization"

```dart
final distance = levenshteinDistance(queryCanon, targetCanon);
if (distance <= 2) {
  bestScore = _min(bestScore, 3);
}
```

**The Bug**: Fixed ≤2 edit distance. For short queries ("ma" = 2 chars), 2 edits = 0% similarity → **false positives**. PRD says ≥80% similarity. `FuzzyMatchService` (quiz scoring) correctly uses 80% threshold.

**Severity**: MEDIUM — Diverges from PRD spec, false positives on short queries.
**Recommended Fix**: Use percentage-based similarity threshold like `FuzzyMatchService`.

---

### BUG-07: Import doesn't validate `correctReviews <= totalReviews` (MEDIUM)

**File**: `lib/services/export_service.dart` **Lines**: 547–559

```dart
final totalReviews = map['totalReviews'] as int? ?? 0;
final correctReviews = map['correctReviews'] as int? ?? 0;
// No invariant check — correctReviews could exceed totalReviews
```

**PRD Spec**: `CardReviewState.validate()` asserts `correctReviews <= totalReviews`.

**Severity**: MEDIUM — Data integrity gap on malicious/corrupt import.
**Recommended Fix**: `correctReviews = min(correctReviews, totalReviews)`.

---

### BUG-08: `advanceBelt()` double-reads progress from DB (MEDIUM)

**File**: `lib/services/progress_service.dart` **Lines**: 265–289

```dart
Future<Result<void>> advanceBelt(BeltRank to, ...) async {
  final progressResult = await getCurrentProgress();  // Read 1
  // ...
  return updateCurrentBelt(to);  // Read 2 (internally calls getProgress())
}
```

**The Issue**: Two sequential reads. TOCTOU race + unnecessary DB call.

**Severity**: MEDIUM — Performance + potential race condition.
**Recommended Fix**: Pass existing progress to `updateCurrentBelt()`.

---

### BUG-09: Empty quiz `targetRank` fallback to kyu10 (LOW)

**File**: `lib/services/quiz_service.dart` **Lines**: 183–185

```dart
targetRank: questions.isNotEmpty ? questions.first.targetRank : BeltRank.kyu10,
```

**Severity**: LOW — Edge case, no crash, slightly misleading data.

---

### BUG-10: `FuzzyMatchService` and `SearchService` romanization maps are inconsistent (LOW)

**File**: `lib/services/fuzzy_match_service.dart` **Lines**: 24–34 vs `lib/services/search_service.dart` **Lines**: 232–248

`SearchService` has explicit compound mappings (`sya→sha`, `syu→shu`, etc.) while `FuzzyMatchService` uses only `sy→sh`, `ty→ch`. Functionally equivalent but inconsistent.

**Severity**: LOW — Code smell, no functional difference.

---

### BUG-11: `ExportBundle` model uses `List<Object>` placeholders (LOW)

**File**: `lib/models/export_bundle.dart` **Lines**: 33, 39, 45

Stale TODOs from CL2. Not used by `ExportService`. Dead code.

**Severity**: LOW — Dead code, no impact.

---

### BUG-12: `UserProgress.==` only checks `currentRank` and `startDate` (LOW)

**File**: `lib/models/user_progress.dart` **Lines**: 47–51

Two instances with same rank/date but different `completedTechniques` compare as equal. Could cause Riverpod to skip state notifications when techniques are toggled.

**Severity**: LOW — Possible stale UI.

---

## 3. Logic Chain

1. **SM-2 Algorithm**: Verified formula `EF' = EF + (0.1 - (5-q) * (0.08 + (5-q) * 0.02))` against PRD line 310–311. EF clamped at 1.3 ✅. Intervals: I(1)=1, I(2)=6, I(n)=I(n-1)*EF ✅. Code uses `newEaseFactor` for interval calculation, which matches standard SM-2. Tests verify all quality levels, clamping, progression chains. **Correct.**

2. **Review Service**: Proper `Result<T>` throughout. Division-by-zero handled (retentionRate returns 0.0). Card creation defaults correct (EF=2.5, interval=0). Comprehensive test coverage.

3. **Progress Service**: BUG-01 is the most impactful finding — completion calculation only counts kihon+kata, ignoring all other requirement types. This undermines belt advancement validation since `canAdvanceTo()` gates solely on completion percentage.

4. **Quiz Service**: Well-structured question generation. Distractor duplication (BUG-04, BUG-05) are edge cases. Fill-in-blank correctly delegates to FuzzyMatchService. Division by zero handled in `QuizAttemptResult.scorePercentage`.

5. **Search vs FuzzyMatch**: Two implementations of the same conceptual pipeline with different thresholds. FuzzyMatchService uses PRD-compliant 80% similarity. SearchService uses fixed ≤2 edit distance. Inconsistent.

6. **Export/Import**: Robust validation framework. Duration truncation (BUG-03) is the main issue. Round-trip test exists but doesn't catch the truncation because it seeds data in whole minutes.

---

## 4. Caveats

- **Content data not audited**: `lib/data/syllabus_data.dart`, `techniques_data.dart`, `kata_data.dart` not read. Content accuracy bugs may exist.
- **DAO implementations**: Only `review_dao.dart` fully read. `progress_dao.dart` and `quiz_dao.dart` assumed correct per mocking.
- **Provider layer**: `lib/providers/*.dart` not audited.
- **PRD `CardReviewState.validate()`**: Not implemented in actual code (review_dao.dart). Spec-vs-impl gap.
- **No concurrency analysis**: Drift handles SQLite concurrency internally.

---

## 5. Conclusion

### Priority Fix Order

| Priority | Bug | Description | Impact |
|----------|-----|-------------|--------|
| 🔴 P0 | BUG-01 | Completion % ignores fitness/kumite/terminology | Premature belt advancement |
| 🔴 P1 | BUG-03 | Session duration truncated on export | Data loss on round-trip |
| 🟡 P1 | BUG-02 | `advanceBelt()` skips validation | Belt skip possible |
| 🟡 P2 | BUG-06 | Search uses absolute Levenshtein, not % | False positive searches |
| 🟡 P2 | BUG-04 | MC options can contain correct answer as distractor | Confusing quiz |
| 🟡 P2 | BUG-05 | Kata move count MC duplicate options | Confusing quiz |
| 🟡 P2 | BUG-07 | Import doesn't validate correctReviews ≤ totalReviews | Data integrity |
| 🟡 P2 | BUG-08 | advanceBelt double-reads progress | Performance + TOCTOU |
| 🟢 P3 | BUG-09 | Empty quiz targetRank fallback | Minor UX |
| 🟢 P3 | BUG-10 | Romanization map inconsistency | Code smell |
| 🟢 P3 | BUG-11 | ExportBundle uses List\<Object\> | Dead code |
| 🟢 P3 | BUG-12 | UserProgress equality too loose | Possible stale UI |

### Test Coverage Assessment

| Service | Test File | Quality | Gaps |
|---------|-----------|---------|------|
| SM-2 Algorithm | sm2_algorithm_test.dart (445 lines) | ✅ Excellent | None |
| Review Service | review_service_test.dart (468 lines) | ✅ Excellent | None |
| Quiz Service | quiz_service_test.dart (544 lines) | 🟡 Good | No duplicate options test, no matchPairs type test |
| Progress Service | progress_service_test.dart (572 lines) | 🟡 Good | No advanceBelt-without-canAdvanceTo test, no fitness completion test |
| Search Service | search_service_test.dart (373 lines) | 🟡 Good | No short-string false positive test |
| Export Service | export_service_test.dart (666 lines) | ✅ Excellent | No sub-minute duration round-trip test |
| Fuzzy Match | (inline in quiz_service_test) | 🟡 Good | No dedicated test file |

---

## 6. Verification Method

1. **BUG-01**: Add test — belt with fitness+kumite requirements, mark only kihon+kata complete → verify completion < 1.0. Currently returns 1.0.

2. **BUG-03**: Export→import a session with `Duration(seconds: 90)`. Verify round-trip preserves 90s. Currently truncates to 60s.

3. **BUG-02**: Call `advanceBelt(BeltRank.shodan)` from kyu10 without `canAdvanceTo()`. Verify it succeeds (it shouldn't).

4. **BUG-05**: Generate quiz for kata with `moveCount=1`. Verify MC options contain no duplicates.

5. **BUG-06**: Search "ma" (2 chars). Verify no false-positive matches with edit distance = full string length.

```bash
export PATH="/usr/local/google/home/adesimpson/flutter-sdk/bin:$PATH"
cd /usr/local/google/home/adesimpson/docklands-dojo
flutter test test/services/
```
