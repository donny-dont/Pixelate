// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [FlexPanel] class.
library pixelate_flex_panel;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-flex-panel';

/// Represents a container that utilizes a flexible layout.
///
/// The direction the panel should flex is defined by the [orientation
/// attribute, which takes a string. By default the value is horizontal.
///
///     <!-- Horizontal content; the default -->
///     <px-flex-panel orientation="horizontal"></px-expander>
///     <!-- Vertical content -->
///     <px-flex-panel orientation="vertical"></px-expander>
///
/// The [FlexPanel] relies on the [CSS Flexbox](http://dev.w3.org/csswg/css-flexbox/)
/// specification. Before using within an application verify that the feature
/// is [compatible](http://caniuse.com/flexbox) with the browsers being
/// supported.
@CustomTag(_tagName)
class FlexPanel extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Specifies the orientation of the panel.
  ///
  /// This can either be 'horizontal' or 'vertical'.
  @published String orientation = 'vertical';
  /// Whether contents should wrap around.
  @published bool wrap = false;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [FlexPanel] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(FlexPanel.customTagName);
  FlexPanel.created()
      : super.created();

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  bool get horizontal => orientation == 'horizontal';
  bool get vertical => orientation == 'vertical';

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  void ready() {
    super.ready();

    _layout();
  }

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  /// Callback for when the [orientation] changes.
  void orientationChanged(String oldValue) {
    _layout();
  }

  /// Callback for when [wrap] changes.
  void wrapChanged(bool oldValue) {
    _layout();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Setup the flexible layout.
  void _layout() {
    style.flexDirection = (vertical) ? 'column' : 'row';
    style.flexWrap = (wrap) ? 'wrap' : 'nowrap';
  }
}
