// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Expandable] mixin.
library pixelate_expandable;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'dart:html';
import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates a behavior for a [PolymerElement] that has an expanable area within.
///
/// When setting up the [PolymerElement] there needs to be a view over the
/// content. This is done to ensure that the content has a queryable height.
///
///     <polymer-element name="px-example">
///       <!-- The area whose dimensions are modified -->
///       <div id="view">
///         <!-- Container for the user defined content -->
///         <div id="content">
///           <content></content>
///         </div>
///       </div>
///     </polymer-element>
abstract class Expandable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  static const String expandedEvent = 'expanded';
  static const String collapsedEvent = 'collapsed';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the content area is expanded.
  @published bool expanded = false;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The view of the content area.
  Element get view;
  /// The content area to expand or contract.
  Element get content;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  void initializeExpandable() {
    view.style.overflow = 'hidden';

    if (!expanded) {
      _collapse();
    }
  }

  //---------------------------------------------------------------------
  // Element methods
  //---------------------------------------------------------------------

  bool dispatchEvent(Event event);

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  /// Callback for when the [expanded] value changes.
  void expandedChanged(bool oldValue) {
    var eventType;

    if (expanded) {
      eventType = expandedEvent;

      _expand();
    } else {
      eventType = collapsedEvent;

      _collapse();
    }

    dispatchEvent(new CustomEvent(eventType, detail: this));
  }

  /// Expands the element.
  void _expand() {
    view.style.maxHeight = '${content.clientHeight}px';
  }

  /// Collapses the element.
  void _collapse() {
    view.style.maxHeight = '0px';
  }

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  /// Toggles the expansion of the element.
  void toggle() {
    expanded = !expanded;
  }
}
