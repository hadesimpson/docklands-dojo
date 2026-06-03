# Content Validation Status

> ⚠️ **Safety**: Wrong technique descriptions can cause physical injury. All content MUST be validated.

| Content File | Items | Reviewer | Date | Status |
|-------------|-------|----------|------|--------|
| techniques_data.dart | 100+ techniques | adesimpson@ | TBD | ⬜ Pending |
| kata_data.dart | 20+ kata | adesimpson@ | TBD | ⬜ Pending |
| syllabus_data.dart | 11 belt reqs | adesimpson@ | TBD | ⬜ Pending |
| flashcards_data.dart | 200+ cards | adesimpson@ | TBD | ⬜ Pending |
| quiz_questions_data.dart | 150+ questions | adesimpson@ | TBD | ⬜ Pending |

## Validation Criteria
- [ ] All technique descriptions checked against IKO-1 published syllabus
- [ ] Japanese terminology verified (rōmaji spelling)
- [ ] Belt-to-technique mappings correct for IKO-1
- [ ] Kata movement sequences verified (order, count)
- [ ] Fitness requirement numbers match IKO-1 grading standards
- [ ] Dojo Kun text verified against original Japanese
- [ ] No safety-critical errors in technique descriptions (wrist alignment, pivot mechanics, etc.)

## Process

1. **AI generates** initial content (CL4, CL9, CL11)
2. **Automated validation** (unit tests): structure integrity, ID uniqueness, cross-reference resolution, move count consistency
3. **Expert review** (adesimpson@ as practicing Kyokushin karateka): verify against IKO-1 syllabus, check technique descriptions for accuracy
4. **Document** validation status in this file
