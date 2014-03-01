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
import 'package:pixelate/selectable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-list-view-item';


@CustomTag(_tagName)
class ListViewItem extends PolymerElement with Selectable {
  /// The name of the tag.
  static String get customTagName => _tagName;
  
  String get cssClassItemSelected => "item_selected";
  String get cssClassItemUnSelected => "item_unselected";

  /// The text displayed on the list item
  @published String text = "Item";
  
  /// The Id of the list item. This id is used when raising events
  @published String id = "item";

  /// The list item's host element
  Element elementItem;

  /// The element affected by the selection state. Used by the Selectable mixin
  Element get selectionElement => elementItem;
  
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

  void enteredView() {
    super.enteredView();

    elementItem = shadowRoot.querySelector("#item_host");
  }
  
  String toString() => text;
  
  void onItemClicked(Event e) {
    selected = true;
  }
  
}


