# iOS Build & TestFlight Preparation — Sanative Vibez

## 1. Current state (as of Milestone 3)

- **Bundle Identifier:** `com.sanativevibez.app` (corrected in Milestone 3 — previously the same incorrect `com.sanativevibez.stressreset` value found on Android, updated across all 6 Xcode build configuration entries in `ios/Runner.xcodeproj/project.pbxproj`, covering the Runner and RunnerTests targets' Debug/Release/Profile configurations).
- **App Display Name:** "Sanative Vibez" (corrected from a leftover template value "Dreamflow" in `ios/Runner/Info.plist`).
- **iOS Deployment Target:** 15.1 (set in the Xcode project; unchanged, was already reasonable for current App Store requirements).
- **Version:** `MARKETING_VERSION` / `CFBundleShortVersionString` derived from `pubspec.yaml` (`1.0.0`); `CURRENT_PROJECT_VERSION` / `CFBundleVersion` derived from the Flutter build number (defaults to `1`, since no `+build` suffix is set in `pubspec.yaml`).
- **Code signing:** `CODE_SIGN_STYLE = Automatic` — no `DEVELOPMENT_TEAM` is currently set in the project. This means **no Apple Developer Team is wired into this project yet**.
- **No provisioning profiles, certificates, or App Store Connect app record exist for this project in this environment.**

## 2. What is blocked without client-owned Apple Developer access

Building a signed, distributable iOS `.ipa` for TestFlight requires, at minimum:
- An active **Apple Developer Program** membership (individual or organization) — $99/year, owned by the client.
- A **Development Team ID** from that account, set as `DEVELOPMENT_TEAM` in Xcode signing settings.
- An **App ID** registered in the Apple Developer portal matching `com.sanativevibez.app`.
- A **distribution certificate** and **provisioning profile** (Xcode can auto-manage these once signed into the correct Apple ID with `CODE_SIGN_STYLE = Automatic`, as is already configured).
- An **App Store Connect** app record for `com.sanativevibez.app`, created under the same developer account, to receive TestFlight builds.
- A **macOS machine with Xcode installed** to build and archive the `.ipa` (iOS release builds cannot be produced on Windows/Linux — this is an Apple platform requirement, not specific to this project).

**None of the above exists in this project or this development environment.** No Apple Developer account credentials, certificates, or macOS/Xcode build machine were available during Milestone 3, so **no signed iOS build or TestFlight upload has been performed or can be claimed as complete.**

## 3. What was verified in this environment

- The Bundle ID, display name, and deployment target are correct and consistent across the Xcode project file (verified by direct inspection of `project.pbxproj` and `Info.plist`).
- `flutter analyze` and `flutter test` (platform-agnostic Dart/Flutter checks) pass cleanly — this validates the app's Dart code, which is shared across iOS/Android/Web, but does **not** validate iOS-specific native build steps (CocoaPods install, Xcode archive, code signing), which require macOS.
- `ios/Podfile` and `ios/Podfile.lock` are present and unmodified — no new native iOS dependencies were introduced.

## 4. Steps the client (or a developer with macOS + Apple Developer access) must perform

### Step 1 — Confirm Apple Developer account & register the App ID
In the [Apple Developer portal](https://developer.apple.com/account/), under **Certificates, Identifiers & Profiles → Identifiers**, register `com.sanativevibez.app` if not already present.

### Step 2 — Set the Development Team in Xcode
Open `ios/Runner.xcworkspace` in Xcode (not `.xcodeproj` — CocoaPods requires the workspace). Under **Runner target → Signing & Capabilities**, select the correct Team from the Apple Developer account. With `Automatically manage signing` enabled (already the project default), Xcode will provision the certificate and profile automatically.

### Step 3 — Install CocoaPods dependencies (macOS only)
```bash
cd ios
pod install
cd ..
```

### Step 4 — Build the release iOS app
```bash
flutter clean
flutter pub get
flutter build ipa --release
```
Output: `build/ios/ipa/*.ipa`

If Xcode reports a signing error, it almost always means the Team/App ID/provisioning step above hasn't been completed yet — this is expected until Apple Developer access is connected.

### Step 5 — Upload to App Store Connect / TestFlight
Either:
- Use **Xcode Organizer** (Window → Organizer → Archives → Distribute App → App Store Connect → Upload), or
- Use `xcrun altool` / Transporter app with an App Store Connect API key.

Once uploaded, the build appears in **App Store Connect → TestFlight** after Apple's automated processing (usually a few minutes to an hour).

### Step 6 — Invite testers
In App Store Connect → TestFlight:
- **Internal testers**: added directly via their Apple ID email, must be part of the Apple Developer team, no App Review needed — fastest option.
- **External testers**: added via email or a public TestFlight link, requires a brief Apple **Beta App Review** (usually within 24–48 hours) before external testers can install.

Testers install the **TestFlight app** from the App Store, then accept the invite link or code to install the build.

## 5. Summary

| Item | Status |
|---|---|
| Bundle ID corrected & consistent | Done |
| App display name corrected | Done |
| Deployment target verified | Done (15.1, unchanged) |
| Apple Developer Team connected | **Blocked — requires client's Apple Developer account** |
| Certificates/provisioning profiles | **Blocked — requires Step 1–2 above** |
| Signed `.ipa` build | **Not performed — requires macOS + signing setup** |
| TestFlight upload | **Not performed — requires the above** |
| Tester invitation | **Not performed — requires the above** |

No claim is made that any iOS build, signing, or TestFlight distribution step has been completed. This document exists to give the client (or whoever holds Apple Developer access) the exact remaining steps.
