// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [RowDefinition] class.
library pixelate_row_definition;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-row-definition';

/// Defines a row within a grid.
///
/// The height of the row can be controlled through the height attribute. The
/// value can be specified in any coordinate system that the CSS Grid supports.
/// By default the row will stretch to whatever the largest child contained
/// in the row.
///
///     <!-- Unspecified row definition -->
///     <px-row-definition></px-row-definition>
///     <!-- Row that is 400px tall -->
///     <px-row-definition height="400px"></px-row-definition>
///
/// A [RowDefinition] should not contain any children, and does not have a
/// content area. Additionally the [RowDefinition] is styled to not display
/// any visual on the screen.
@CustomTag(_tagName)
class RowDefinition extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [RowDefinition] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(RowDefinition.customTagName);
  RowDefinition.created()
      : super.created();

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The height of the row.
  @published String height = 'auto';
}
