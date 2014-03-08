// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [PropertyGrid] class.
library pixelate_property_grid;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/components/tree_view/tree_view.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-property-grid';


@CustomTag(_tagName)
class PropertyGrid extends PolymerElement {
  /// The name of the tag.
  static String get customTagName => _tagName;

  /// The tree view for displaying the property elements
  TreeView _treeView;


  /// Create an instance of the [PropertyGrid] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(PropertyGrid.customTagName);
  PropertyGrid.created()
      : super.created();


  void enteredView() {
    super.enteredView();
    _treeView = querySelector(TreeView.customTagName);
  }

  void onNodeSelected(Event e, var details, Node target) {
    if (_treeView != null) {
      _treeView.onNodeSelected(e, details, target);
    }
  }
}
