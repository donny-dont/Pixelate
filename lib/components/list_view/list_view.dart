// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ListView] class.
library pixelate_list_view;
import 'package:pixelate/components/list_view/list_view_item.dart';

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
const String _tagName = 'px-list-view';


@CustomTag(_tagName)
class ListView extends PolymerElement {
  /// The name of the tag.
  static String get customTagName => _tagName;

  /// List if items managed by the list view
  List<ListViewItem> _items;
  List<ListViewItem> get items => _items;
  
  /// Create an instance of the [ListView] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(ListView.customTagName);
  ListView.created()
      : super.created()
  {
  }

  void enteredView() {
    super.enteredView();

    _items = querySelectorAll("px-list-view-item");  // TODO: optimize/cache
  }
  
  void addItem(ListViewItem item) {
    _items.add(item);
  }
  
  void removeItem(ListViewItem item) {
    _items.remove(item);
  }
  
  void onItemSelected(Event e, var details, Node target) {
    ListViewItem selectedItem = details;
    
    for (ListViewItem item in items) {
      // deselect everything else
      if (selectedItem != item) {
        item.setSelected(false, false);
      }
    }
  }
}

