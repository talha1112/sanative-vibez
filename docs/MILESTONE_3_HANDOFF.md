# Sanative Vibez — Milestone 3 Handoff Package

**Milestone:** 3 — Final Release Preparation, QA & Handoff
**Scope:** Final Android package configuration, signing/build documentation, QA, privacy/store-release documentation, and source handoff for the already-approved Version 1 scope. No new functionality was added.

## 1. Source code status

- Repository: `talha1112/sanative-vibez` (GitHub), branch `main`.
- Working tree clean prior to this milestone's changes; all Milestone 3 changes are additive/corrective (package identity, app naming, documentation) — no existing feature logic was rewritten.
- Automated tests (60 total) pass; `flutter analyze` reports 0 errors (2 pre-existing, unrelated minor lint infos/warnings, not introduced this milestone).

## 2. Flutter & Dart version requirements

- **Flutter:** 3.44.1 (stable channel) — used to build and test in this environment.
- **Dart:** 3.12.1 (bundled with the above Flutter version).
- **SDK constraint** (`pubspec.yaml`): `sdk: ^3.6.0` — compatible with the above.
- Recommend building with the same or a compatible stable Flutter release to avoid toolchain drift.

## 3. Dependency list

See `PRIVACY_AND_STORE_RELEASE.md` §7 for the full list with purpose and network-use notes. No new dependencies were added in Milestone 3.

## 4. Android package configuration (corrected in Milestone 3)

| Item | Before | After |
|---|---|---|
| `namespace` (`android/app/build.gradle`) | `com.mycompany.CounterApp` (template leftover) | `com.sanativevibez.app` |
| `applicationId` (`android/app/build.gradle`) | `com.sanativevibez.stressreset` (incorrect) | `com.sanativevibez.app` |
| App label (`AndroidManifest.xml`) | `dreamflow` (template leftover) | `Sanative Vibez` |
| `MainActivity.kt` package/path | `com.mycompany.CounterApp`, at `.../kotlin/com/example/counter/` (mismatched) | `com.sanativevibez.app`, at `.../kotlin/com/sanativevibez/app/` (consistent) |

Verified no other files reference the old `com.sanativevibez.stressreset` or template package names (`com.example`, `com.mycompany`) after the change — confirmed via repository-wide search.

## 5. iOS Bundle ID (corrected in Milestone 3, with explicit client confirmation)

| Item | Before | After |
|---|---|---|
| `PRODUCT_BUNDLE_IDENTIFIER` (all 6 build configs in `project.pbxproj`) | `com.sanativevibez.stressreset` | `com.sanativevibez.app` |
| `CFBundleDisplayName` (`Info.plist`) | `Dreamflow` | `Sanative Vibez` |
| `CFBundleName` (`Info.plist`) | `dreamflow` | `SanativeVibez` |

This change was confirmed with the client before being made, since the task instructions specifically required confirmation before altering the iOS Bundle ID.

## 6. Android build instructions

```
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

Full signing setup instructions: see `ANDROID_SIGNING_AND_RELEASE.md`.
Google Play Internal Testing upload steps: see `GOOGLE_PLAY_INTERNAL_TESTING.md`.

**Build status this milestone:** `flutter analyze` and `flutter test` (60/60) both pass cleanly against the corrected package configuration. **The signed release `.aab` itself could not be produced in this development environment** — see the blocker note in §9 below. All Dart-level code, package identity, and configuration changes are verified correct; only the final native Gradle build step is blocked here.

## 7. iOS build instructions

Requires macOS + Xcode + an Apple Developer account (none available in this environment). Full instructions: see `IOS_TESTFLIGHT_PREPARATION.md`. **No iOS build or TestFlight upload was performed or can be claimed as complete** — this requires client-owned Apple Developer access and a macOS build machine, neither of which exists in this environment.

## 8. Environment / configuration requirements

- Android SDK + Android Studio command-line tools (or equivalent), matching `compileSdk`/`minSdk`/`targetSdk` as defined by the Flutter tool (`flutter.compileSdkVersion` etc. in `android/app/build.gradle` — these track whatever Flutter version is used to build).
- NDK version pinned at `27.0.12077973` in `android/app/build.gradle`.
- For iOS: macOS with a current Xcode version supporting iOS deployment target 15.1+, CocoaPods installed.
- No `.env` files, API keys, or backend configuration are required — the app has no backend.

## 9. Known limitations / unresolved blockers

1. **Signed Android release build (`.aab`) could not be produced in this development environment.** `flutter build appbundle --release` requires downloading the Gradle 8.13 distribution (~232MB) from `services.gradle.org` (which redirects to a GitHub/Azure-hosted file). This environment's network egress sustains only ~90KB/s to that host, confirmed across three independent attempts (two full `flutter build` runs — one interrupted, one left to run uninterrupted for 63 minutes and still failing with a truncated/corrupt zip — plus direct `curl` tests that consistently reset or timed out partway through the transfer, topping out around 50MB downloaded in 9 minutes). This is an infrastructure/network constraint of this specific sandboxed environment, not a project configuration problem — `flutter analyze` and all 60 automated tests pass cleanly against the corrected project configuration. **A signed release build should be produced on a normal development machine or CI runner with unrestricted network access** (e.g., the project's existing GitHub Actions setup, or any local machine) using the exact commands documented in `ANDROID_SIGNING_AND_RELEASE.md` — no further code changes are needed for this; it is purely an environment/network capability issue in the sandbox this milestone was executed in.
2. **iOS build/signing/TestFlight**: Blocked on client-owned Apple Developer account access and a macOS build machine. See `IOS_TESTFLIGHT_PREPARATION.md` for exact remaining steps.
3. **Android keystore/signing**: No production keystore exists yet (correctly — this must be generated and held by the client, not embedded in the repo). See `ANDROID_SIGNING_AND_RELEASE.md`.
4. **Google Play Console upload**: Not performed — requires client's Play Console account access, and is additionally blocked on item 1 above (no signed `.aab` was produced in this environment to upload). See `GOOGLE_PLAY_INTERNAL_TESTING.md`.
5. **Physical device testing**: Not performed in this environment (no connected physical Android/iOS device). QA in `MILESTONE_3_QA_REPORT.md` was performed via code inspection, automated tests, and (for items unchanged since Milestone 2) prior browser-based verification.
6. **`MILESTONE_2_DATA_FLOW.md` was missing from the repository** at the start of this milestone despite being referenced in the Milestone 3 task instructions — it appears to have been produced but never committed during Milestone 2. `PRIVACY_AND_STORE_RELEASE.md` now serves as the current, committed replacement.

## 10. Documents included in this handoff

- `docs/MILESTONE_3_QA_REPORT.md` — structured QA test results
- `docs/PRIVACY_AND_STORE_RELEASE.md` — data-flow/privacy documentation, supports store privacy declarations
- `docs/ANDROID_SIGNING_AND_RELEASE.md` — Android signing setup and release build guide
- `docs/GOOGLE_PLAY_INTERNAL_TESTING.md` — Play Console Internal Testing upload steps
- `docs/IOS_TESTFLIGHT_PREPARATION.md` — iOS build/signing/TestFlight steps and blockers
- `docs/MILESTONE_3_HANDOFF.md` — this document

No private credentials, API keys, passwords, keystores, or certificates are included in this handoff or the repository.

## 11. Post-handoff bug-fix period

Per the agreed terms, the post-handoff period covers **bugs against the already-approved Version 1 acceptance criteria** (the items tested in `MILESTONE_3_QA_REPORT.md`) — not new features, design changes outside approved scope, new integrations, or new business requirements. Any request outside that scope should be scoped and quoted separately.
