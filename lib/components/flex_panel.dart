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

  void orientationChanged(String oldValue) {
    _layout();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Setup the flexible layout.
  void _layout() {
    style.flexDirection = (vertical) ? 'column' : 'row';
  }
}
