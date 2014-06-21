// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [TreeView] class.
library pixelate_tree_view;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/selection_group.dart';
import 'package:pixelate/components/tree_view/tree_view_node.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-tree-view';


@CustomTag(_tagName)
class TreeView extends PolymerElement with SelectionGroup {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [TreeView] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(TreeView.customTagName);
  TreeView.created()
      : super.created()
  {
    initializeSelectionGroup();
  }

  //---------------------------------------------------------------------
  // SelectionGroup properties
  //---------------------------------------------------------------------

  @published bool multiple = false;
  String get selectableSelectors => TreeViewNode.customTagName;

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  /// Expands all the nodes in the tree view.
  void expandAll() {
    nodes.forEach((node) {
      if (node is TreeViewNode) {
        node.expandAll();
      }
    });
  }

  /// Collapses all the nodes in the tree view.
  void collapseAll() {
    nodes.forEach((node) {
      if (node is TreeViewNode) {
        node.collapseAll();
      }
    });
  }
}
