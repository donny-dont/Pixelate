// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [TabItem] class.
library pixelate_tab_item;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/customizable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-tab-item';

/// Defines the rows contained within a grid.
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
class TabItem extends PolymerElement with Customizable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  @published String header = '';
  @published bool selected = false;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [TabItem] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(RowDefinitions.customTagName);
  TabItem.created()
      : super.created()
  {
    initializeCustomizable();
    customizeProperty(#header, 'tab-item-header', 'default-tab-item-header');
  }

  @override
  void ready() {
    super.ready();

    selectedChanged();
  }

  void selectedChanged() {
    style.display = (selected) ? 'block' : 'none';
  }
}
