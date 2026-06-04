# Worker M2 — Logic Bug Fix Handoff Report

## Observation

Audited all 8 service files listed in the task:
- `lib/services/srs/sm2_algorithm.dart` (80 lines)
- `lib/services/srs/review_service.dart` (252 lines)
- `lib/services/srs/srs_algorithm.dart` (88 lines)
- `lib/services/quiz_service.dart` (484 lines)
- `lib/services/progress_service.dart` (316 lines)
- `lib/services/search_service.dart` (302 lines)
- `lib/services/fuzzy_match_service.dart` (198 lines)
- `lib/services/export_service.dart` (638 lines)
- `lib/services/import_summary.dart` (77 lines)

Also read PRD spec (lines 57-180 for belts, 240-262 for fuzzy matching, 300-368 for SM-2), all existing test files (6 test files, 164 passing tests baseline), and supporting models.

## Bugs Found & Fixed

### Bug 1: SearchService Levenshtein uses absolute threshold instead of PRD-specified percentage
- **File**: `lib/services/search_service.dart`, line 186-190
- **Severity**: Medium
- **Description**: Layer 4 fuzzy matching used `distance <= 2` (absolute distance threshold). PRD at line 255-256 specifies "≥ 80% similarity after normalization". The `FuzzyMatchService` correctly implements `>= 0.80` similarity (line 160), but `SearchService` had a divergent implementation. For short strings (e.g., 3 chars), `distance <= 2` accepts matches with only 33% similarity. For long strings (e.g., 20 chars), `distance <= 2` rejects matches with 90% similarity.
- **Fix applied**: Changed to percentage-based similarity matching: `similarity = 1.0 - (distance / max(queryLen, targetLen)); if (similarity >= 0.8)`. Also updated the class docstring.

### Bug 2: Export/Import missing `correctReviews <= totalReviews` invariant enforcement
- **File**: `lib/services/export_service.dart`, line 550-561
- **Severity**: Medium
- **Description**: When importing card review states, `correctReviews` was clamped at `>= 0` but NOT enforced to be `<= totalReviews`. The PRD's `CardReviewState.validate()` spec (line 351) requires `assert(correctReviews <= totalReviews, 'More correct than total')`. Corrupted or hand-edited import data with `correctReviews > totalReviews` would produce invalid `CardReviewState` objects, potentially causing incorrect retention rate calculations (>100%).
- **Fix applied**: Added clamping so `correctReviews` is bounded by `min(correctReviews, clampedTotalReviews)`.

## Areas Audited — No Bugs Found

### SM-2 Algorithm (sm2_algorithm.dart) ✓
- EF formula `EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))` — matches PRD line 310 ✓
- Interval progression I(1)=1, I(2)=6, I(n)=I(n-1)*EF — correct ✓
- EF minimum clamp at 1.3 via `math.max(minimumEaseFactor, ...)` — correct ✓
- Quality range 0-5 with assert — correct ✓
- Failure handling (q<3) resets reps+interval, still updates EF — correct ✓
- No integer vs float truncation: uses `.round()` on `interval * newEaseFactor` — correct ✓
- Circuit breaker: This is a UI-level behavioral feature ("show hint, reduce interval"), not an algorithm bug. Would be implemented at ReviewService or UI layer.

### Quiz Service (quiz_service.dart) ✓
- MC correct answer always included: options = `[technique.englishName, ...wrongAnswers]` ✓
- Duplicate options: checked all technique englishNames are unique; `_getDistractors` filters by `t.id != technique.id` ✓
- Division by zero: `scorePercentage` has `totalQuestions > 0` guard ✓
- Empty question set: returns `Failure('No techniques found...')` ✓
- Kata MC move counts: all real kata have moveCount >= 20, so `+2/-2/+5` never clashes ✓

### Progress Service (progress_service.dart) ✓
- Belt advancement: `canAdvanceTo` enforces `targetOrder == currentOrder + 1` ✓
- Division by zero: `calculateCompletionPercentage` has `allRequired.isEmpty` guard (returns 0.0) ✓
- No requirement found: returns 0.0 ✓
- kyu1→shodan: BeltRank.order values are 9→10, so `10 == 9+1` works ✓

### FuzzyMatchService (fuzzy_match_service.dart) ✓
- Romanization mappings complete per PRD: si→shi, ti→chi, tu→tsu, hu→fu, zi→ji, di→ji, du→zu, sy→sh, ty→ch ✓
- Similarity threshold ≥ 80% ✓
- Empty input: `checkFillInBlankAnswer` returns false for empty trim ✓
- Note: `RegExp(r'\\s+')` in file display — confirmed via test execution that the actual file contains `RegExp(r'\s+')` (tool output escapes backslashes). Tests verify whitespace collapsing works.

### Export/Import (export_service.dart) ✓ (except Bug 2 above)
- Version validation: checks `version is! int` and `version > _currentExportVersion` ✓
- Date parsing: uses `DateTime.parse()` with ISO 8601 ✓
- Future date handling: clamps to now with warnings ✓
- Null checks: all JSON fields use `as Type?` with null fallbacks ✓
- BeltRank parsing: iterates all values, returns null on unknown ✓

## Logic Chain

1. **Observation**: SearchService line 188 uses `distance <= 2`, while PRD line 256 says "≥ 80% similarity" and FuzzyMatchService line 160 uses `>= _similarityThreshold` (0.80).
2. **Inference**: These should implement the same PRD spec. SearchService diverges from the spec.
3. **Impact**: Short strings like "gi" vs "ki" (distance=1, 50% similar) would match with old code but shouldn't at 80% threshold. Long strings with minor typos that should match (>80% similar) were rejected.
4. **Observation**: Export service `_parseCardState` clamps individual fields but doesn't enforce cross-field invariant `correctReviews <= totalReviews`.
5. **Inference**: The PRD `CardReviewState.validate()` (line 351) explicitly requires this invariant. Imported data could violate it.
6. **Impact**: `RetentionRate = correctReviews / totalReviews` could exceed 1.0 (>100%), breaking UI display and statistics.

## Caveats

- The `view_file` tool escapes `\s` as `\\s` in output. I initially suspected a regex bug in both normalize functions, but confirmed via runtime testing that the actual file content is correct (`RegExp(r'\s+')`) — the tests that verify whitespace collapsing pass.
- Circuit breaker (3 consecutive failures → show hint) is a PRD behavioral requirement but not implementable as an SM-2 algorithm fix. It would need state tracking in `ReviewService` or the UI layer, and represents a missing feature, not a logic bug.
- Kata MC question option deduplication: the current data (all move counts >= 20) makes duplicate options impossible, but the code doesn't explicitly deduplicate. This is a robustness concern, not a current bug.

## Conclusion

**2 genuine logic bugs found and fixed**, both in data integrity/correctness areas:
1. `SearchService` Levenshtein threshold (absolute vs percentage) — fixes search accuracy for both short and long queries
2. `ExportService` missing `correctReviews <= totalReviews` invariant — fixes potential data corruption on import

All other areas (SM-2 algorithm, quiz scoring, progress/belt advancement, fuzzy matching, import validation) were audited and confirmed correct against the PRD spec.

## Verification Method

```bash
# Run service tests (all 164 should pass):
export PATH="/usr/local/google/home/adesimpson/flutter-sdk/bin:$PATH"
cd /usr/local/google/home/adesimpson/docklands-dojo
flutter test test/services/

# Run full suite (503 tests pass as of this handoff):
flutter test

# Verify search service fix specifically:
flutter test test/services/search_service_test.dart

# Verify export service fix specifically:
flutter test test/services/export_service_test.dart
```

**Results**: 503/503 tests pass. Zero failures. Zero regressions.

## Files Modified

| File | Change |
|------|--------|
| `lib/services/search_service.dart` | Levenshtein threshold: `distance <= 2` → `similarity >= 0.8`; updated docstring |
| `lib/services/export_service.dart` | Added `correctReviews` clamping to `<= totalReviews` on import |
