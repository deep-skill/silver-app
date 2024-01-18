'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "4842ddf34aff44512c481855ef437d00",
"assets/AssetManifest.bin.json": "933af426b795c8673ed9ce5e7309e1ed",
"assets/AssetManifest.json": "3413588f91178419df4ecf41440f2ceb",
"assets/assets/fonts/Montserrat-Bold.ttf": "ed86af2ed5bbaf879e9f2ec2e2eac929",
"assets/assets/fonts/Montserrat-Medium.ttf": "bdb7ba651b7bdcda6ce527b3b6705334",
"assets/assets/fonts/Montserrat-Regular.ttf": "5e077c15f6e1d334dd4e9be62b28ac75",
"assets/assets/fonts/Montserrat-SemiBold.ttf": "cc10461cb5e0a6f2621c7179f4d6de17",
"assets/assets/fonts/Raleway-Bold.ttf": "575e4317521b381ac94c0c8207c81979",
"assets/assets/fonts/Raleway-SemiBold.ttf": "804eb7bc11d3a38d5f5e108f8d1d1acd",
"assets/assets/fonts/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/assets/fonts/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/assets/images/apple_store.png": "d7ae75ca3735bb21e4c694103c44793b",
"assets/assets/images/app_logo.png": "5dfe37b7d6f18487ab98e29b055f5e53",
"assets/assets/images/app_logo_auth.png": "be5a1d209bfb07be5ed74995b6a5df24",
"assets/assets/images/app_logo_letters.png": "f5dee7c8f6319c70efe3a61a14f97311",
"assets/assets/images/driver_img_example.png": "77c258be8db94e510be71d789b3d61fd",
"assets/assets/images/enterprise_logo.png": "a0036ad538a70dddd90791987b84cc2b",
"assets/assets/images/google_store.png": "aaa9c049cc3d877cdfb378110b3c5f32",
"assets/assets/images/internal_error.png": "1493257d80b682950b8122068310633b",
"assets/assets/images/login-driving-car-web.png": "6029731a662aca1ea94c18b99e9e6b2c",
"assets/assets/images/login-driving-car.png": "cfe2462efad8d2388604a6c91e68b7ec",
"assets/assets/images/no_driver_car_admin.png": "1850db0cd3ecdf92a8358c801a7e2bf4",
"assets/assets/images/page_not_found.png": "b02f08f18ce76c8705c07e487659ad61",
"assets/assets/images/silver-logo_dark_font-color.png": "2a2502c4dd302155f10ab50687c4257e",
"assets/assets/images/silver-logo_primarycolor_background.png": "59abd0ca0180e13b631d0a7f5be45781",
"assets/assets/images/silver-logo_white_background.png": "ed1a01f236cf62f8a57d46a77c238d22",
"assets/assets/images/silver-logo_white_font-color.png": "de408a88f83dedf6c6d6a2d9c5a457bf",
"assets/assets/images/silver_phone.png": "4d9d2413f395a900ff6faad062116830",
"assets/assets/images/silver_phone_tablet.png": "108bc868d6274c0ec92c4427cfc0ae80",
"assets/assets/images/vehiculo_home_admin.png": "fdeb1bf260943feee9c5390744ba764d",
"assets/FontManifest.json": "362196bedd2820650ddda87fb1d1a865",
"assets/fonts/MaterialIcons-Regular.otf": "d6199b14bc5a350eef74db8a51183a7b",
"assets/NOTICES": "e7533b014b7866914e381634ad3d7e39",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "e6ee3a54b391b46258547756f4d31c7e",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "817cf2e307a9593836589457d9ad168a",
"icons/Icon-512.png": "fd921f364784cdc002efaca6ece4326c",
"icons/Icon-maskable-192.png": "817cf2e307a9593836589457d9ad168a",
"icons/Icon-maskable-512.png": "fd921f364784cdc002efaca6ece4326c",
"index.html": "c51f2705bf8b5d15e98c5bac3eb57d46",
"/": "c51f2705bf8b5d15e98c5bac3eb57d46",
"main.dart.js": "77e1ce376633d07ec55519978714fe51",
"manifest.json": "c62de1cf69d6132a42f9a5520397649e",
"version.json": "2ee19d6f5e63b372aa0804efb38b804f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
