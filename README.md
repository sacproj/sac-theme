# Slides as Code Theme

[Hugo](https://gohugo.io/) theme integrating an opinionated distribution of [Reveal.js](https://revealjs.com/).

# Demo
Check out the [live demo](https://sacproj.github.io/demo/).

# Documentation
See online [documentation](https://sacproj.github.io/documentation/).

# Inspirations
This distribution is inspired by following Hugo themes and projects using Reveal.js
- [Hugo Theme Reveal.js](https://github.com/RealOrangeOne/hugo-theme-revealjs)
- [Reveal Hugo](https://github.com/dzello/reveal-hugo)
- [GitPitch](https://gitpitch.com/)

## Differences with Reveals.js upstream
- [Expose preview management functions](https://github.com/hakimel/reveal.js/pull/2901)
- Override Reveal CSS in `assets/reveal/reveal.scss` (especially disabled perspective to support grid elements)

## Fixed elements and transitions
To avoid jumping and flicking fixed position elements (such as blocks, diagrams, charts...),  don't use geomtric transitions.

# Configuration for Hugo site
``` yaml
baseURL: https://example.org/
languageCode: en-us
disableKinds: ["taxonomy", "taxonomyTerm", "RSS", "sitemap"]
outputs:
  home: ["sac"]
  page: ["sac"]
  section: ["sac"]
themesDir : "/usr/local/share/sac/themes"
theme: ["sac/x.y.z"]
markup:
  goldmark:
    renderer:
      unsafe: true
```
- Set `unsafe` to Goldmark render for complete support of `markdownify` functions (used in some shortcodes)

# Project Management
This project adheres to:
- [Developer Certificate of Origin](https://developercertificate.org/)
- [Conventional Commit Messages](https://www.conventionalcommits.org/en/v1.0.0/)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

# Authors
Developed with passion by Stéphane Este-Gracias and great open source [contributors](https://github.com/sacproj/sac-theme/graphs/contributors).

# License
## sac-theme
sac-theme's code is released under [MIT license](LICENSE).

Third-party Open Source components, Reveal.js plugins and fonts are distributed within this project.
See the list and their relative licenses below.

## Components
| Component | Repository | License |
| --------- | ---------- | ------- |
| asciinema-player | [asciinema/asciinema-player](https://github.com/asciinema/asciinema-player) | [Apache License 2.0](https://raw.githubusercontent.com/asciinema/asciinema-player/develop/LICENSE) |
| draw.io | [jgraph/drawio](https://github.com/jgraph/drawio) | [Apache License 2.0](https://github.com/jgraph/drawio/blob/master/LICENSE) |
| highlight.js | [highlightjs/highlight.js](https://github.com/highlightjs/highlight.js) | [BSD 3-Clause License](https://github.com/highlightjs/highlight.js/blob/master/LICENSE) |
| reveal.js | [hakimel/reveal.js](https://github.com/hakimel/reveal.js) | [MIT license](https://github.com/hakimel/reveal.js/blob/master/LICENSE) |
| typed.js | [mattboldt/typed.js](https://github.com/mattboldt/typed.js/) | [MIT license](https://github.com/mattboldt/typed.js/blob/master/LICENSE.txt) |

## Reveal.js plugins
| Plugin | Repository | License |
| ------ | ---------- | ------- |
| menu | [denehyg/reveal.js-menu](https://github.com/denehyg/reveal.js-menu) | [MIT license](https://github.com/denehyg/reveal.js-menu/blob/master/LICENSE) |
| reveal.js-plugins | [rajgoel/reveal.js-plugins](https://github.com/rajgoel/reveal.js-plugins) | [MIT License](https://github.com/rajgoel/reveal.js-plugins/blob/master/LICENSE) |

## Fonts
| Font | Repository | License |
| ---- | ---------- | ------- |
| FontAwesome | [FortAwesome/Font-Awesome](https://github.com/FortAwesome/Font-Awesome) | [Font Awesome Free License](https://github.com/FortAwesome/Font-Awesome/blob/master/LICENSE.txt) |
| Hack | [source-foundry/hack](https://github.com/source-foundry/Hack) | [MIT license](https://github.com/source-foundry/Hack/blob/master/LICENSE.md) |
| Open Sans | [googlefonts/opensans](https://github.com/googlefonts/opensans) | [Apache License 2.0](https://github.com/googlefonts/opensans/blob/master/LICENSE.txt) |
| Raleway | [googlefonts/raleway](https://github.com/googlefonts/Raleway) | [SIL Open Font License 1.1](https://github.com/googlefonts/Raleway/blob/master/OFL.txt)

## Applications on iframe
| Application | Repository | License |
| ----------- | ---------- | ------- |
| ttyd | [tsl0922/ttyd](https://github.com/tsl0922/ttyd) | [MIT License](https://github.com/tsl0922/ttyd/blob/master/LICENSE) |
| code-server | [cdr/code-server](https://github.com/cdr/code-server) | [MIT license](https://github.com/cdr/code-server/blob/master/LICENSE.txt) |

# Acknowledgments
- [Data Essential](https://www.data-essential.com/) to give time and means to develop and maintain this project.
