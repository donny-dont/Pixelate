// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ListViewItem] class.
library pixelate_list_view_item;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-list-view-item';


@CustomTag(_tagName)
class ListViewItem extends PolymerElement {
  /// The name of the tag.
  static String get customTagName => _tagName;

  /// The text displayed on the list item
  @published String title = "Item";
  
  /// Create an instance of the [ListViewItem] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(ListViewItem.customTagName);
  ListViewItem.created()
      : super.created()
  {
  }
  
  
}
