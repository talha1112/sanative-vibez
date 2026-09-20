# Google Play Internal Testing — Setup Guide

This complements `ANDROID_SIGNING_AND_RELEASE.md`. Use this once you have a signed `app-release.aab`.

## Prerequisites (client-owned)

- A Google Play Console developer account ($25 one-time registration fee if not already registered).
- The Sanative Vibez app listing created in Play Console under `com.sanativevibez.app` (or permission granted to the person doing the upload).

## Steps

1. **Sign in to [Google Play Console](https://play.google.com/console).**
2. If the app doesn't exist yet: **Create app** → enter app name ("Sanative Vibez"), default language, app/game type (App), free/paid (Free), and accept the relevant declarations.
3. Go to **Testing → Internal testing** in the left sidebar.
4. Click **Create new release**.
5. Under **App bundles**, upload `app-release.aab` (from `build/app/outputs/bundle/release/`).
6. Fill in **Release name** (e.g., `1.0.0 (1)`) and **Release notes** (a short internal note is fine, e.g., "Initial internal test build — Version 1.0.0").
7. Click **Save**, then **Review release**, then **Start rollout to Internal testing**.
8. Under the **Testers** tab of the Internal testing track:
   - Create or select an email list of testers, or
   - Use a Google Group.
9. Once testers are added, Play Console shows a **join link** (opt-in URL). Share this link with testers.
10. Testers open the link on their Android device, accept, and the app becomes installable from the Play Store (may take a few minutes to propagate).

## First-time setup notes

- The **first** upload to a given `applicationId` establishes that package name permanently on Play Console for this developer account — this cannot be changed later without publishing under a new package name. This is why confirming `com.sanativevibez.app` is correct before this first upload matters (already corrected in Milestone 3 — see main handoff report).
- Google will prompt to enroll in **Play App Signing** on first upload — recommended, and does not require any code changes on our side.
- Required Play Console declarations (Data Safety, target audience, content rating, etc.) are account/policy-level tasks the client must complete in Play Console directly — see `PRIVACY_AND_STORE_RELEASE.md` for the technical facts needed to fill those in accurately.

## What is NOT done as part of this milestone

- No upload to Google Play Console has been performed — this requires the client's Play Console account access, which was not available in this environment.
- No app listing, store description, screenshots, or content rating questionnaire have been submitted — these are store-listing tasks outside this milestone's engineering scope, and some (screenshots, store description/graphics) are typically supplied or approved by the client.
