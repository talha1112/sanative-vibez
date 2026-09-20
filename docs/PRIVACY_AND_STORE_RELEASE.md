# Sanative Vibez — Privacy & Store-Release Technical Reference (Milestone 3)

This document supersedes and updates `MILESTONE_2_DATA_FLOW.md` (which described the app's data flow as of Milestone 2) to reflect the current, verified state of the codebase as of Milestone 3. It is a technical reference only — it does not constitute legal advice, and does not complete any store declaration on the client's behalf. Anywhere a policy judgment call is required, it is flagged for client confirmation.

## 1. Data stored locally on the device

All user-generated content is stored only on-device via `shared_preferences` (a local key-value store; no server, no account, no sync).

Stored data:
- **Check-ins** (`check_ins` key): selected feeling (Grounded / Full / Weary), selected support need, chosen intention, timestamp.
- **Daily reflections** (`daily_reflections` key): the day's prompt, the chip response selected, optional free-text journal entry, timestamp.
- **Onboarding flag** (`has_onboarded`): boolean, app configuration only — not personal content.

No accounts, emails, device identifiers, advertising IDs, or location data are collected or stored anywhere in the app.

## 2. Data leaving the device

None. There is no backend, no remote database, and no cloud sync anywhere in the codebase (confirmed — no HTTP client usage outside `url_launcher`, no Firebase or other backend SDK present in `pubspec.yaml`). The only way data could leave the device is standard OS/browser behavior when a user taps one of the external links below — the app does not transmit any user-generated content (check-ins, reflections) to those links; they are static informational URLs with no data appended.

## 3. External links (user-initiated only)

| Link text | Destination | Location(s) |
|---|---|---|
| "Vibe With Us" button | `https://www.sanativevibez.com/start-your-7-day-experience` | Home screen card |
| "Vibe With Us" tab | `https://www.sanativevibez.com/start-your-7-day-experience` | Bottom navigation |
| "Learn About the 7-Day Practice" | `https://www.sanativevibez.com/start-your-7-day-experience` | About screen |
| "Learn about custom-created frequencies" | `https://www.sanativevibez.com/start-your-7-day-experience` | Daily Prompt screen |
| "Visit Sanative Vibez online" | `https://www.sanativevibez.com` | About screen |

All confirmed to be triggered only from `onPressed`/`onTap` handlers — none fire automatically on screen load or app start.

## 4. Network activity

Normal app usage (check-ins, daily prompts, calm library, reflection history, clearing data, onboarding, navigation) makes **no network requests** — confirmed by code inspection (all persistence is local) and by the Milestone 2 browser network trace, which showed zero requests to any Sanative Vibez, analytics, or font CDN endpoint during normal navigation on a built web version of the app.

No analytics, crash reporting, advertising, or tracking SDKs are present anywhere in `pubspec.yaml` or the native Android/iOS project files.

## 5. Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`): No runtime permissions declared — no location, camera, microphone, contacts, notifications, storage, or Bluetooth permissions. A `<queries>` entry for `android.intent.action.PROCESS_TEXT` is present; this is standard Flutter-engine boilerplate for text-selection features, not a permission grant. Reviewed again in Milestone 3 — unchanged since Milestone 2, still correct.

**iOS** (`ios/Runner/Info.plist`): No privacy-sensitive usage-description keys present (no camera, location, microphone, contacts, etc. usage strings). Reviewed again in Milestone 3 — unchanged, still correct.

No new permissions were added in Milestone 3.

## 6. Fonts

Fonts are bundled locally as static `.ttf` files under `assets/fonts/` (Inter and Playfair Display, Regular/Medium/SemiBold/Italic weights). `main.dart` sets `GoogleFonts.config.allowRuntimeFetching = false`. This was implemented and verified in Milestone 2 (network trace confirmed zero font-CDN requests) and is unchanged in Milestone 3.

## 7. Dependencies (as of Milestone 3)

| Package | Purpose | Network use |
|---|---|---|
| `flutter` (SDK) | Framework | n/a |
| `go_router` | In-app navigation | None |
| `provider` | State management scaffolding | None |
| `shared_preferences` | Local on-device storage for check-ins/reflections | None |
| `google_fonts` | Typography (Inter, Playfair Display) | None — runtime fetching disabled, fonts load from bundled assets |
| `intl` | Date formatting | None |
| `url_launcher` | Opens external URLs on user tap | Only when the OS opens a tapped link |
| `cupertino_icons` | Icon set | None |
| `flutter_test`, `flutter_lints`, `flutter_launcher_icons` | Dev-only tooling | None (build-time only) |

No new packages were added in Milestone 3; no packages were removed either (Milestone 2 already removed `fl_chart`/`equatable`).

## 8. Third-party services

None. No analytics, crash reporting, advertising network, remote backend, or authentication provider is integrated anywhere in the project.

## 9. Support for store privacy declarations

- **Apple Privacy Nutrition Label**: Based on the above, no data is collected that is linked to the user's identity or transmitted off-device. The app does not appear to require declaring any data collection category, since nothing is collected by the developer — **the client should make this determination directly in App Store Connect**, as only Apple's own questionnaire and the client's final judgment can complete this declaration.
- **Google Play Data Safety**: Based on the above, "No data collected" appears to accurately describe the app's behavior — **the client should confirm and submit this in Play Console** directly, as this is an account-level declaration Anthropic/this development work cannot submit on the client's behalf.
- **Google Play Health Apps declaration**: The app is scoped as a non-clinical personal reflection and daily-practice companion — all check-in/reflection copy avoids medical, diagnostic, symptom, severity, or health-outcome language (confirmed in the Milestone 3 QA report, section A). **Whether this exempts the app from Google Play's Health Apps policy category is a policy determination only the client (or Google, upon review) can make** — this document provides the technical facts to support that determination but does not make the determination itself.

## 10. Items requiring client confirmation

- Final sign-off on the Play Data Safety and Apple Privacy Nutrition Label forms (technical facts are documented above; the client must submit these in their own Play Console / App Store Connect accounts).
- Confirmation that the Health Apps category determination (§9) matches the client's understanding of Google Play policy for this app.
- No other open items from Milestone 2's privacy audit remain — the font network-fetch issue flagged in the original `MILESTONE_2_DATA_FLOW.md` was resolved prior to this milestone (fonts bundled locally, runtime fetching disabled, verified via network trace).

**Note:** the original `MILESTONE_2_DATA_FLOW.md` file referenced in the Milestone 3 task instructions was not present in the repository at the start of this milestone (it appears to not have been committed in Milestone 2, despite being produced at the time). This document (`PRIVACY_AND_STORE_RELEASE.md`) now serves as the current, accurate, committed privacy/data-flow reference going forward.
