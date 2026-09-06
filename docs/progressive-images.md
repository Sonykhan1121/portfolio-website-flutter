# Progressive image rendering

The opening HTML contains a tiny inline preview of the actual portrait and
prioritizes its full WebP. Flutter uses inline previews of all current portfolio
photos, including products, team members and galleries. A preview remains under
the full image during its fade, so slow downloads no longer leave empty slots.

Only the hero and company cover request their full asset immediately. Other
full-size images still wait until they are close to the viewport. Existing
browser/Flutter caching, reserved sizes, gallery scrolling and reduced-motion
preferences are preserved. Failed full images retain their real preview;
unrecognized assets retain the accessible fallback.

After adding or replacing photos, run `node tool/generate_image_previews.cjs`
with `sharp` available to Node (either installed in your development environment
or supplied through `NODE_PATH`), then format `lib/data/asset_image_previews.dart`
with Dart. Commit that generated file and `web/index.html`. Deployment does not
need Node or sharp; the previews are checked in. Original photos are unchanged.

Run `flutter test` before publishing. The tests validate preview decoding and
size, loading/fade/cached/failure states, reduced motion, asset changes, and
viewport-gated requests including nested galleries.
