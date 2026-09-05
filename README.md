# Sidratul Montaha — Portfolio

A responsive Flutter web portfolio focused on production mobile engineering.

The site leads with the live Grozziie Android and iOS product, presents selected
engineering work, and includes a searchable archive of every public GitHub
repository.

## Highlights

- Production Grozziie case study with official Google Play and App Store imagery
- Selected Flutter, Android, desktop, package, and ML projects
- Searchable public GitHub repository archive refreshed hourly by GitHub Actions
- Responsive layouts for desktop, tablet, and mobile
- Accurate experience, education, contact, and profile information
- Lightweight HTML introduction with usable CV/contact links while Flutter starts
- Viewport-triggered images with stable placeholders and reduced-motion support

## Run locally

```bash
bash tool/sync_github_repositories.sh
flutter pub get
flutter run -d chrome
```

## Build for GitHub Pages

```bash
flutter build web --base-href /portfolio-website-flutter/
```

## Loading and caching

`web/index.html` contains the initial introduction. Keep its CV, contact, and
social links aligned with `lib/portfolio_app.dart`. Flutter's versioned bootstrap
is inlined at build time, so an older cached loader cannot hold back a new build.
The existing generated service worker still handles repeat-visit caching; this
project remains pinned to Flutter 3.29.2 in the deployment workflow.

`ProgressiveAssetImage` reserves each image's existing layout slot and starts its
request within 200 logical pixels of the viewport. It watches ancestor scroll
positions (including nested galleries), supports resizing, and uses Flutter's
normal image cache. Supply bounded parent constraints or explicit dimensions.
The portrait uses `hero_portrait_2026_v2.webp` (70.5 KB); its original PNG is kept
as source material. When replacing an image, use a new filename to avoid stale
browser copies.

Run `flutter test` to check image deferral, nested scrolling, resizing, missing
image fallbacks, gallery controls, and the existing portfolio interactions.
Performance checks should measure the HTML introduction and Flutter readiness
separately: displaying the introduction early does not eliminate engine startup.
