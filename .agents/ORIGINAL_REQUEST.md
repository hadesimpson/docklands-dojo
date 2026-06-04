# Original User Request

## Initial Request — 2026-06-04T07:11:24Z

Deep QA review and bug fix pass on the Docklands Dojo Flutter app — a Kyokushin Karate training companion built with Flutter 3.44, Drift (SQLite), Riverpod, and GoRouter. Fix all failing tests, resolve analyzer warnings, audit all source files for logic bugs, verify IKO-1 content accuracy, and review performance.

Working directory: /usr/local/google/home/adesimpson/docklands-dojo
Integrity mode: development

Flutter SDK: export PATH="/usr/local/google/home/adesimpson/flutter-sdk/bin:$PATH"

Reference: PRD at /usr/local/google/home/adesimpson/.gemini/jetski/brain/0548b6ed-0a9a-4f37-97f1-02b79aeae43b/docklands_dojo_prd.md

## Requirements

### R1. Fix all failing tests
13 widget tests currently fail (belt_list_screen, flashcard_screen). Diagnose root causes and fix. Target: 0 failures across the full suite.

### R2. Zero analyzer warnings
`flutter analyze` should produce zero warnings and zero errors.

### R3. Logic bug audit
Review all services (progress, quiz, SM-2, search, export/import) for:
- Off-by-one errors in belt progression and quiz scoring
- Null/empty collection edge cases
- Incorrect SM-2 algorithm math (EF minimum 1.3, interval progression 1→6→6*EF)
- Quiz question generation producing invalid states (duplicate options, missing correct answer)
- Fuzzy match false positives/negatives (romanization mapping, Levenshtein threshold)
- Export/import data integrity gaps (version validation, date clamping, round-trip fidelity)
- Belt progression logic errors (skipping belts, advancing to wrong rank, completion % calculation)

### R4. UI integrity check
Review all screens for:
- Provider wiring errors (wrong provider, missing overrides, stale state)
- Navigation dead ends (screens that can't navigate back)
- Missing error/loading states on async operations
- Accessibility gaps (missing Semantics labels on interactive elements)
- Dark mode rendering issues (contrast, readability)

### R5. IKO-1 content accuracy
Verify all Kyokushin content against IKO-1 standards:
- Belt color progression (10th Kyu white through Shodan black, including stripe belts at kyu8/kyu6/kyu4)
- Technique Japanese names are correctly romanized
- Kata list is complete (22 kata from Taikyoku through Seipai)
- Fitness requirements match IKO-1 grading standards (push-up/squat/sit-up counts per belt)
- Kumite type categorization is accurate
- Terminology flashcards use correct Japanese terms

### R6. Performance review
Audit for performance issues:
- Unnecessary widget rebuilds (providers triggering too broadly)
- Expensive DB queries without pagination or limits
- Large const data structures loaded eagerly when they could be lazy
- Search service performance with full technique list
- Memory leaks from undisposed controllers or streams

### R7. Build verification
App must build successfully: `flutter build apk --debug`

## Acceptance Criteria

### Test Suite
- [ ] `flutter test` — 0 failures, 0 errors
- [ ] All existing passing tests continue to pass (no regressions)
- [ ] Any new bug fixes include corresponding test coverage

### Static Analysis
- [ ] `flutter analyze` — 0 issues (warnings or errors)
- [ ] `dart format .` — 0 formatting changes needed

### Build
- [ ] `flutter build apk --debug` completes successfully

### Content Accuracy
- [ ] All 11 belt colors match IKO-1 standard (verified against reference)
- [ ] All 22 kata are present with correct Japanese names and minimum rank assignments
- [ ] Technique count ≥ 72 across all 9 categories
- [ ] Fitness requirement numbers are non-zero and increase with rank

### Code Quality
- [ ] No service method returns raw exceptions (all use Result<T>)
- [ ] No provider wiring errors (verified by running the app's test suite)
- [ ] All screens handle loading, error, and empty states

### Bugs Found
- [ ] All bugs found are documented with: file, line, description, severity, fix applied
- [ ] A summary report is produced listing all issues found and their resolutions
