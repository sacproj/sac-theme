import * as params from '@params';

// Hugo lowercases all params and Reveal.js needs camelcase
// So params in Hugo must be stored in snakecase and we camelize them here
function camelize(map) {
  if (map) {
    Object.keys(map).forEach(function (k) {
      newK = k.replace(/(\_\w)/g, function (m) {
        return m[1].toUpperCase()
      });
      if (newK != k) {
        map[newK] = map[k];
        delete map[k];
      }
    });
  }
  return map;
}

// Initialize reveal
var gridPalette = params.theme.colors.chart.palette;
var gridFillPalette = params.theme.colors.chart.fill;
var revealDefaults = {
  // Reveal.js geometry
  width: params.geometry.width,
  height: params.geometry.height,
  margin: params.geometry.margin,
  minScale: params.geometry.scale.min,
  maxScale: params.geometry.scale.max,
  // Reveal.js options
  controls: false,
  controlsTutorial: false,
  disableLayout: false,
  hash: true,
  history: false,
  navigationMode: "linear",
  showNotes: false,
  previewLinks: true,
  transition: "fade",
  transitionSpeed: "default",
  backgroundTransition: "fade",
  pdfMaxPagesPerSlide: 1,

  // Plugin options
  math: {
    mathjax: 'libs/mathjax/MathJax.js',
  },
  menu: {
    numbers: true,
    markers: false,
    openButton: false,
    custom: false,
    themes: false,
    loadIcons: false,
  },
  chart: {
    defaults: {
      global: {
        defaultFontFamily: params.theme.main_font.name,
        defaultFontColor: params.theme.colors.main,
        defaultFontSize: params.theme.font_size.chart,
        legend: {
          position: "bottom",
        },
      },
      scale: {
        gridLines: {
          color: params.theme.colors.chart.grid
        },
      },
    },
    line: {
      "borderColor": gridPalette,
      "backgroundColor": gridPalette,
      "fill": [false],
    },
    scatter: {
      "borderColor": gridPalette,
      "backgroundColor": gridPalette,
    },
    bar: {
      "backgroundColor": [gridPalette],
    },
    horizontalBar: {
      "backgroundColor": [gridPalette],
    },
    pie: {
      "backgroundColor": [gridPalette],
    },
    doughnut: {
      "backgroundColor": [gridPalette],
    },
    radar: {
      "backgroundColor": gridFillPalette,
      "borderColor": gridPalette,
      "pointBorderColor": ["#fff"],
      "pointBackgroundColor": gridPalette,
    },
    polarArea: {
      "backgroundColor": [gridPalette],
    },
    bubble: {
      "backgroundColor": gridFillPalette,
      "borderColor": gridPalette,
    },
  },
  plugins: [
    RevealMarkdown,
    RevealHighlight,
    RevealMath,
    RevealNotes,
    RevealSearch,
    RevealZoom,
    RevealMenu,
    RevealChart,
  ],
};

// Initialize draw.io
window.onDrawioViewerLoad = function () {
  console.log("diagrams.net loaded");
  // Issue with drawio diagram position when processing => process all when loading slides
  GraphViewer.processElements();
};
STENCIL_PATH = "libs/drawio/stencils";
SHAPES_PATH = "libs/drawio/shapes";
DRAW_MATH_URL = "libs/drawio/math";
DRAWIO_URL = "libs/drawio/";
mxBasePath = "libs/drawio/mxgraph";

// See all options - https://revealjs.com/config/
var options = Object.assign({},
  revealDefaults,
  camelize(params.options),
);
Reveal.initialize(options);

// Manage asciinema autoplay
function playAsciinema(section) {
  var elements = section.querySelectorAll("asciinema-player");
  if (elements.length != 0) {
    for (var i = 0; i < elements.length; ++i) {
      var element = elements[i];
      if (element.hasAttribute('data-autoplay')) {
        element.play();
      }
    }
  }
}

function stopAsciinema(section) {
  if (section !== undefined) {
    var elements = section.querySelectorAll("asciinema-player");
    if (elements.length != 0) {
      for (var i = 0; i < elements.length; ++i) {
        var element = elements[i];
        element.pause();
      }
    }
  }
}

// Manage typed
var typeds = [];

function startTyped(section) {
  // Stop previous typings
  if (typeds.length > 0) {
    for (var i = 0; i < typeds.length; ++i) {
      var typed = typeds[i];
      typed.stop();
      typed.destroy();
    }
  }
  typeds = [];

  // Start section typings
  var elements = section.querySelectorAll(".typing");
  if (elements.length != 0) {
    for (var i = 0; i < elements.length; ++i) {
      var element = elements[i];
      var code = element.getAttribute('data-code');
      var typeSpeed = element.getAttribute('data-type-speed');
      var startDelay = element.getAttribute('data-start-delay');
      var backSpeed = element.getAttribute('data-back-speed');
      var smartBackspace = element.getAttribute('data-smart-backspace');
      var shuffle = element.getAttribute('data-shuffle');
      var backDelay = element.getAttribute('data-back-delay');
      var loop = element.getAttribute('data-loop');
      var loopCount = element.getAttribute('data-loop-count');
      var showCursor = element.getAttribute('data-show-cursor');
      var cursorChar = element.getAttribute('data-cursor-char');
      var options = {
        stringsElement: '#typed-strings-' + code,
        typeSpeed: parseInt(typeSpeed),
        startDelay: parseInt(startDelay),
        backSpeed: parseInt(backSpeed),
        smartBackspace: (smartBackspace == "true"),
        shuffle: (shuffle == "true"),
        backDelay: parseInt(backDelay),
        loop: (loop == "true"),
        loopCount: parseInt(loopCount),
        showCursor: (showCursor == "true"),
        cursorChar: cursorChar,
        onComplete: (self) => {
          if (loop == "false") {
            Reveal.nextFragment();
          }
        },
      };
      var typed = new Typed('#typed-' + code, options);
      typeds.push(typed);
    }
  }
}

// Refresh iframe regarding 'data-iframe-refresh' attribute value
var iframeTimeout;

function startRefreshIframeTimer(section) {
  var params = section.getAttribute("data-iframe-refresh");
  if (params != null) {
    var array = params.split(":", 2);
    var id = array[0];
    var timeout = 5000;
    if (array.length > 1) {
      timeout = array[1];
    }
    var iframe = section.querySelector(`#${id}`);
    iframe.src = iframe.src;
    if (timeout != 0) {
      iframeTimeout = window.setInterval(function () {
        iframe.src = iframe.src;
      }, timeout);
    }
  }
}

function stopRefreshIframeTimer(section) {
  if (section !== undefined && iframeTimeout !== undefined) {
    window.clearInterval(iframeTimeout);
  }
}

// Draw.io
function drawIo(section) {
  var elements = section.querySelectorAll(".drawio");
  if (elements.length != 0) {
    for (var i = 0; i < elements.length; ++i) {
      var element = elements[i];
      element.classList.remove("drawio");
      element.classList.add("mxgraph");
    }
    GraphViewer.processElements();
  }
}

// Automatic preview management
function showPreview(section) {
  var url = section.getAttribute("data-iframe");
  if (url != null) {
    Reveal.showPreview(url);
  }
}

function hidePreview(section) {
  if (section !== undefined) {
    var url = section.getAttribute("data-iframe");
    if (url != null) {
      Reveal.hidePreview(url);
    }
  }
}

// Listen Reveal events
Reveal.on('ready', function (event) {
  // event.currentSlide, event.indexh, event.indexv
  if ((Reveal.isOverview() && Reveal.isSpeakerNotes()) === false) {
    playAsciinema(event.currentSlide);
    drawIo(event.currentSlide);
    startTyped(event.currentSlide);
    startRefreshIframeTimer(event.currentSlide);
    showPreview(event.currentSlide);
  }
});

Reveal.on('slidechanged', function (event) {
  // event.previousSlide, event.currentSlide, event.indexh, event.indexv
  if ((Reveal.isOverview() && Reveal.isSpeakerNotes()) === false) {
    stopAsciinema(event.previousSlide);
    playAsciinema(event.currentSlide);
    drawIo(event.currentSlide);
    startTyped(event.currentSlide);
    stopRefreshIframeTimer(event.previousSlide);
    startRefreshIframeTimer(event.currentSlide);
    hidePreview(event.previousSlide);
    showPreview(event.currentSlide);
  }
});