# Default parameters
FONT_NAMES ?= "Raleway" "Open Sans"
HIGHLIGHTJS_STYLE ?= dracula

# Overrides
REVEAL_URL = git@github.com:sacproj/reveal.js.git
REVEAL_VERSION = showPreview

HACK_FONT_VERSION ?= v3.003
FONTAWESOME_VERSION ?= 5.15.2
REVEAL_VERSION ?= 4.1.0
REVEAL_PLUGINS_VERSION ?= master
REVEAL_MENU_VERSION ?= 2.1.0
REVEAL_CODE_FOCUS_VERSION ?= 1.1.0
MATHJAX_VERSION ?= 2.7.9
CHART_VERSION ?= 2.9.4
TYPED_VERSION ?= 2.0.11
ASCIINEMA_VERSION ?= 2.6.1
DRAWIO_VERSION ?= v14.3.0

# Reveal overrides
REVEAL_HIGHLIGHTJS_VERSION ?= 10.6.0
REVEAL_MARKED_VERSION ?= 1.2.9


# Package URLs
FONT_HACK_URL ?= https://github.com/source-foundry/Hack/releases/download/$(HACK_FONT_VERSION)/Hack-$(HACK_FONT_VERSION)-webfonts.zip
FONTAWESOME_URL ?= @fortawesome/fontawesome-free@$(FONTAWESOME_VERSION)
REVEAL_URL ?= git@github.com:hakimel/reveal.js
REVEAL_PLUGINS_URL ?= "reveal.js-plugins\#$(REVEAL_PLUGINS_VERSION)"
REVEAL_MENU_URL ?= "reveal.js-menu\#$(REVEAL_MENU_VERSION)"
MATHJAX_URL ?= "mathjax@$(MATHJAX_VERSION)"
CHART_URL ?= "chart.js\#$(CHART_VERSION)"
TYPED_URL ?= "typed.js\#${TYPED_VERSION}"
ASCIINEMA_URL ?= "asciinema-player@$(ASCIINEMA_VERSION)"
DRAWIO_URL ?= "git@github.com:jgraph/drawio.git"
# Development tools URLs
GOOGLE_FONT_DOWNLOAD_URL ?= https://raw.githubusercontent.com/neverpanic/google-font-download/master/google-font-download
MO_URL := https://raw.githubusercontent.com/tests-always-included/mo/master/mo


#######################################################################################################################
# Paths
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUILDER_PATCHES_PATH := $(ROOT_DIR)/patches

PWD := $(shell pwd)
ASSETS_PATH := $(PWD)/assets
BUILD_PATH := $(PWD)/build
BOWER_COMPONENTS_PATH := $(BUILD_PATH)/bower_components
NODE_MODULES_PATH := $(BUILD_PATH)/node_modules
DIST_PATH := $(PWD)/dist
LAYOUTS_PATH := $(PWD)/layouts
STATIC_PATH := $(PWD)/static

BUILD_FONTS_PATH := $(BUILD_PATH)/fonts
BUILD_TOOLS_PATH := $(BUILD_PATH)/tools
BUILD_TMP_PATH := $(BUILD_PATH)/tmp
BUILD_REVEAL_JS_PATH := $(BUILD_PATH)/reveal.js
BUILD_DRAWIO_PATH := $(BUILD_TMP_PATH)/drawio

ASSETS_REVEAL_TEMPLATE_PATH := $(ASSETS_PATH)/sac/scss/template
CSS_PATH := $(STATIC_PATH)/css
FONTS_PATH := $(STATIC_PATH)/fonts
LIBS_PATH := $(STATIC_PATH)/libs
LIB_REVEAL_PATH := $(LIBS_PATH)/reveal.js
LIB_REVEAL_FULLSCREEN_PATH := $(LIB_REVEAL_PATH)/plugin/fullscreen
LIB_REVEAL_MENU_PATH := $(LIB_REVEAL_PATH)/plugin/menu
LIB_REVEAL_CHART_PATH := $(LIB_REVEAL_PATH)/plugin/chart
LIB_REVEAL_ANYTHING_PATH := $(LIB_REVEAL_PATH)/plugin/anything
LIB_MATHJAX_PATH := $(LIBS_PATH)/mathjax
LIB_CHART_PATH := $(LIBS_PATH)/chart.js
LIB_TYPED_PATH := $(LIBS_PATH)/typed.js
LIB_ASCIINEMA_PATH := $(LIBS_PATH)/asciinema-player
LIB_HIGHLIGHT_PATH := $(LIBS_PATH)/highlight.js
LIB_DRAWIO_PATH := $(LIBS_PATH)/drawio


# Tools
AWK := awk
BOWER := bower
BREW := brew
CD := cd
CHMODX := chmod +x
CP := cp -f
CPDIR := cp -fa
COLUMN := column
CURL := curl -L
DIFF := diff -u
FIND := find
GH := gh
GIT := git
GULP := gulp
GOOGLE_FONT_DOWNLOAD := $(BUILD_TOOLS_PATH)/$(shell basename $(GOOGLE_FONT_DOWNLOAD_URL))
MKDIR := mkdir -p
MO_EXE := $(BUILD_TOOLS_PATH)/$(shell basename $(MO_URL))
MV := mv -f
NODE := node
NPM := npm
PYTHON := python
RM := rm -f
RMDIR := rm -rf
SASS := sass
SED := sed
TAR := tar
UNZIP := unzip -o


# Default targets
_DEFAULT_GOAL: help

.PHONY: build-theme
## Build theme
build-theme: tools fonts reveal theme

# Directories creation
$(BUILD_PATH) $(BUILD_FONTS_PATH) $(STATIC_PATH) $(BUILD_TOOLS_PATH) $(BUILD_TMP_PATH) $(FONTS_PATH) $(LIBS_PATH):
	$(MKDIR) $@

# Installation
.PHONY: tools npm bower google_font_download
## Install required tools
tools: npm bower google_font_download

npm:
	which npm || $(BREW) install node
	echo '{}' > $(PWD)/package.json

bower:
	which bower || $(NPM) install -g bower

gulp:
	which gulp || $(NPM) install -g gulp

google_font_download: $(BUILD_TOOLS_PATH)
	$(CURL) "$(GOOGLE_FONT_DOWNLOAD_URL)" > $(GOOGLE_FONT_DOWNLOAD)
	$(CHMODX) $(GOOGLE_FONT_DOWNLOAD)


# Fonts
.PHONY: fonts font_init font_main font_hack fontawesome
## Install fonts
fonts: font_main font_hack fontawesome

font_init: $(BUILD_TMP_PATH) $(BUILD_FONTS_PATH) $(STATIC_PATH) $(FONTS_PATH)

font_main: google_font_download font_init
	export PATH="/usr/local/opt/gnu-getopt/bin:$$PATH"; \
	$(CD) $(FONTS_PATH); \
	for FONT_NAME in $(FONT_NAMES); do \
	  $(GOOGLE_FONT_DOWNLOAD) -o "$$FONT_NAME.css" -f "woff2"\
	  	"$$FONT_NAME:300" \
	    "$$FONT_NAME:300italic" \
	    "$$FONT_NAME:400" \
	    "$$FONT_NAME:400italic" \
	    "$$FONT_NAME:700" \
	    "$$FONT_NAME:700italic"; done

font_hack: font_init
	$(CURL) $(FONT_HACK_URL) > $(BUILD_TMP_PATH)/Hack.zip
	$(UNZIP) -d $(BUILD_FONTS_PATH) $(BUILD_TMP_PATH)/Hack.zip
	$(SED) -e 's|fonts/||g' -e 's|, url.*|;|' $(BUILD_FONTS_PATH)/web/hack.css > $(FONTS_PATH)/hack.css
	$(CP) $(BUILD_FONTS_PATH)/web/fonts/*.woff2 $(FONTS_PATH)
	$(RM) $(FONTS_PATH)/*-subset.*

fontawesome: font_init
	cd $(BUILD_PATH) && $(NPM) install $(FONTAWESOME_URL)
	$(MKDIR) $(STATIC_PATH)/fontawesome
	$(CPDIR) $(NODE_MODULES_PATH)/@fortawesome/fontawesome-free/{css,webfonts} $(STATIC_PATH)/fontawesome


# Reveal-js and related projects
.PHONY: reveal \
		reveal.js-install reveal.js-build \
        reveal.js reveal.js-plugins reveal.js-menu \
        mathjax chart typed asciinema-player \
		drawio
## Install reveal-js, plugins and related projects
reveal: reveal.js-install reveal.js-build \
		reveal.js reveal.js-plugins reveal.js-menu \
        mathjax chart typed asciinema-player \
		drawio

reveal.js-install:
	$(RMDIR) $(BUILD_REVEAL_JS_PATH)
	$(MKDIR) $(BUILD_REVEAL_JS_PATH)
	$(GIT) clone --depth 1 --branch $(REVEAL_VERSION) $(REVEAL_URL) $(BUILD_REVEAL_JS_PATH)
	$(CD) $(BUILD_REVEAL_JS_PATH) && \
	  $(NPM) install && \
	  $(NPM) install highlight.js@$(REVEAL_HIGHLIGHTJS_VERSION) --save-dev && \
	  $(NPM) install marked@$(REVEAL_MARKED_VERSION) --save-dev
	$(MKDIR) $(DIST_PATH)
	$(CP) $(BUILD_REVEAL_JS_PATH)/package-lock.json $(DIST_PATH)/reveal.js-package-lock.json

reveal.js-build:
	$(CD) $(BUILD_REVEAL_JS_PATH) && $(GULP) package

reveal.js: reveal.js-install reveal.js-build
	# Copy $@
	$(MKDIR) $(LIB_REVEAL_PATH)
	$(CPDIR) $(BUILD_REVEAL_JS_PATH)/dist/* $(LIB_REVEAL_PATH)
	$(CPDIR) $(BUILD_REVEAL_JS_PATH)/plugin $(LIB_REVEAL_PATH)
	$(CPDIR) $(BUILD_REVEAL_JS_PATH)/css/theme/template/* $(ASSETS_REVEAL_TEMPLATE_PATH)
	$(CP) $(BUILD_REVEAL_JS_PATH)/node_modules/highlight.js/styles/$(HIGHLIGHTJS_STYLE).css $(LIB_REVEAL_PATH)/plugin/highlight/highlight.css

reveal.js-plugins:
	cd $(BUILD_PATH) && $(BOWER) install $(REVEAL_PLUGINS_URL)
	# Chart
	$(MKDIR) $(LIB_REVEAL_CHART_PATH)
	$(CP) $(BOWER_COMPONENTS_PATH)/reveal.js-plugins/chart/plugin.js $(LIB_REVEAL_CHART_PATH)

reveal.js-menu:
	cd $(BUILD_PATH) && $(BOWER) install $(REVEAL_MENU_URL)
	$(MKDIR) $(LIB_REVEAL_MENU_PATH)
	$(CP) $(BOWER_COMPONENTS_PATH)/reveal.js-menu/menu.{css,esm.js,js} $(LIB_REVEAL_MENU_PATH)

mathjax:
	cd $(BUILD_PATH) && $(NPM) install $(MATHJAX_URL)
	$(MKDIR) $(LIB_MATHJAX_PATH)
	$(CP) $(NODE_MODULES_PATH)/mathjax/MathJax.js $(LIB_MATHJAX_PATH)

chart:
	cd $(BUILD_PATH) && $(BOWER) install $(CHART_URL)
	$(MKDIR) $(LIB_CHART_PATH)
	$(CP) $(BOWER_COMPONENTS_PATH)/chart.js/dist/Chart.min.js $(LIB_CHART_PATH)/chart.js

typed:
	cd $(BUILD_PATH) && $(BOWER) install $(TYPED_URL)
	$(MKDIR) $(LIB_TYPED_PATH)
	$(CP) $(BOWER_COMPONENTS_PATH)/typed.js/lib/typed.min.js $(LIB_TYPED_PATH)/typed.js

asciinema-player:
	cd $(BUILD_PATH) && $(NPM) install $(ASCIINEMA_URL)
	$(MKDIR) $(LIB_ASCIINEMA_PATH)
	$(CPDIR) $(NODE_MODULES_PATH)/asciinema-player/resources/public/{css,js}/* $(LIB_ASCIINEMA_PATH)

drawio:
	$(RMDIR) $(BUILD_DRAWIO_PATH)
	$(MKDIR) $(BUILD_DRAWIO_PATH)
	$(GIT) clone --depth 1 --branch $(DRAWIO_VERSION) $(DRAWIO_URL) $(BUILD_DRAWIO_PATH)
	$(MKDIR) $(LIB_DRAWIO_PATH)
	$(CP) $(BUILD_DRAWIO_PATH)/src/main/webapp/js/viewer.min.js $(LIB_DRAWIO_PATH)/viewer.min.js
	$(CP) -r $(BUILD_DRAWIO_PATH)/src/main/webapp/{img,math,mxgraph,shapes,stencils} $(LIB_DRAWIO_PATH)


# Release
.PHONY: prepare-release publish-release

GIT_REMOTE = origin
GIT_URL = https://github.com/sacproj/sac-theme
RELEASE_ARTIFACTS = .vscode archetypes assets layouts static config.yaml LICENSE theme.toml VERSION
RELEASE_TARBALL = $(BUILD_PATH)/sac-theme.tar.gz
THEME = sac

## Build release
prepare-release: $(BUILD_PATH)
	echo "$(THEME)/$(VERSION)" > VERSION
	$(RM) $(RELEASE_TARBALL)
	$(TAR) cvzf $(RELEASE_TARBALL) $(RELEASE_ARTIFACTS)

## Prepare release (requires defined VERSION)
publish-release:
	$(GH) release create $(VERSION) -t $(VERSION) -n "See changes in [CHANGELOG.md]($(GIT_URL)/blob/$(VERSION)/CHANGELOG.md)"
	$(GH) release upload $(VERSION) $(RELEASE_TARBALL)

# Cleaning
.PHONY: clean clean-build clean-npm clean-bower
## Clean artifacts
clean: clean-build clean-npm clean-bower

clean-version:
	$(RM) VERSION

clean-build:
	$(RMDIR) $(BUILD_PATH)

clean-npm:
	$(RMDIR) $(NODE_MODULES_PATH)

clean-bower:
	$(RMDIR) $(BOWER_COMPONENTS_PATH)


.PHONY: help
## Display this help message
help:
	$(info Available targets)
	@$(AWK) '/^[a-zA-Z\-\\_0-9]+:/ {                                   \
	  nb = sub( /^## /, "", helpMsg );                             \
	  if(nb == 0) {                                                \
	    helpMsg = $$0;                                             \
	    nb = sub( /^[^:]*:.* ## /, "", helpMsg );                  \
	  }                                                            \
	  if (nb)                                                      \
	    printf "\033[1;31m%-" width "s\033[0m %s\n", $$1, helpMsg; \
	}                                                              \
	{ helpMsg = $$0 }'                                             \
	$(MAKEFILE_LIST) | $(COLUMN) -ts:
