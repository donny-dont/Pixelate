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
@MirrorsUsed(targets: const ['pixelate_expandable.Expandable.toggle', 'pixelate_expandable.Expandable.expandedChanged'])
import 'dart:mirrors';

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
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The view for the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Html.Element _view;
  /// The content contained in the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Html.Element _content;
  /// The element that is affected by the selection state.
  Html.Element _selectionElement;
  /// Observer for changes within the element.
  Html.MutationObserver _observer;

  /// The text displayed on the tree node
  @published String header = '';
  /// Indicates the expanded/collapsed state of the tree node
  @published bool expanded = false;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

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
    _selectionElement = shadowRoot.querySelector('.header');

    initializeExpandable();

    // Intitialize the customizable mixin
    initializeCustomizable();
    customizeProperty(#header, 'tree-view-header', 'default-tree-view-header');

    // Observe changes to the host element.
    _observer = new Html.MutationObserver(_onMutation);
    _observer.observe(this, childList: true, subtree: true);
  }

  //---------------------------------------------------------------------
  // Selectable properties
  //---------------------------------------------------------------------

  String get selectedclass => "selected";
  Html.Element get selectionElement => _selectionElement;

  //---------------------------------------------------------------------
  // Expandable properties
  //---------------------------------------------------------------------

  Html.Element get content => _content;
  Html.Element get view => _view;

  //---------------------------------------------------------------------
  // PolymerElement properties
  //---------------------------------------------------------------------

  @override
  void ready() {
    super.ready();

    _layoutIcon();
  }

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  void selection(Html.Event e) {
    selected = !selected;
  }

  void _onMutation(List<Html.MutationRecord> mutations, Html.MutationObserver observer) {
    _layoutIcon();
  }

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

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

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Determines if the icon should be displayed.
  void _layoutIcon() {
    var icon = getShadowRoot(customTagName).querySelector('.icon');
    var childNodes = querySelectorAll(customTagName);

    icon.style.visibility = (childNodes.length > 0) ? 'visible' : 'hidden';
  }
}
