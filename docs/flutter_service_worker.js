'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "436c8a328386cfc5fabf678bace1e792",
"assets/AssetManifest.bin.json": "a3bccab8aa21faa7ebb5642ad8abc53a",
"assets/AssetManifest.json": "39a22b3cec442891b43a55d7ed55ef3d",
"assets/assets/audios/amel_1.mp3": "e7862e656517683570b599e1267ce8ca",
"assets/assets/audios/amel_10.mp3": "badd092f3db93a2c2b7f695cfb39c96a",
"assets/assets/audios/amel_11.mp3": "43052385f129e419a0c89b45af783923",
"assets/assets/audios/amel_2.mp3": "ef30350403ed1f27c012e0482796f3d3",
"assets/assets/audios/amel_3.mp3": "7daa95170c77491a971475594241d0cb",
"assets/assets/audios/amel_4.mp3": "e2256984654879fc987fc97b51b5c8f4",
"assets/assets/audios/amel_5.mp3": "041a1a488d0c1101549dee79dcd0a760",
"assets/assets/audios/amel_6.mp3": "c47c8689b92c265244ad916510f42d99",
"assets/assets/audios/amel_7.mp3": "ecfc443609161dfac478e80cf6a8165d",
"assets/assets/audios/amel_8.mp3": "8c469c279d3cab9525f53cb3f5157d0e",
"assets/assets/audios/amel_9.mp3": "cfef73e5e5640d2a250f18c5df73ff79",
"assets/assets/audios/amel_babak_ke.mp3": "f23bb938784c34dfe7f5b944feb36a5c",
"assets/assets/audios/amel_belas.mp3": "2e463b96e0af7b3f046c62fad603a189",
"assets/assets/audios/amel_confirmation.mp3": "4ce80a909541fae9f64003511b7a475f",
"assets/assets/audios/amel_draw_answer.mp3": "604f69755e01b3fabf1a51152ac6d845",
"assets/assets/audios/amel_game_over.mp3": "8c7231fb6d54cf97071fb3d3e5f997fd",
"assets/assets/audios/amel_game_over_win.mp3": "45243cbdaa1e95f7109f7a436ac3d6a5",
"assets/assets/audios/amel_game_over_win_perfect.mp3": "b7143753c39c0783d9786b261a4f7fd5",
"assets/assets/audios/amel_hover.mp3": "06dc60c7a2caad4280c44942e421af77",
"assets/assets/audios/amel_permission.mp3": "a4543c438fc68b32c1a5efe1c7e08f96",
"assets/assets/audios/amel_puluh.mp3": "8119824958b196e9a69317e2da4c4441",
"assets/assets/audios/amel_reveal.mp3": "4cd03b3290549ff3f86242f4e9e54d07",
"assets/assets/audios/amel_round_1.mp3": "32317dba0c9600c9c3cf6b77c8606e1d",
"assets/assets/audios/amel_round_end_lose.mp3": "5b6219ddb61bc29ff0a64258f3958f4b",
"assets/assets/audios/amel_round_end_lose_continue.mp3": "8a8ce8c209462e3e8aa448cfe9611331",
"assets/assets/audios/amel_round_end_win.mp3": "b6d2b6434a0628c51109846943cbae39",
"assets/assets/audios/amel_round_end_win_continue.mp3": "7210c04e4c0d567b914f2342be800d73",
"assets/assets/audios/amel_start.mp3": "7c540188a7680e2fb39468a45db57527",
"assets/assets/audios/announce_gajah_terbang.mp3": "b69a1cf46056e164ed652f4c4f5b4ddd",
"assets/assets/audios/announce_kapten_lautan.mp3": "f32be92df1d0df10f5b32f115a052d7a",
"assets/assets/audios/announce_kucing_ninja.mp3": "62bdaf3f3191598bc0c1de8aa0c58872",
"assets/assets/audios/announce_naga_berkilau.mp3": "535bf27b6ff1a1bd042155cbfa05f915",
"assets/assets/audios/announce_pahlawan_super.mp3": "507b69f94db00ea21290eb8deaa94c69",
"assets/assets/audios/announce_panda_ajaib.mp3": "b15b88be81fbd5a55c2c8ae54243973f",
"assets/assets/audios/announce_pangeran_bulan.mp3": "002e07a0fad8eff43688ea3ad9e54749",
"assets/assets/audios/announce_peri_embun.mp3": "4b3a86f63d4884b3ff6915b84cd69745",
"assets/assets/audios/announce_putri_awan.mp3": "1bbeef7027a94dd6f49cc03af048b1aa",
"assets/assets/audios/announce_putri_pelangi.mp3": "7300a2c3e817357f304240bd362f77ac",
"assets/assets/audios/announce_raja_buah.mp3": "62870a9ae7f9c0af20f07eca54372e2e",
"assets/assets/audios/announce_raja_madu.mp3": "2e1f3c390b88c4218c99591b57480c6e",
"assets/assets/audios/announce_raksasa_hutan.mp3": "9ed2b1fd3fae9ca14b06b4316830e4c3",
"assets/assets/audios/announce_ratu_es.mp3": "d3f17ebc7877bce7380b25666740fe9f",
"assets/assets/audios/announce_ratu_kebaikan.mp3": "da23cdf3a6ff1a306b512f6674cd5e4c",
"assets/assets/audios/announce_singa_ceria.mp3": "73eb4cd3a35ade8b4f6fd0d3008a2cf7",
"assets/assets/audios/clapandyell.mp3": "6b5c41ece44d3e8352a8fadc7384c672",
"assets/assets/audios/countdown_1.mp3": "283097da53518e4c1af8e4dcb0287d1d",
"assets/assets/audios/countdown_2.mp3": "d425addb08473321a197e12d4fea4e17",
"assets/assets/audios/countdown_3.mp3": "15e487d5bf0844cb2a8114def255d058",
"assets/assets/audios/countdown_4.mp3": "a79adb9321cbeaed153164b7d94d424b",
"assets/assets/audios/countdown_5.mp3": "7b63de29b98ea0893c77aa0c35fd9289",
"assets/assets/audios/dance.mp3": "85b61448e010f1bffd7bb293ff9c447c",
"assets/assets/audios/highoctane.mp3": "8c9b55bcdf2723dd754ac7fc66dbb5d7",
"assets/assets/audios/jazzcomedy.mp3": "b6580c682b63e6c2a7cac0a89e99defc",
"assets/assets/audios/name_gajah_terbang.mp3": "ead29c40a56ceffd2a7723b6a190a616",
"assets/assets/audios/name_kapten_lautan.mp3": "294b710cb7b4f76c252af9ce37e99ce8",
"assets/assets/audios/name_kucing_ninja.mp3": "5b8625e7699749eaad4ee74715a5d953",
"assets/assets/audios/name_naga_berkilau.mp3": "d543e713e18044ba3d8bd799215a04fb",
"assets/assets/audios/name_pahlawan_super.mp3": "5d5c7cd8f6b6b8e8f04d48023ecd2e80",
"assets/assets/audios/name_panda_ajaib.mp3": "c6b129f4d33e7a2bd507d6d06fce2d64",
"assets/assets/audios/name_pangeran_bulan.mp3": "46252eac6cd256ec9ff90d74ec93279c",
"assets/assets/audios/name_peri_embun.mp3": "059bf6c18860d1b71739e514c186f5de",
"assets/assets/audios/name_putri_awan.mp3": "ea125b31c5fb15bec2e6431f067d8236",
"assets/assets/audios/name_putri_pelangi.mp3": "a35976861d7cbc9cbc8ef9de3a67050e",
"assets/assets/audios/name_raja_buah.mp3": "8d1e94e8fbf07aa0fea4c47e17bd6994",
"assets/assets/audios/name_raja_madu.mp3": "f1ce16dbb1697652fab8236e1f7e4b85",
"assets/assets/audios/name_raksasa_hutan.mp3": "e85247f563bb9a29b142d35846b6af7d",
"assets/assets/audios/name_ratu_es.mp3": "fffa59fa68d990850f371a02ac24f8bf",
"assets/assets/audios/name_ratu_kebaikan.mp3": "92c9b51a1f7e30cdb3bc76f332ec3730",
"assets/assets/audios/name_singa_ceria.mp3": "48454a61ef931d92b23bae24d5bcc3bd",
"assets/assets/audios/psychedelic.mp3": "be334a5cbe7aa5dbfe441cb17736ecf6",
"assets/assets/audios/tama_babak_ke.mp3": "3db3d4c86f19f72b241fabc48883f6de",
"assets/assets/audios/tama_belas.mp3": "4c8e4def97283581f50f9a4fef5c93d1",
"assets/assets/audios/tama_delapan.mp3": "6cc7a9f23e5b200b5f487ed818231451",
"assets/assets/audios/tama_dua.mp3": "5365c8e5c096b3131f07b3ab09d2a7cb",
"assets/assets/audios/tama_empat.mp3": "a9860fc2430a5455386d459d5e621b49",
"assets/assets/audios/tama_enam.mp3": "b8a96427c376960cf1c850d4188281ea",
"assets/assets/audios/tama_game_over.mp3": "21e7c00cd0500ad14a25a8688e2d55c8",
"assets/assets/audios/tama_game_over_single_winner_prefix.mp3": "2ee840604f01a4debcf3a79181ad5a9c",
"assets/assets/audios/tama_game_over_single_winner_suffix.mp3": "ef5974a098b5c9b7d5e7d094b834dbc0",
"assets/assets/audios/tama_game_start.mp3": "d2a279bcf6e76df757a752c1c5266218",
"assets/assets/audios/tama_hover.mp3": "0b20549c06bcdfa1bed98c3c4ad2a134",
"assets/assets/audios/tama_lima.mp3": "495970728df3ee9b4f0ab1dd17a1f7a4",
"assets/assets/audios/tama_player.mp3": "405bb57ae13ea0aa522059f1279f1b2a",
"assets/assets/audios/tama_player_confirmation.mp3": "5d91127e6b516561b6aff43351e3e72d",
"assets/assets/audios/tama_player_introduction.mp3": "3d885ef695985f2435cd6585b0dab14a",
"assets/assets/audios/tama_puluh.mp3": "bfc523981d0b7c2763d75a70d901d4ab",
"assets/assets/audios/tama_round_1.mp3": "50b13c16422725458186da5e184795be",
"assets/assets/audios/tama_round_end_multi_winner.mp3": "f1d22619f58b31e07ea14012adc65dec",
"assets/assets/audios/tama_round_end_no_winner.mp3": "92bd8536bb0c6fcb31ec13d023bacbee",
"assets/assets/audios/tama_round_end_reveal.mp3": "a1c220febf7fdd89745c6c70696813b2",
"assets/assets/audios/tama_round_end_single_winner_prefix.mp3": "702067b93666634940f06f1c8f955ee3",
"assets/assets/audios/tama_round_end_single_winner_suffix.mp3": "be88a809cdd16d5da1ef336ee1d4d8a9",
"assets/assets/audios/tama_satu.mp3": "c4bcc1983a270fa3f3d46979e858e6de",
"assets/assets/audios/tama_sebelas.mp3": "4fbbf4ae4eb991dc4f5595b4c9a15332",
"assets/assets/audios/tama_sembilan.mp3": "b8ea49671a05e816facce1bcceb759f5",
"assets/assets/audios/tama_sepuluh.mp3": "27cc09b526af874b13cfc67ddf13f3ae",
"assets/assets/audios/tama_tiga.mp3": "b513fdcf0cd8418f210f1c768857f455",
"assets/assets/audios/tama_tujuh.mp3": "d0b9458af283066b83dabfe2a05a0f24",
"assets/assets/audios/theelevatorbossanova.mp3": "2e241a46d463bcdefd5666d61f462d63",
"assets/assets/audios/thelounge.mp3": "57a5d01a88808c819eae8058f5ca8d00",
"assets/assets/fonts/MoreSugar-Regular.otf": "48b766ad311469dae34b29b3c0dee084",
"assets/assets/fonts/MoreSugar-Thin.otf": "fb5c72b4865521282e203b89e1001570",
"assets/assets/images/curlyline.png": "6a46854d325b6bb543a8856ad70fef85",
"assets/assets/images/dialog.png": "377e5e380d6ab69a0cf41ffccc2d5364",
"assets/assets/images/dialog2.png": "7f5bb6abce1aff48324960f7f67bf966",
"assets/assets/images/faceframe.png": "3ad5e0c23e9cc62957d063732688b68c",
"assets/assets/images/filmframe.png": "7cd997e6bdc53a6e5051f921d9ea4b85",
"assets/assets/images/flower.png": "e4a61f0409be1a8ab7ff093acc4a2ecc",
"assets/assets/images/frame1.png": "e00535f5113f5259a9c4bf34bf22b6e7",
"assets/assets/images/frame2.png": "a55bf678bd6c9867a06e7d6fc0bf3989",
"assets/assets/images/frame3.png": "7c37f4a5ae0d509b863ca21e63f3f7f1",
"assets/assets/images/frame4.png": "05c4b88ea50809266a931e11077e4d66",
"assets/assets/images/heart.png": "5642b3f1a551a345676a5f4b487f4c4b",
"assets/assets/images/loading1.gif": "1e20054574151470ba79209ca6bbebf6",
"assets/assets/images/loading2.gif": "1fcd2baa7d0e2ba053bac64f00d899d0",
"assets/assets/images/loading3.gif": "7bea06cd3a7d43dc52bc4097a17c6606",
"assets/assets/images/loading4.gif": "158d3c063d1e9e273f3eaa82e75f01cd",
"assets/assets/images/loading5.gif": "cd1f15b29d35025f1d1acc571b14b872",
"assets/assets/images/loading6.gif": "71c43415e405a4d74a43b70468a41e0b",
"assets/assets/images/loading7.gif": "fc2aa6309c393605d14f02747cc3d61a",
"assets/assets/images/logolower.png": "0ff713ca9a20b3834de8fb5a3aab70db",
"assets/assets/images/logoplus.png": "76f09ea95d97f89c21267fe1d2ed0021",
"assets/assets/images/logosplash.png": "06fdc0f6f421018a1633d0be07ac8903",
"assets/assets/images/logosplashwhite.png": "6470bc91264369a6d7102b3755c51cf4",
"assets/assets/images/logoupper.png": "a7fc8aca71a44cd3b84bd09de45e6a1c",
"assets/assets/images/logoversion.png": "540415f14977596bed9f939d680d3627",
"assets/assets/images/menuamel.png": "96c25493b492f57295b5676ae41b7574",
"assets/assets/images/menurobot.png": "7160d7bf387a23a21c222544b03ab5c8",
"assets/assets/images/menutama.png": "e22aafbd22fb38f346fa4f6f2d6e6c32",
"assets/assets/images/photoframe.png": "59e9acd30e1ec388aa481a8131ef1c6d",
"assets/assets/images/pointer.png": "f97300c628aa7c7f7d203913d80c5bbb",
"assets/assets/images/round.png": "a4ddaa39dc2c98ff5dcd2bc2d26bfa00",
"assets/assets/images/roundstartsin.png": "aa37384f0846d787520930950cbfbca6",
"assets/assets/images/shine1.png": "33f8d00512ca11d841848e8e7eafc14a",
"assets/assets/images/shine2.png": "c1c0f5a7c9d700ec58d4596d106b96f8",
"assets/assets/images/spiralline.png": "49a95e4683e6d2ccd82b1743b8717df3",
"assets/assets/images/star.png": "7acf521cdd1fd018f36efc0c0d30d589",
"assets/assets/images/trophybronze.png": "08a1a35f7dad0172b3923022a329f87f",
"assets/assets/images/trophygold.png": "795881724d58ac527ce2a33d30fc72ef",
"assets/assets/images/trophysilver.png": "e70f7ff8db7a392512a574155c1c36d4",
"assets/FontManifest.json": "0c5a238a7cb88a2da1a2e21c1113284c",
"assets/fonts/MaterialIcons-Regular.otf": "eb01d1e7effe1542a8de70a82bdc0efc",
"assets/NOTICES": "7675f7b6a8a56b33bb4d0c4d4be87186",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "95f3be4e61f8b69888bacd901fd6bc0c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "5131e33394912c717cadf22c26e710ff",
"/": "5131e33394912c717cadf22c26e710ff",
"main.dart.js": "bba93da985e97f149f231e5d9c96a659",
"main.dart.mjs": "fb7c0660c59844b6950da5dae00aa442",
"main.dart.wasm": "2461985b55e3dbf618fe97011004b3af",
"manifest.json": "3f0ddd7af3f6e2005cc73785aa1f15e3",
"version.json": "3cbde7e1a20c66ae2da4a0e83b4cc37f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
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
