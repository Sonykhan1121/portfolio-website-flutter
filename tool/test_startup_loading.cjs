// Deterministic startup lifecycle checks; no browser or network required.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const root = path.resolve(__dirname, '..');
const html = fs.readFileSync(path.join(root, 'web/index.html'), 'utf8');
const script = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)][0][1];
const bootstrap = fs.readFileSync(path.join(root, 'web/flutter_bootstrap.js'), 'utf8')
  .replace(/\{\{flutter_js\}\}|\{\{flutter_build_config\}\}/g, '')
  .replace('{{flutter_service_worker_version}}', 'null');

function startup(reducedMotion = false, focused = false) {
  const elements = new Map();
  const events = new Map();
  const timers = new Map();
  const paints = [];
  let nextTimer = 0;
  function element(id) {
    assert.ok(html.includes(`id="${id}"`), `Referenced element ${id} exists`);
    if (!elements.has(id)) elements.set(id, {
      classes: new Set(), hidden: true, textContent: '', complete: false,
      classList: {add(name) { elements.get(id).classes.add(name); }},
      addEventListener() {}, contains() { return focused; },
      setAttribute() {}, remove() { this.removed = true; },
    });
    return elements.get(id);
  }
  const view = {attributes: {}, setAttribute(name, value) { this.attributes[name] = value; }, focus(options) { this.focusOptions = options; }};
  const window = {addEventListener: (name, callback) => events.set(name, callback)};
  const context = vm.createContext({
    window,
    document: {getElementById: element, querySelector: () => view, activeElement: {}},
    HTMLScriptElement: class {},
    requestAnimationFrame: callback => paints.push(callback),
    matchMedia: () => ({matches: reducedMotion}),
    setTimeout: (callback, ms) => { const id = ++nextTimer; timers.set(id, {callback, ms}); return id; },
    clearTimeout: id => timers.delete(id),
    console: {error() {}},
  });
  vm.runInContext(script, context);
  return {window, context, element, events, timers, paints, view,
    paint() { while (paints.length) paints.shift()(); },
    tick(ms) { for (const [id, timer] of [...timers]) if (timer.ms <= ms) {timers.delete(id); timer.callback();} },
  };
}

async function main() {
  assert.match(html, /class="orbit" aria-hidden="true"/);
  assert.match(html, /class="monogram">SM<\/div>/);
  assert.match(html, /class="ring inner-ring"/);
  assert.match(html, /class="loading-dots" aria-hidden="true"/);
  assert.match(html, /role="status" aria-live="polite" aria-atomic="true"/);
  assert.match(html, /prefers-reduced-motion: reduce[\s\S]*?\.loading-dots i \{ animation: none; \}/);
  assert.match(html, /#startup \{ position: fixed; inset: 0;/);
  assert.match(html, /has-loading-error[^\n]+animation: none/);
  assert.match(html, /min-height: 44px/);
  assert.match(html, /href="mailto:sonykhan1121@gmail.com"/);
  assert.match(html, /href="https:\/\/drive.google.com\/file\/d\/1TYH92znM8dSZ3sKT0-bnlcENmEEHdIwg/);
  assert.doesNotMatch(html, /Loading screen · preview|portfolioStartup.*portrait/);

  for (const reduced of [false, true]) {
    const s = startup(reduced);
    s.window.portfolioStartupStage('Preparing');
    assert.equal(s.element('startup-status').textContent, 'Preparing');
    assert.equal(s.element('startup').removed, undefined);
    s.events.get('flutter-first-frame')();
    assert.equal(s.timers.size, 0, 'First frame clears the slow-load timeout');
    assert.equal(s.element('startup-status').textContent, 'Your portfolio is ready');
    s.paint();
    assert.ok(s.element('startup').classes.has('leaving'));
    assert.ok(s.element('startup').inert);
    s.tick(reduced ? 0 : 260);
    assert.ok(s.element('startup').removed);
    s.window.portfolioStartupFailed();
    assert.equal(s.element('startup-retry').hidden, true, 'Late errors cannot replace the ready state');
  }

  const keyboard = startup(false, true);
  keyboard.events.get('flutter-first-frame')();
  keyboard.paint();
  assert.equal(keyboard.view.attributes.tabindex, '-1');
  assert.equal(keyboard.view.focusOptions.preventScroll, true);

  const slow = startup();
  slow.tick(35000);
  assert.ok(slow.element('startup').classes.has('has-loading-error'));
  assert.equal(slow.element('startup-retry').hidden, false);
  slow.window.portfolioStartupStage('Late stage');
  assert.match(slow.element('startup-status').textContent, /taking longer/);
  slow.events.get('flutter-first-frame')();
  slow.paint();
  slow.tick(260);
  assert.ok(slow.element('startup').removed, 'A slow startup can still recover');

  const s = startup();
  let options;
  s.context._flutter = {loader: {load: config => {options = config; return Promise.resolve();}}};
  vm.runInContext(bootstrap, s.context);
  await options.onEntrypointLoaded({initializeEngine: async () => {
    assert.equal(s.element('startup-status').textContent, 'Preparing the interactive view…');
    return {runApp: async () => assert.equal(s.element('startup-status').textContent, 'Rendering the portfolio…')};
  }});
  assert.equal(s.element('startup').removed, undefined, 'runApp alone does not hide the loader');
  await options.onEntrypointLoaded({initializeEngine: async () => {throw Error('Engine failed');}});
  assert.ok(s.element('startup').classes.has('has-loading-error'));
  console.log('Startup animation checks passed: loading stages, first frame, timeout, recovery, failure and reduced motion.');
}
main().catch(error => {console.error(error); process.exitCode = 1;});
