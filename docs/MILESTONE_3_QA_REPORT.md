# Sanative Vibez — Milestone 3 Final QA Report

**Testing method:** This QA pass was performed by direct source-code inspection, the automated test suite (`flutter test`, 60 tests), `flutter analyze`, and a Flutter-web build/browser verification (as used in Milestone 2). **No physical Android or iOS device testing was performed** in this environment — none was available. Where a test case below could only be confirmed via code/logic inspection rather than an interactive tap-through, that is noted explicitly.

## A. First-run experience

| Test case | Expected result | Actual result | Pass/Fail | Notes |
|---|---|---|---|---|
| Onboarding displays on first launch | Onboarding screen shown before Home, gated by `has_onboarded` flag | Confirmed in `lib/screens/splash_screen.dart` / `lib/screens/onboarding_screen.dart`; verified visually in Milestone 2 browser test | Pass | |
| Non-clinical boundary language visible | Onboarding shows a disclaimer that the app is non-clinical | `onboarding_screen.dart` displays: "Sanative Vibez is a non-clinical space for personal reflection and daily practice. It is not medical care, psychotherapy, diagnosis, or treatment..." | Pass | |
| No prohibited medical/therapeutic claims | No language implying diagnosis, treatment, or cure | Reviewed all screen copy (`home_screen.dart`, `check_in_flow.dart`, `daily_prompt_screen.dart`, `calm_library_screen.dart`, `about_screen.dart`, `insights_screen.dart`) — no medical/treatment/diagnostic claims found | Pass | |

## B. Daily Check-in

| Test case | Expected result | Actual result | Pass/Fail | Notes |
|---|---|---|---|---|
| Fresh check-in flow (feeling → support → intention) | Completes and saves | Verified by `test/check_in_flow_test.dart` (57 automated cases covering every feeling/support combination via the fresh entry path) | Pass | |
| Shortcut/pre-filled flow (feeling pre-selected via Home card) | Completes and saves, same result as fresh path | Verified by the same test file's "shortcut path" and "both entry paths agree" cases | Pass | |
| Data is saved correctly | `CheckIn` persisted to `shared_preferences` under `check_ins` key | Confirmed in `lib/services/storage_service.dart` | Pass | |
| No scores/severity/rankings/health-progress framing | Check-in options are named states ("Grounded," "Full," "Weary"), not numeric or ranked | Confirmed in `check_in_flow.dart` — no numeric scale, no severity labels | Pass | |

## C. Reflection History

| Test case | Expected result | Actual result | Pass/Fail | Notes |
|---|---|---|---|---|
| Entries display chronologically | Newest-first list of check-ins + daily reflections | Confirmed in `lib/screens/insights_screen.dart` — combines and sorts both by date descending | Pass | |
| No charts/rankings/scores/ordinal indicators | Plain list, no `fl_chart` or numeric scoring | Confirmed — `fl_chart` package was removed in Milestone 2; screen renders text cards only | Pass | |
| Empty state works | Shows an empty-state message when no data exists | Confirmed in `insights_screen.dart` (`_buildEmptyState`) and by `test/storage_service_test.dart` ("fresh install has no check-ins or reflections") | Pass | |
| Reflection/journal content displays correctly | Prompt, chip response, and free-text journal entry all shown | Confirmed in `_HistoryCard._buildReflection()` | Pass | |

## D. Clear My Data

| Test case | Expected result | Actual result | Pass/Fail | Notes |
|---|---|---|---|---|
| Confirmation dialog works | Tapping "Clear My Data" shows a confirm/cancel dialog | Confirmed in `about_screen.dart` (`_confirmAndClearData`) | Pass | |
| Data is removed | `check_ins` and `daily_reflections` keys cleared | Confirmed by `test/storage_service_test.dart` ("clearAllUserData removes all check-ins and reflections") | Pass | |
| History becomes empty after deletion | Reflection History shows empty state post-clear | Follows directly from C (empty-state test) + D (clear test) — both verified independently | Pass | |
| Data does not return after restart | No re-seeding of demo/sample data on next load | Confirmed — `StorageService._getSampleData()` (the old demo-data seeder) was deleted in Milestone 2; `getCheckIns()`/`getDailyReflections()` return `[]` on empty storage with no fallback seeding | Pass | |

## E. 7-Day Personal Practice / Vibe With Us

| Test case | Expected result | Actual result | Pass/Fail | Notes |
|---|---|---|---|---|
| Correct approved heading/body on Home | "The Sanative Vibez Experience" + "Explore seven days of intentional affirmations, reflection, and personal practice—at your own pace." | Confirmed in `lib/screens/home_screen.dart` lines ~245, ~252 | Pass | |
| "Vibe With Us" wording correct | Button on Home reads "Vibe With Us"; bottom nav tab reads "Vibe With Us"; About screen section reads "Vibe With Us" | Confirmed in `home_screen.dart`, `widgets/bottom_nav.dart`, `about_screen.dart` | Pass | |
| Link opens the correct URL | `https://www.sanativevibez.com/start-your-7-day-experience` | Confirmed in all four link locations (Home card, bottom nav tab, About "Vibe With Us" section, Daily Prompt "custom-created frequencies" link) | Pass | |
| External links open only after user interaction | No auto-launch on screen load | Confirmed — all `launchUrl` calls are inside `onPressed`/`onTap` handlers, none in `initState`/`build` | Pass | |
| No medical/physiological/outcome claims in this copy | Confirmed | No claims of measuring, treating, or guaranteeing outcomes in the approved copy | Pass | |

## F. Offline and network behavior

| Test case | Expected result | Actual result | Pass/Fail | Notes |
|---|---|---|---|---|
| Normal app usage works without network | Check-ins, reflections, history, clear-data all local | Confirmed — all persistence goes through `shared_preferences` (`storage_service.dart`); no HTTP/API calls exist in `lib/` outside `url_launcher` (user-initiated only) | Pass | |
| No analytics/tracking/ads/subscriptions/backend/push notifications | Confirmed absent | `pubspec.yaml` dependency list reviewed — no analytics, ad, payment, backend, or push-notification packages present | Pass | |
| Fonts remain locally bundled | `.ttf` files present under `assets/fonts/`, not fetched at runtime | Confirmed — 8 font files present, `pubspec.yaml` registers `assets/fonts/`, `main.dart` sets `GoogleFonts.config.allowRuntimeFetching = false` | Pass | |
| No runtime Google Fonts fetching | Confirmed via prior network trace (Milestone 2) | Verified previously via Playwright network trace against a `flutter build web` output — zero requests to `fonts.gstatic.com`/`fonts.googleapis.com` for Inter/Playfair Display during navigation | Pass | Re-verification for Milestone 3 relied on unchanged code (`main.dart`, `pubspec.yaml`, `assets/fonts/` untouched this milestone) rather than re-running the browser trace |

## G. Visual and stability checks

| Test case | Expected result | Actual result | Pass/Fail | Notes |
|---|---|---|---|---|
| Typography displays correctly | Playfair Display headings, Inter body text | Verified visually via Flutter-web screenshots in Milestone 2 (onboarding, Home, About screens) | Pass | Not re-screenshotted this milestone since no typography-affecting code changed |
| Navigation works | Bottom nav, check-in flow, practice detail screens all route correctly | Confirmed via `lib/nav.dart` route table inspection and the 57 passing navigation-dependent tests in `check_in_flow_test.dart` | Pass | |
| No obvious overflow/layout errors | No Flutter overflow warnings in reviewed screens | `flutter analyze` reports 0 errors; no `RenderFlex overflowed` patterns found in reviewed widget trees | Pass | Static analysis + code review only; not confirmed on a live rendered device this milestone |
| No crashes in tested flows | All 60 automated tests pass without exceptions | `flutter test` — 60/60 passed | Pass | |

## Commands run for this QA pass

```
flutter clean
flutter pub get
flutter analyze        → 2 pre-existing, unrelated minor lint items (not introduced this milestone); 0 errors
flutter test           → 60/60 passed
flutter build appbundle --release   → BLOCKED in this environment: Gradle distribution download from services.gradle.org sustains only ~90KB/s here and fails/times out before completing (~232MB required); see MILESTONE_3_HANDOFF.md §9 item 1 for full details. Not a code/config issue — analyze and test both pass.
```

## Summary

All functional and content-based Version 1 acceptance criteria reviewed for Milestone 3 **pass** based on code inspection, the automated test suite, and prior (Milestone 2) browser-based visual/network verification for items that were not touched in this milestone. No physical-device testing (Android phone/tablet or iOS device) was performed — this environment does not have a connected physical device or an iOS/macOS build machine available. If physical-device testing is required before sign-off, that should be performed separately (see blockers in the main handoff report).
