{{flutter_js}}
{{flutter_build_config}}

// Select the existing UI elements from the DOM
const loadingContainer = document.getElementById('loading-container');

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    // Completely purge the HTML loader structure right before launching the app canvas
    if (loadingContainer) loadingContainer.remove();
    await appRunner.runApp();
  }
});
