'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "6c9c33a00862dd1e5b5e7f4bc4d6f9e7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "ec5d7334aebf303c634cbb449f114cc9",
"/": "ec5d7334aebf303c634cbb449f114cc9",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/AssetManifest.json": "a15e42216919afda7d5bbc15457fb3d8",
"assets/AssetManifest.bin.json": "8b2914d03030bb17e117fe70d1fe8565",
"assets/NOTICES": "09f8afd72c9c1f41d605e05015544c27",
"assets/fonts/MaterialIcons-Regular.otf": "6e078f672742e8ecbf1833503cc21b46",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/AssetManifest.bin": "17192a6815aa87dff109373db7d13eaf",
"assets/assets/images/projects/money_mate_banner.jpg": "5e6ebd8e611a13a8198977710d627791",
"assets/assets/images/projects/grozziie/ios_03.jpg": "dbe80c6094799d6206d13a00a029a4d6",
"assets/assets/images/projects/grozziie/ios_04.jpg": "001d1f92b6c2799bfa4c1ffc3cb5686c",
"assets/assets/images/projects/grozziie/play_04.webp": "d53510fa8e895747da4203bbbff45750",
"assets/assets/images/projects/grozziie/icon.webp": "b7109b1eb508a5b34562ee6a60c0362c",
"assets/assets/images/projects/grozziie/play_01.webp": "00340733eb8ff20ced073d1dc6d306b6",
"assets/assets/images/projects/grozziie/play_02.webp": "99304fb69f853c20868ec07aff67a723",
"assets/assets/images/projects/grozziie/ios_01.jpg": "832a1b1978655bc0909794808ca968ed",
"assets/assets/images/projects/grozziie/play_03.webp": "e623f5c3d8639e0f7b56f679887618be",
"assets/assets/images/projects/grozziie/ios_02.jpg": "7f80f53551c38a527c81f7b45dd0dda3",
"assets/assets/images/hero_portrait_2026.png": "a069cb2ab3db48a0d7edfbd0a711c804",
"assets/assets/images/me_edit.png": "a069cb2ab3db48a0d7edfbd0a711c804",
"assets/assets/images/profilepic.png": "d3fd19a8a679c6d8c39b7d4784d75fe5",
"assets/assets/icons/api_tag.png": "4ae61ef57be36a64fbfcbd7b1282f8ba",
"assets/assets/icons/linkedin.png": "d492efc706db983e74258dbd348f2208",
"assets/assets/icons/android_tag.png": "0680f92e010b1cebfc90c1fd6644df51",
"assets/assets/icons/facebook_logo.png": "8c89ef8ab45d47ae9a954822532889f7",
"assets/assets/icons/html_tag.png": "6dc21fd9ff3358c8aeedf8c71cbe9a00",
"assets/assets/icons/git_tag.png": "4cf45ee165593a3e09cf4ec904275400",
"assets/assets/icons/state_management_tag.png": "9efdd1756df1f6e7b91deb77525d8e62",
"assets/assets/icons/web_tag.png": "564ea904f5e87ea43afb7f055d1e4e7d",
"assets/assets/icons/twitter.png": "3e8e7ee8666a9f4e2946f39ff2f806e3",
"assets/assets/icons/desktop_tag.png": "ca1be726e5e6ac5e66197255b0b2f0b5",
"assets/assets/icons/database_tag.png": "e440db0521a1b68bb4f2558e6fbf64f4",
"assets/assets/icons/icon_tag.png": "40107e28559a4fc131e22dfbeb95a4f6",
"assets/assets/icons/contact_tag.png": "5183f76731d9d7bcc3bde4943ea9a4cc",
"assets/assets/icons/open_url.png": "b95b684622b25c7e924a62a24c07f2f9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "f02e9e22a65d4e52cbc8e256f6398af5",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5d424a84ac80760175a3638412945dd1",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "269f971cec0d5dc864fe9ae080b19e23",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"main.dart.js": "670dc4d69c00a46a1314dae939ebab5a",
"flutter_bootstrap.js": "778fd8461fa67f208a0ea7b3b7c3796d",
"manifest.json": "e249c096c55acbe7104ba8be19ccd7df"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
