# Selected-work previews and galleries

Only section 02 uses these project previews. Hovering for 160 ms requests one
cover image; until decoding succeeds, the original card remains visible.
The cover is non-interactive and the card still opens its repository. The
separate, keyboard-accessible Preview button opens a screenshot dialog and
never launches a repository. Touch visitors can use the same Preview button.

Each dialog renders one screenshot at a time. Left/right buttons and arrow
keys browse the images; Escape or Close dismisses it. Arrows disable at the
ends, and focus returns to the triggering button. Pinch/zoom is supported in
the viewer. A loading indicator appears while a requested image decodes.
Hover covers and gallery images are excluded from startup preloads and from
`generate_image_previews.cjs`; normal Flutter/browser image caching still works.

## Sources and selections

The first five galleries contain actual repository README screenshots. The
sixth uses the supplied attendance demo's source-rendered screenshots, not
AI-created app mockups. Captions/order are in `lib/data/project_screenshots.dart`.
Images are optimized local WebP copies, so visitors don't need GitHub access
or working GitHub attachment links. There are 48 gallery files, about 2 MB,
requested on demand, not on initial page load.

1. **Money Mate — 14 images.**
   [README at aeb8b0c](https://github.com/Sonykhan1121/money_mate/tree/aeb8b0c57f2cf55f1b02b1777b882a02c98abb4a).
   All 14 application screenshots, in README order. The approved hover cover
   is unchanged: [original dashboard](https://github.com/user-attachments/assets/3c94f560-ce6b-4b44-a5d3-711c1fdb69dd).
   Files: `gallery-money-01.webp` through `gallery-money-14.webp`.

2. **Hand Gesture Detector — 15 images.**
   [README at e976b7f](https://github.com/Sonykhan1121/flutter-hand-gesture-detector/tree/e976b7f15b070e8497fe29f4ab4d22310577a0e3).
   Includes the actual hand-camera/tracking screenshots, control settings and
   gesture reference. The cover is the README's
   [Move up screenshot](https://github.com/user-attachments/assets/1f37db34-16a2-41ac-b9f7-f6b9ab193377),
   with a visible hand and landmarks, not the earlier video frame/settings mockup.
   The public attachment requests returned 404 during collection; authenticated
   `gh api` access successfully retrieved the original image bytes. No credentials
   are saved in the app or needed by visitors. Files: `gallery-hand-01.webp`
   through `gallery-hand-15.webp`; camera examples appear before the reference.

3. **Movie Explorer — 2 images; replaces BD SIM Validator in section 02.**
   [Repository](https://github.com/Sonykhan1121/flutter-state-management-specialist).
   Actual `docs/screenshots/provider-movie-list.png` and
   `docs/screenshots/provider-movie-details.png` from the README. The card links
   to the completed `provider` branch (reviewed at
   `e52f0c969af5e3b160c1044fe2d1b9403ac7acf2`), not the starter/brief on main.
   Files: `gallery-movie-catalog.webp`, `gallery-movie-details.webp`.

4. **Deshi10 — 6 images.**
   [README at 1a8fcdf](https://github.com/Sonykhan1121/Android-Ecommerce-app/tree/1a8fcdf99a57a6f5d3e71c86f02dd1f025edfa44).
   Catalog, product detail, payment UI examples, cart and startup. The tiny logo
   is excluded because it isn't an app screen. Payment examples are labelled
   as UI, not a claim of implemented payment processing. The approved hover
   cover is unchanged. Files: `gallery-deshi-02.webp` through `gallery-deshi-07.webp`.

5. **Gentle Park — 9 images; replaces Our Admin Panel in section 02.**
   [README at 8782711](https://github.com/Sonykhan1121/GentlePark/tree/8782711dc9ac7398c2f6db9ccc3faf837d3a8062).
   Populated catalog, welcome/account screens and early catalog/search/cart/
   profile UI. Incomplete-looking screens are explicitly captioned “early UI”.
   Excludes the navigation diagram and Firebase console screenshot because
   they aren't app screens. No completed checkout/payment claims are added.
   Files: `gallery-gentle-01.webp`–`04.webp` and `07.webp`–`11.webp`.

6. **Face Recognition / attendance preview — 2 images.**
   Supplied in `FaceAttendance-Portfolio-Source.zip` on 7 September 2026;
   SHA-256 `529bbf2988ce21c2f034d7f0beb2bdc947bed383a263742fe70737a6226b16d3`.
   The source is added under `portfolio-demo/` in the existing
   [Face Recognition repository](https://github.com/Sonykhan1121/Face-recognition-with-Tflite-and-flutter/tree/main/portfolio-demo),
   preserving the original root-level Flutter/TFLite project. The desktop and
   mobile images come from its `docs/screenshots/` folder and were rendered by
   its `tool/capture_screenshots_test.dart`. The desktop image is the hover cover.
   Labels explicitly say **SIMULATED SCAN** / **simulated attendance demo**.
   This preview does not run biometric recognition, open a camera, or use real
   employees/production services; the fictional demo profile and local punch
   history are UI examples. Files: `gallery-face-desktop.webp`,
   `gallery-face-mobile.webp`, `hover-face-recognition.webp`.

Do not initialize production services to update these static previews.

The user approved publishing all six project previews on 7 September 2026.
