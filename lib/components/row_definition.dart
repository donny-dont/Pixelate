// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library row_definition;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'row-definition';

/// Defines a row within a grid.
///
/// The height of the row can be controlled through the height attribute. The
/// value can be specified in any coordinate system that the CSS Grid supports.
/// By default the row will stretch to whatever the largest child contained
/// in the row.
///
///     <!-- Unspecified row definition -->
///     <row-definition></row-definition>
///     <!-- Row that is 400px tall -->
///     <row-definition height="400px"></row-definition>
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
  // Properties
  //---------------------------------------------------------------------

  /// The height of the row.
  @observable String height = 'auto';
}
