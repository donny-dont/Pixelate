// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Tooltip] class.
library pixelate_tooltip;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-tooltip';

/// A control that creates a pop-up element to display information for an element.
@CustomTag(_tagName)
class Tooltip extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  @published String text = '';
  @published String placement = 'top';

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [Tooltip] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(Tooltip.customTagName);
  Tooltip.created()
      : super.created();

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  @override
  void ready() {
    super.ready();

    _positionText();
  }

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  /// Callback for when the tab placement has changed.
  void placementChanged() {
    _positionText();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Positions the tooltip using the given placement
  void _positionText() {
    if (placement == 'top'    ||
        placement == 'bottom' ||
        placement == 'left'   ||
        placement == 'right') {
      this.classes.add(placement);
    } else {
      this.classes.add('top');
    }
  }
}
