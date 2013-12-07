// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [GridPanel] class.
library pixelate_file_drop;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/droppable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-file-drop';

@CustomTag(_tagName)
class FileDrop extends PolymerElement with Droppable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  @published String hoverclass = '';

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [GridPanel] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(GridPanel.customTagName);
  FileDrop.created()
      : super.created()
  {
    // Initialize the droppable behavior
    initializeDroppable();
  }

  //---------------------------------------------------------------------
  // Droppable methods
  //---------------------------------------------------------------------

  @override
  void drop() {
    print('Drop');
  }
}
