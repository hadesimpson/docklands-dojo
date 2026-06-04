# Handoff Report: Android APK Debug Build Fix

## Observation

1. **Original error**: `flutter build apk --debug` failed with:
   ```
   Dependency ':flutter_local_notifications' requires core library desugaring to be enabled for :app.
   ```

2. **File modified #1**: `android/app/build.gradle.kts` (line 13, lines 48-50)
   - Added `isCoreLibraryDesugaringEnabled = true` in `compileOptions` block
   - Added `dependencies { coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") }` after `flutter` block
   - Set `compileSdk = 36` (was `flutter.compileSdkVersion` which resolved to 34)

3. **File modified #2**: `android/build.gradle.kts` (lines 21-31)
   - Added `subprojects` block with `afterEvaluate` to force `compileSdk = 36` on all Android library subprojects (Flutter plugins like `file_picker`)
   - Guarded with `project.name != "app"` to avoid `afterEvaluate` crash on `:app` (already evaluated via `evaluationDependsOn`)

4. **Cascading errors encountered and fixed**:
   - Error 1 (original): Core library desugaring not enabled → fixed in app build.gradle.kts
   - Error 2: CMake/NDK incompatibility → resolved by `flutter clean`
   - Error 3: `flutter_plugin_android_lifecycle` requires compileSdk 36+ → bumped compileSdk in app
   - Error 4: Plugin subprojects (`:file_picker`) still at compileSdk 34 → forced via root build.gradle.kts
   - Error 5: `afterEvaluate` crash on already-evaluated `:app` → guarded with name check
   - Error 6: `projectsEvaluated` too late to set compileSdk → switched to guarded `afterEvaluate`

## Logic Chain

1. `flutter_local_notifications` uses Java 8+ APIs → requires desugaring → added flag + dependency
2. Desugaring fix revealed compileSdk 34 < required 36 by `flutter_plugin_android_lifecycle`
3. App-level compileSdk fix didn't affect plugin subprojects → needed root-level override
4. Gradle evaluation ordering required careful timing of the override

## Caveats

- The `share_plus` KGP warning is pre-existing and non-blocking (future Flutter versions may require plugin update)
- Drift database warnings in tests are pre-existing and non-blocking
- The `flutter.compileSdkVersion` override in app build.gradle.kts means Flutter SDK upgrades won't auto-bump compileSdk — may need manual update later

## Conclusion

Android debug APK build is fully fixed. All 3 verification checks pass.

## Verification Method

```bash
export PATH="/usr/local/google/home/adesimpson/flutter-sdk/bin:$PATH"
cd /usr/local/google/home/adesimpson/docklands-dojo
flutter build apk --debug    # ✓ Built app-debug.apk
flutter test                 # +503: All tests passed!
flutter analyze              # No issues found!
```
