// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ScrollViewer] class.
library pixelate_scroll_viewer;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-scroll-viewer';

/// Defines an area that can be scrolled.
///
/// The scrollbar values [horizontal] and [vertical] can be set to one of the
/// following values to control how the individual scrollbars are displayed by
/// the component.
///
/// * visible - the scroll bar is always present.
/// * hidden - the scroll bar is hidden; scrolling will be controlled manually.
/// * auto - the scroll bar is only visible when needed.
///
/// The rows are defined in the order they are inserted into the
/// [RowDefinitions] element.
///
///     <!-- The row definitions -->
///     <px-row-definitions>
///       <!-- The first row (value of 0) -->
///       <px-row-definition></px-row-definition>
///       <!-- The second row (value of 1) -->
///       <px-row-definition></px-row-definition>
///     </px-row-definitions>
///
/// All rows used within the [GridPanel] are required to be defined within the
/// [RowDefinitions].
@CustomTag(_tagName)
class ScrollViewer extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// How the horizontal scrollbar should be displayed.
  @published String horizontal = 'auto';
  /// How the vertical scrollbar should be displayed.
  @published String vertical = 'auto';

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [ScrollViewer] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(ScrollViewer.customTagName);
  ScrollViewer.created()
      : super.created();

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  @override
  void ready() {
    super.ready();

    _updateScrollbars();
  }

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  /// Callback for when the value of [horizontal] changes.
  void horizontalChanged() {
    _updateScrollbars();
  }

  /// Callback for when the value of [vertical] changes.
  void verticalChanged() {
    _updateScrollbars();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Updates the styling for the scrollbars
  void _updateScrollbars() {
    style.overflowX = _convertToOverflowValue(horizontal);
    style.overflowY = _convertToOverflowValue(vertical);
  }

  /// Converts the value of [scrollbar] to a valid CSS overflow value.
  static String _convertToOverflowValue(String scrollbar) {
    if (scrollbar == 'visible') {
      return 'scroll';
    } else if (scrollbar == 'hidden') {
      return 'hidden';
    } else {
      return 'auto';
    }
  }
}
