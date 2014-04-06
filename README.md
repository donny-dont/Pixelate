# Pixelate

> A UI widget library for creating modern web applications; Pixelate targets the modern web by using Web Components. The library leverages the [Polymer.dart library](https://www.dartlang.org/polymer-dart/) to create a set of widgets that would be expected in native native application development.

[![Build Status](https://drone.io/github.com/donny-dont/Pixelate/status.png)](https://drone.io/github.com/donny-dont/Pixelate/latest)

# Components
The following components are available for use.
 * **Layout**
   * [FlexPanel](http://donny-dont.github.io/Pixelate/components/flex_panel/index.html)
   * [GridPanel](http://donny-dont.github.io/Pixelate/components/grid_panel/index.html)
 * **Navigation**
   * [Accordion](http://donny-dont.github.io/Pixelate/components/accordion/index.html)
   * [Expander](http://donny-dont.github.io/Pixelate/components/expander/index.html)
   * [ScrollViewer](http://donny-dont.github.io/Pixelate/components/scroll_viewer/index.html)
   * [Tab](http://donny-dont.github.io/Pixelate/components/tab/index.html)
   * [ScrollViewer](http://donny-dont.github.io/Pixelate/components/tree_view/index.html)
 * **Controls**
   * [Button](http://donny-dont.github.io/Pixelate/components/button/index.html)
   * [ListView](http://donny-dont.github.io/Pixelate/components/list_view/index.html)
   * [ProgressBar](http://donny-dont.github.io/Pixelate/components/progress_bar/index.html)
   * [Tooltip](http://donny-dont.github.io/Pixelate/components/tooltip/index.html)

# Themes

Pixelate was built with customization in mind. All components have hooks to change the styling to fit the application. The themes provided are modern flat designs.

# Install

Pixelate is a pub package. To install it, and link it into your app, add pixelate to your pubspec.yaml. For example:

    name: your_cool_app
    dependencies:
      pixelate: any
      pixelate_flat: any

If you use Dart Editor, select your project from the Files view, then goto Tools, and run Pub Install.

If you use the command line, ensure the Dart SDK is on your path, and then run: `pub install`

# Compatible browsers

The Polymer.dart library shares the polyfills provided through JavaScript within the [Polymer Project](http://www.polymer-project.org/). Polymer and its polyfills are intended to work in the latest version of ["evergreen browsers"](http://www.yetihq.com/blog/evergreen-web-browser/). Because of this make sure the browsers you are targeting are available before starting a project with Pixelate. The current status of browser support can be tracked [here](http://www.polymer-project.org/resources/compatibility.html).

Pixelate has been tested on the following browsers

* Chrome 32+ (with Experimental Web Platform Features chrome://flags/#enable-experimental-web-platform-features enabled) 

# Authors
 * [Ali Akbar](https://github.com/coderespawn)
 * [Don Olmstead](https://github.com/donny-dont)
 * [Erik Gui](https://github.com/erikgui)

# Copyright and license

Code and documentation are copyright 2013-2014 by the Pixelate authors. Code released under [the zlib license](LICENSE). Docs released under Creative Commons.
