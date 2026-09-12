'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "e249c096c55acbe7104ba8be19ccd7df",
"version.json": "6c9c33a00862dd1e5b5e7f4bc4d6f9e7",
"main.dart.js": "04298958ba6e850ee4c00e02a835c5a4",
"flutter_bootstrap.js": "9619c5998b6c802b502a3bb2fc9462ab",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"index.html": "2a4b60da5de83c9f1e52de5e50fc9640",
"/": "2a4b60da5de83c9f1e52de5e50fc9640",
"assets/AssetManifest.bin": "58b178593fa0446a3ce52ce5e5d4109e",
"assets/fonts/MaterialIcons-Regular.otf": "bf0d4e7496c07c6fe34f51149d708e67",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "2b6ad2737342a34bc28f9262907da74a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "269f971cec0d5dc864fe9ae080b19e23",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "f6096aeb7c3fb58ea847b576f9a13392",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5d424a84ac80760175a3638412945dd1",
"assets/AssetManifest.json": "0cdf560c512fbbc2ec99e39fc8731d3b",
"assets/assets/data/github_repositories.json": "8eb8afae6e5ebfcd4c59f9d1aff8ed56",
"assets/assets/icons/contact_tag.png": "5183f76731d9d7bcc3bde4943ea9a4cc",
"assets/assets/icons/icon_tag.png": "40107e28559a4fc131e22dfbeb95a4f6",
"assets/assets/icons/interviewbit.png": "d47f8019a314c3567747c9d3be9ea8d6",
"assets/assets/icons/android_tag.png": "0680f92e010b1cebfc90c1fd6644df51",
"assets/assets/icons/beecrowd.png": "95ec07a0a22b3d820ef1f4726c4941af",
"assets/assets/icons/facebook_logo.png": "8c89ef8ab45d47ae9a954822532889f7",
"assets/assets/icons/twitter.png": "3e8e7ee8666a9f4e2946f39ff2f806e3",
"assets/assets/icons/state_management_tag.png": "9efdd1756df1f6e7b91deb77525d8e62",
"assets/assets/icons/desktop_tag.png": "ca1be726e5e6ac5e66197255b0b2f0b5",
"assets/assets/icons/api_tag.png": "4ae61ef57be36a64fbfcbd7b1282f8ba",
"assets/assets/icons/codeforces.png": "01bcea9f5c4fab5a2f1c03744d10b4b9",
"assets/assets/icons/COMPETITIVE_LOGOS.md": "e7206243a839cbecf552ef4a20532342",
"assets/assets/icons/linkedin.png": "d492efc706db983e74258dbd348f2208",
"assets/assets/icons/leetcode.png": "03981ac6e8cee18ee9cc2fed56d334eb",
"assets/assets/icons/git_tag.png": "4cf45ee165593a3e09cf4ec904275400",
"assets/assets/icons/database_tag.png": "e440db0521a1b68bb4f2558e6fbf64f4",
"assets/assets/icons/web_tag.png": "564ea904f5e87ea43afb7f055d1e4e7d",
"assets/assets/icons/html_tag.png": "6dc21fd9ff3358c8aeedf8c71cbe9a00",
"assets/assets/icons/open_url.png": "b95b684622b25c7e924a62a24c07f2f9",
"assets/assets/images/me_edit.png": "a069cb2ab3db48a0d7edfbd0a711c804",
"assets/assets/images/projects/gallery-hand-08.webp": "02e99bace6fd2820d9e80805e63c0fa3",
"assets/assets/images/projects/gallery-money-14.webp": "cbb7f5a1ba25d4804a43089f2f216516",
"assets/assets/images/projects/gallery-movie-catalog.webp": "86956b19a59e5fe3cb72d2226e6806da",
"assets/assets/images/projects/gallery-money-13.webp": "7331875bfb0027915ca196e7d4aa9904",
"assets/assets/images/projects/gallery-money-08.webp": "8f232250f89f886bd5659d70a8379aea",
"assets/assets/images/projects/hover-gentle-park.webp": "adbae875c56db2b1664c2f02dcb50b70",
"assets/assets/images/projects/gallery-deshi-03.webp": "51cec515d4bfb0e38981a5f2dbabad0b",
"assets/assets/images/projects/gallery-money-07.webp": "751a399db8e82d573e400c22e30a2633",
"assets/assets/images/projects/gallery-gentle-03.webp": "1eba6274bcea8f15fd7ea3e530cc540e",
"assets/assets/images/projects/gallery-face-mobile.webp": "127da37df2f534b5cf5a0de9be98bf0e",
"assets/assets/images/projects/gallery-hand-01.webp": "4ae96da782c642bb9d1f04ea51094efa",
"assets/assets/images/projects/gallery-hand-14.webp": "58d5fc3f800c51ff2501f3209f63f786",
"assets/assets/images/projects/gallery-hand-05.webp": "f7aa095bf822614518a325e95c05dba9",
"assets/assets/images/projects/gallery-deshi-02.webp": "587852eaa82b05d173ce1ec11d90ec43",
"assets/assets/images/projects/gallery-gentle-04.webp": "00bc077d5753adf1d451db294844575b",
"assets/assets/images/projects/hover-hand-gesture.webp": "49e65c07aaa344a0e358592037009358",
"assets/assets/images/projects/hover-deshi10.webp": "63c6305749d6fd0625e155b6095f1a3b",
"assets/assets/images/projects/gallery-gentle-11.webp": "e686d008f552ad3607c426601b7212bb",
"assets/assets/images/projects/gallery-gentle-01.webp": "e01719f0259e771387aa4848b0c989cc",
"assets/assets/images/projects/gallery-hand-09.webp": "5c5338ad204276eedfbf5a0d111f5077",
"assets/assets/images/projects/gallery-deshi-07.webp": "1651a008c8409bdbbb4a7bf1bfcf7a69",
"assets/assets/images/projects/hover-movie-explorer.webp": "28ec48c78f5d0ee0c829030fe55f979e",
"assets/assets/images/projects/gallery-gentle-09.webp": "6514fed1552a9eb91590a53120c51108",
"assets/assets/images/projects/gallery-deshi-06.webp": "87c103f67695cc1f719ef4d323028d0a",
"assets/assets/images/projects/gallery-hand-06.webp": "4981f44d5a952cef56619142f258d02b",
"assets/assets/images/projects/money_mate_banner.jpg": "5e6ebd8e611a13a8198977710d627791",
"assets/assets/images/projects/gallery-hand-10.webp": "a2a271283a05c1faf71f426def559900",
"assets/assets/images/projects/gallery-money-04.webp": "7d99d48296892e2532d33b9f1d3ecb73",
"assets/assets/images/projects/gallery-money-01.webp": "cbb7f5a1ba25d4804a43089f2f216516",
"assets/assets/images/projects/gallery-hand-15.webp": "58d5fc3f800c51ff2501f3209f63f786",
"assets/assets/images/projects/gallery-gentle-08.webp": "6c4e1a728647adf89da94f1fc6552b13",
"assets/assets/images/projects/gallery-money-02.webp": "8acd7f40c93d19a76220bd0b3fecb0cf",
"assets/assets/images/projects/demos/face_recognition_ai.jpg": "fc72c3c50e42edd05bf606cff0989abb",
"assets/assets/images/projects/demos/smart_attendance.jpg": "9574c59f0f37de16b6bae850a04cc9a9",
"assets/assets/images/projects/demos/gesture_mobile_stand.jpg": "975bf3df065743bfdec8a12107f64c75",
"assets/assets/images/projects/gallery-money-09.webp": "8fb5b29e8df9605936fb05df3eb85b78",
"assets/assets/images/projects/gallery-deshi-05.webp": "0a0ef4c72b7b8a87f8f8b0fd90de2ccf",
"assets/assets/images/projects/gallery-hand-11.webp": "2ac0844b818fbb734cc3071b6ba8d726",
"assets/assets/images/projects/gallery-hand-12.webp": "dc446669587307eac40caa1f9b1f9622",
"assets/assets/images/projects/gallery-deshi-04.webp": "92c005d9fb8081de7207efa31eb12dbb",
"assets/assets/images/projects/gallery-gentle-07.webp": "fe3da7e9d6eab6e9df6e6dd4d1bd8de8",
"assets/assets/images/projects/gallery-movie-details.webp": "fa9c4e702ee53d5314b5a10d5dc578d4",
"assets/assets/images/projects/gallery-hand-02.webp": "db554fc6b1da9f03a4fd474eaf38aefb",
"assets/assets/images/projects/gallery-money-10.webp": "ce571018b29dd31358005576b2b377c2",
"assets/assets/images/projects/gallery-face-desktop.webp": "5332807667d366f8f96c14b1cee2c852",
"assets/assets/images/projects/gallery-gentle-10.webp": "389ece6c0d938447be4c9b3e45269c85",
"assets/assets/images/projects/gallery-money-05.webp": "b430c17d2d7d601acd08c71ad6f21d0a",
"assets/assets/images/projects/gallery-money-12.webp": "2ed75884b97ec630f028b269e439c6c7",
"assets/assets/images/projects/gallery-hand-07.webp": "afa723ac48996324f2699dfc1332b580",
"assets/assets/images/projects/gallery-money-03.webp": "69613448b004a476a7327f0b85f4d20a",
"assets/assets/images/projects/gallery-hand-13.webp": "dae40ea8d5163c8ac4b6123e03d588db",
"assets/assets/images/projects/hover-money-mate.webp": "08ee6d476c2b9239b202860b5e02c070",
"assets/assets/images/projects/gallery-hand-04.webp": "9c2f97c701a831281555e239b3a4d082",
"assets/assets/images/projects/grozziie/play_03.webp": "e623f5c3d8639e0f7b56f679887618be",
"assets/assets/images/projects/grozziie/ios_04.jpg": "001d1f92b6c2799bfa4c1ffc3cb5686c",
"assets/assets/images/projects/grozziie/ios_01.jpg": "832a1b1978655bc0909794808ca968ed",
"assets/assets/images/projects/grozziie/ios_03.jpg": "dbe80c6094799d6206d13a00a029a4d6",
"assets/assets/images/projects/grozziie/play_01.webp": "00340733eb8ff20ced073d1dc6d306b6",
"assets/assets/images/projects/grozziie/icon.webp": "b7109b1eb508a5b34562ee6a60c0362c",
"assets/assets/images/projects/grozziie/play_02.webp": "99304fb69f853c20868ec07aff67a723",
"assets/assets/images/projects/grozziie/play_04.webp": "d53510fa8e895747da4203bbbff45750",
"assets/assets/images/projects/grozziie/ios_02.jpg": "7f80f53551c38a527c81f7b45dd0dda3",
"assets/assets/images/projects/gallery-gentle-02.webp": "268693f80c5fca91e95aa9bf4c1c772c",
"assets/assets/images/projects/gallery-hand-03.webp": "2a835b19211d73849420e9905f41bbcf",
"assets/assets/images/projects/gallery-money-06.webp": "0ccf11b00474b279e569a0cd2237e610",
"assets/assets/images/projects/hover-face-recognition.webp": "d9cf244efa25e39fabf315cf6f6cbdc5",
"assets/assets/images/projects/gallery-money-11.webp": "e9d4f63ef6db7e34d3128f1ac8e1d4f4",
"assets/assets/images/bengali-computer-lessons.jpg": "3356279d7f801667933e2c36b18a1690",
"assets/assets/images/company/video-thermal-printer.jpg": "318e28c096af69e7dafe11ea1699cd0a",
"assets/assets/images/company/product-magnetic-power-bank.png": "543f414f20773a579269311bf8fe0ffd",
"assets/assets/images/company/tht-space-team-cover.jpg": "d82af061a2b3bc178c0f1f854485eacb",
"assets/assets/images/company/product-thermal-printer.png": "3473e2abc65b36750afa6f9a18a21357",
"assets/assets/images/company/product-dot-matrix-printer.png": "04732207329fbde536a7c428c3eed002",
"assets/assets/images/company/product-attendance-machine.png": "e448138ac1497c2d7ccf3404fe2ef8e7",
"assets/assets/images/company/video-grozziie-macos.jpg": "1f761873259a8c2d0ff99cf406dd6fbf",
"assets/assets/images/company/video-label-printer.jpg": "8a607345d50b51fe8f7699fb79fc1012",
"assets/assets/images/hero_portrait_2026_v2.webp": "bba9f25e8ed5809ee696162c4de1231d",
"assets/assets/images/team/shuvo.jpg": "6c130b59fee72d350c1e042793b9a7fc",
"assets/assets/images/team/dolon-mondol.jpg": "6aa026b5221b82a440c5a90904165c2d",
"assets/assets/images/team/obaidul-haque.jpg": "3bf7210f1f89fda8f3998390cbe0d28d",
"assets/assets/images/team/zubayar-ahmed.jpg": "027ace68ba48708391bed2e9256a88e0",
"assets/assets/images/team/pias.jpg": "f6acd010cacd07c03aff90a94fb2c887",
"assets/assets/images/team/mir-sultan.jpg": "318857754d5a8bd0f750dcafdfe436f7",
"assets/assets/images/team/zhang-geng.jpg": "6a6eb33b5e773fd13fdd47762045817a",
"assets/assets/images/profilepic.png": "d3fd19a8a679c6d8c39b7d4784d75fe5",
"assets/assets/images/hero_portrait_2026.png": "a069cb2ab3db48a0d7edfbd0a711c804",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/NOTICES": "09f8afd72c9c1f41d605e05015544c27",
"flutter.js": "76f08d47ff9f5715220992f993002504"};
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
