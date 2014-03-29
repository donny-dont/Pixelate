// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ListView] class.
library pixelate_list_view;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/selection_group.dart';
import 'package:pixelate/components/list_view/list_view_item.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-list-view';


@CustomTag(_tagName)
class ListView extends PolymerElement with SelectionGroup {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [ListView] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(ListView.customTagName);
  ListView.created()
      : super.created()
  {
    initializeSelectionGroup();
  }

  //---------------------------------------------------------------------
  // SelectionGroup properties
  //---------------------------------------------------------------------

  @published bool multiple = false;
  String get selectableSelectors => ListViewItem.customTagName;
}
