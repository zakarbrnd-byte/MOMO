{{flutter_js}}
{{flutter_build_config}}

(function () {
  var loading = document.getElementById("momo-loading");
  var removed = false;

  function hideLoading() {
    if (removed) return;
    removed = true;
    if (!loading) return;
    loading.classList.add("hidden");
    window.setTimeout(function () {
      if (loading && loading.parentNode) {
        loading.parentNode.removeChild(loading);
      }
      loading = null;
    }, 200);
  }

  // Safety net if bootstrap stalls (should rarely fire).
  window.setTimeout(hideLoading, 15000);

  _flutter.loader.load({
    onEntrypointLoaded: async function (engineInitializer) {
      var appRunner = await engineInitializer.initializeEngine();
      await appRunner.runApp();
      // Prefer a paint callback when available so Hangul never flashes.
      if (window.requestAnimationFrame) {
        window.requestAnimationFrame(function () {
          window.requestAnimationFrame(hideLoading);
        });
      } else {
        hideLoading();
      }
    },
  });
})();
