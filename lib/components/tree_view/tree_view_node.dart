// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [TreeViewNode] class.
library pixelate_tree_view_node;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/expandable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-tree-view-node';


@CustomTag(_tagName)
class TreeViewNode extends PolymerElement with Expandable {
  /// The name of the tag.
  static String get customTagName => _tagName;
  
  static String elementIdHost = "node_host";
  static String cssClassNodeSelected = "node_selected";
  static String cssClassNodeUnSelected = "node_unselected";

  /// The text displayed on the tree node
  @published String text = "Node";
  
  /// The Id of the tree node. This id is used when raising events
  @published String id = "node";
  
  /// The Url of the icon to be used for this node
  @published String icon = "";
  
  /// The host DOM element of the tree node 
  Element elementNode;
  
  /// This div element displays the icon as a background image
  Element elementNodeIcon;
  
  /// List of child nodes attached to this node
  List<TreeViewNode> _childNodes = new List<TreeViewNode>();
  List<TreeViewNode> get childNodes => _childNodes;
  
  /// Indicates if the node is selected
  bool _selected;
  bool get selected => _selected;
  set selected(bool value) => setSelected(value);
  
  
  /// Indicates the expanded/collapsed state of the tree node
  bool _expanded = false;
  bool get expanded => _expanded;
  set expanded(bool value) {
    var oldValue = _expanded;
    _expanded = value;
    expandedChanged(oldValue);
  } 
  
  /// The node expander views
  Element _expanderView;
  Element _expanderContent;

  /// The view of the content area.
  Element get view => _expanderView;        //TODO: Refactor view to expanderView to give context
  /// The content area to expand or contract.
  Element get content => _expanderContent;  //TODO: Refactor content to expanderContent to give context
  
  
  /// The node expander icon.  
  TreeViewNodeExpanderIcon expanderIcon;
  
  /// Create an instance of the [TreeViewNode] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(TreeViewNode.customTagName);
  TreeViewNode.created()
      : super.created()
  {
  }

  void enteredView() {
    super.enteredView();

    _expanderView = this.shadowRoot.querySelector("#children_host");
    _expanderContent = this.shadowRoot.querySelector("#expander");
    elementNode = shadowRoot.querySelector("#$elementIdHost");
    elementNode.onDoubleClick.listen(onNodeDoubleClicked);
    _childNodes = this.querySelectorAll("px-tree-view-node");
    elementNodeIcon = shadowRoot.querySelector("#node_icon");
    _updateIcon();
    
    expanderIcon = new TreeViewNodeExpanderIcon(this);
    initializeExpandable();
  }
  
  String toString() => text;
  
  void onNodeClicked(Event e) {
    selected = true;
  }
  
  void setSelected(bool value, [bool notifySelectionChanged = true]) {
    _selected = value;
    elementNode.classes.add(_selected ? cssClassNodeSelected : cssClassNodeUnSelected);
    elementNode.classes.remove(_selected ? cssClassNodeUnSelected : cssClassNodeSelected);
    
    if (notifySelectionChanged) {
      // Notify the parent 
      dispatchEvent(new CustomEvent("selectionchanged", detail: this));
    }
  }
  
  void onNodeDoubleClicked(Event e) {
    toggleExpand();
  }
  
  /// Toggles the expander state
  void toggleExpand() {
    this.toggle();  // TODO: Refactor Expandable mixing from toggle to toggleExpand to give context
  }

  void onExpand() {
    expanderIcon.update();
  }
  void onCollapse() {
    expanderIcon.update();
  }
  
  /// Expands all the child nodes 
  void expandAll() {
    expanded = true;
    _childNodes.forEach((node) => node.expandAll());
  }
  
  /// Collapses all the nodes in the tree view
  void collapseAll() {
    expanded = false;
    _childNodes.forEach((node) => node.collapseAll());
  }
  
  /// Updates the DOM to reflect the icon property
  void _updateIcon() {
    if (icon.length > 0) {
      elementNodeIcon.style.backgroundImage = "url($icon)";
    }
  }
}

class TreeViewNodeExpanderIcon {
  TreeViewNode node;
  Element elementIcon;
  static String cssNameIconExpanded = "expander_icon_expanded";
  static String cssNameIconCollapsed = "expander_icon_collapsed";
  TreeViewNodeExpanderIcon(this.node) {
    elementIcon = node.shadowRoot.querySelector("#expander_icon");
    elementIcon.onClick.listen(onClicked);
    update();
  }
  
  /// Updates the state of the DOM elements based on the expanded / collapsed state
  void update() {
    elementIcon.classes.add(node.expanded ? cssNameIconExpanded : cssNameIconCollapsed);
    elementIcon.classes.remove(node.expanded ? cssNameIconCollapsed : cssNameIconExpanded);
    
    // Hide the icon if this belongs to a leaf node
    bool visible = (node._childNodes.length > 0);
    if (visible) {
      elementIcon.classes.remove("hidden");
    } else {
      elementIcon.classes.add("hidden");
    }
  }
  
  void onClicked(Event e) {
    node.toggleExpand();
  }
}


