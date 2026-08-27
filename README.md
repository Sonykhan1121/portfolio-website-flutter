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
