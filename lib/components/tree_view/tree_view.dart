// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [TreeView] class.
library pixelate_list_view;
import 'package:pixelate/components/tree_view/tree_view_node.dart';

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
const String _tagName = 'px-tree-view';


@CustomTag(_tagName)
class TreeView extends PolymerElement {
  /// The name of the tag.
  static String get customTagName => _tagName;

  /// Children of root node are visible as top level entries in the tree view 
  List<TreeViewNode> _nodes;
  List<TreeViewNode> get nodes => _nodes;

  /// The currently selected node
  TreeViewNode selectedNode;
  
  
  /// Create an instance of the [TreeView] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(TreeView.customTagName);
  TreeView.created()
      : super.created()
  {
  }

  void enteredView() {
    super.enteredView();

    _nodes = querySelectorAll("px-tree-view-node");
  }
  
  void onNodeSelected(Event e, var details, Node target) {
    var newSelectedNode = details;
    if (selectedNode != null && selectedNode != newSelectedNode) {
      // deselect the previously selected node
      selectedNode.setSelected(false, false);
    }
    selectedNode = newSelectedNode;
  }

  void onExpand(Event e, var details, Node target) {
    TreeViewNode node = details;
    node.onExpand();
  }

  void onCollapse(Event e, var details, Node target) {
    TreeViewNode node = details;
    node.onCollapse();
  }
  
  /// Expands all the nodes in the tree view
  void expandAll() {
    _nodes.forEach((node) => node.expandAll());
  }
  
  /// Collapses all the nodes in the tree view
  void collapseAll() {
    _nodes.forEach((node) => node.collapseAll());
  }
}

