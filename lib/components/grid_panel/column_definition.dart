// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ColumnDefinition] class.
library pixelate_column_definition;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-column-definition';

/// Defines a column within a grid.
///
/// The width of the column can be controlled through the width attribute. The
/// value can be specified in any coordinate system that the CSS Grid supports.
/// By default the column will stretch to whatever the largest child contained
/// in the column.
///
///     <!-- Unspecified column definition -->
///     <px-column-definition></px-column-definition>
///     <!-- Column that is 400px wide -->
///     <px-column-definition width="400px"></px-column-definition>
///
/// A [ColumnDefinition] should not contain any children, and does not have a
/// content area. Additionally the [ColumnDefinition] is styled to not display
/// any visual on the screen.
@CustomTag(_tagName)
class ColumnDefinition extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  ColumnDefinition.created()
      : super.created();

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The width of the column.
  @published String width = 'auto';
}
