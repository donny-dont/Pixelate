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
import 'package:pixelate/customizable.dart';
import 'package:pixelate/expandable.dart';
import 'package:pixelate/selectable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-tree-view-node';


@CustomTag(_tagName)
class TreeViewNode extends PolymerElement with Expandable, Customizable, Selectable {
  /// The name of the tag.
  static String get customTagName => _tagName;

  static String elementIdHost = "node_host";

  /// Css class to apply on an selected element. Required by the Selectable mixin
  String get cssClassItemSelected => "node_selected";

  /// Css class to apply on an unselected element. Required by the Selectable mixin
  String get cssClassItemUnSelected => "node_unselected";

  /// The element affected by the selection state. Used by the Selectable mixin
  Element get selectionElement => elementNode;

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


  /// Indicates the expanded/collapsed state of the tree node
  bool _expanded = false;
  bool get expanded => _expanded;
  set expanded(bool value) {
    var oldValue = _expanded;
    _expanded = value;
    expandedChanged(oldValue);
  }

  /// The view for the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Element _view;
  /// The content contained in the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Element _content;

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
    // Initialize the expandable mixin
    var shadowRoot = getShadowRoot(customTagName);

    _content = shadowRoot.querySelector('.expandable');
    _view = shadowRoot.querySelector('.view');

    initializeExpandable();

    // Intitialize the customizable mixin
    initializeCustomizable();
    customizeProperty(#header, 'tree-view-header', 'default-tree-view-header');
  }

  //---------------------------------------------------------------------
  // Expandable properties
  //---------------------------------------------------------------------

  Element get content => _content;
  Element get view => _view;

  void enteredView() {
    super.enteredView();

    elementNode = shadowRoot.querySelector("#$elementIdHost");
    elementNode.onDoubleClick.listen(onNodeDoubleClicked);
    elementNodeIcon = shadowRoot.querySelector("#node_icon");
    _updateIcon();

    expanderIcon = new TreeViewNodeExpanderIcon(this);
  }

  String toString() => text;

  void onNodeClicked(Event e) {
    selected = true;
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
    nodes.forEach((node) {
      if (node is TreeViewNode) {
        node.expandAll();
      }
    });
  }

  /// Collapses all the nodes in the tree view
  void collapseAll() {
    expanded = false;
    nodes.forEach((node) {
      if (node is TreeViewNode) {
        node.collapseAll();
      }
    });
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
    bool visible = (node.nodes.length > 0);
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


