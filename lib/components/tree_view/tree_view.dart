// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [TreeView] class.
library pixelate_tree_view;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/components/tree_view/tree_view_node.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-tree-view';


@CustomTag(_tagName)
class TreeView extends PolymerElement {
  /// The name of the tag.
  static String get customTagName => _tagName;

  /// The currently selected node
  ITreeViewNode selectedNode;


  /// Create an instance of the [TreeView] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(TreeView.customTagName);
  TreeView.created()
      : super.created();

  void onNodeSelected(Event e, var details, Node target) {
    var newSelectedNode = details;
    if (selectedNode != null && selectedNode != newSelectedNode) {
      // deselect the previously selected node
      selectedNode.setSelected(false, false);
    }
    selectedNode = newSelectedNode;
  }

  /// Expands all the nodes in the tree view
  void expandAll() {
    nodes.forEach((node) {
      if (node is ITreeViewNode) {
        node.expandAll();
      }
    });
  }

  /// Collapses all the nodes in the tree view
  void collapseAll() {
    nodes.forEach((node) {
      if (node is ITreeViewNode) {
        node.collapseAll();
      }
    });
  }
}
