{{flutter_js}}
{{flutter_build_config}}

// Retain this project's existing versioned service-worker cache. Rendering
// never waits for portfolio photos: they are requested by visible widgets.
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}}
  },
  onEntrypointLoaded: async function(engineInitializer) {
    try {
      const appRunner = await engineInitializer.initializeEngine();
      await appRunner.runApp();
    } catch (error) {
      window.portfolioStartupFailed?.();
      console.error('Portfolio initialization failed', error);
    }
  }
}).catch((error) => {
  window.portfolioStartupFailed?.();
  console.error('Portfolio loading failed', error);
});
