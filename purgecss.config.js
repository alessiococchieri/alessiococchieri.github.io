module.exports = {
  content: ["_site/**/*.html", "_site/**/*.js"],
  css: [
    "_site/assets/css/tailwind.css",
    "_site/assets/css/main.css",
    "_site/assets/css/al-folio-distill.css",
    "_site/assets/css/jekyll-pygments-themes-github.css",
    "_site/assets/css/jekyll-pygments-themes-native.css",
    "_site/assets/css/jupyter.css",
    "_site/assets/css/jupyter-grade3.css",
    "_site/assets/css/jupyter-monokai.css",
    // al-folio-cv.css is excluded — it contains targeted overrides that
    // PurgeCSS incorrectly strips due to compound/duplicate selectors.
  ],
  output: "_site/assets/css/",
  skippedContentGlobs: ["_site/assets/**/*.html"],
  safelist: [
    "collapse",
    "collapsing",
    "show",
    "dropdown-menu",
    "dropdown-item",
    "table",
    "table-dark",
    "table-hover",
    "table-responsive",
    "af-tooltip",
    "af-popover",
    "font-weight-bold",
    "font-weight-medium",
    "font-weight-lighter",
    // medium-zoom injects these at runtime, so they never appear in the static
    // HTML PurgeCSS scans; without them the zoom overlay's z-index rule is purged
    // and page chrome (scroll-progress bar, ToC) bleeds through a zoomed image.
    "medium-zoom-overlay",
    "medium-zoom-image--opened",
    // CV date/badge overrides in assets/css/al-folio-cv.css
    "date-column",
    "iconlocation",
    "list-group-item",
  ],
};
