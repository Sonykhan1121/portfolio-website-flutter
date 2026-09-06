# Progressive image rendering

The opening HTML uses the approved full-screen SM loader and preloads the hero
portrait's WebP. Flutter uses inline previews of all current portfolio
photos, including products, team members and galleries. A preview remains under
the full image during its 520 ms top-to-bottom reveal, so slow downloads no
longer leave empty slots. This is a reveal of a decoded image, not a download
percentage or an artificial delay to the page becoming interactive.

The white opening screen shows a pulsing SM monogram, counter-rotating teal/blue
rings and animated dots until Flutter's first frame. Status text follows actual
engine preparation and app rendering. The overlay then fades out in 240 ms,
without an artificial minimum wait. A failure/timeout stops the animation and
offers retry; CV/contact/social links remain usable. Reduced-motion preferences
disable the rings, pulse, dots, transition and image reveal animation. Cached
Flutter images skip the reveal entirely. A no-JavaScript fallback keeps the
professional introduction and links visible without an endless loader.

Only the hero and company cover request their full asset immediately. Other
full-size images still wait until they are close to the viewport. Existing
browser/Flutter caching, reserved sizes, gallery scrolling and reduced-motion
preferences are preserved. Failed full images retain their real preview;
unrecognized assets retain the accessible fallback.

After adding or replacing photos, run `node tool/generate_image_previews.cjs`
with `sharp` available to Node (either installed in your development environment
or supplied through `NODE_PATH`), then format `lib/data/asset_image_previews.dart`
with Dart. Commit that generated file. Deployment does not
need Node or sharp; the previews are checked in. Original photos are unchanged.

Run `flutter test` and `node tool/test_startup_loading.cjs` before publishing.
The startup checks exercise the first-frame handoff, slow-load recovery,
initialization errors and reduced motion without browser/network dependencies.
The Flutter tests validate preview decoding and
size, loading/reveal/cached/failure states, reduced motion, asset changes, and
viewport-gated requests including nested galleries.
