// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [TreeViewNode] class.
library pixelate_tree_view_node;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html' as Html;

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
  Html.Element get selectionElement => elementNode;

  /// The text displayed on the tree node
  @published String header = '';

  /// The Id of the tree node. This id is used when raising events
  @published String id = "node";

  /// The host DOM element of the tree node
  Html.Element elementNode;

  /// Indicates the expanded/collapsed state of the tree node
  @published bool expanded = false;

  /// Observer for changes within the element.
  Html.MutationObserver _observer;

  /// The view for the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Html.Element _view;
  /// The content contained in the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Html.Element _content;

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

    // Observe changes to the host element.
    _observer = new Html.MutationObserver(_onMutation);
    _observer.observe(this, childList: true, subtree: true);
  }

  //---------------------------------------------------------------------
  // Expandable properties
  //---------------------------------------------------------------------

  Html.Element get content => _content;
  Html.Element get view => _view;

  @override
  void ready() {
    super.ready();
    elementNode = shadowRoot.querySelector("#$elementIdHost");
    _layoutIcon();
  }

  void onNodeClicked(Html.Event e) {
    selected = true;
  }

  void _onMutation(List<Html.MutationRecord> mutations, Html.MutationObserver observer) {
    _layoutIcon();
  }

  void _layoutIcon() {
    var icon = getShadowRoot(customTagName).querySelector('.icon');
    var childNodes = querySelectorAll(customTagName);

    if (childNodes.length > 0) {
      icon.style.visibility = 'visible';
    } else {
      icon.style.visibility = 'hidden';
    }
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
}
