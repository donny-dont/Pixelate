// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Expandable] mixin.
library pixelate_expandable;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:html' as Html;

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

  /// Whether the expandable item is using a transition to animate.
  ///
  /// This is used internally to determine whether to set the max height
  /// or the visibility property on the view.
  bool _hasHeightTransition = false;
  /// Subscription to the [onTransitionEnd] event stream.
  StreamSubscription<Html.TransitionEvent> _transitionEndSubscription;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the content area is expanded.
  bool get expanded;
  set expanded(bool value);

  /// The view of the content area.
  Html.Element get view;
  /// The content area to expand or contract.
  Html.Element get content;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  void initializeExpandable() {
    view.style.overflow = 'hidden';

    // Connect to the transition event
    _transitionEndSubscription = onTransitionEnd.listen(_onTransitionEnd);
    _transitionEndSubscription.pause();

    // Determine if the height will be transitioned
    _checkForTransition();

    if (!expanded) {
      _collapse();
    }
  }

  //---------------------------------------------------------------------
  // Element methods
  //---------------------------------------------------------------------

  bool dispatchEvent(Html.Event event);
  Html.ElementStream<Html.TransitionEvent> get onTransitionEnd;

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

    dispatchEvent(new Html.CustomEvent(eventType, detail: this));
  }

  /// Callback for when a transition ends.
  ///
  /// Used to check the modify the max-height attribute when the animation ends
  /// to ensure the element can stretch further.
  void _onTransitionEnd(Html.TransitionEvent transition) {
    if (transition.propertyName == 'max-height') {
      if (expanded) {
        view.style.maxHeight = '';
      }
    }
  }

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  /// Toggles the expansion of the element.
  void toggle() {
    expanded = !expanded;
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Expands the element.
  void _expand() {
    var style = view.style;

    // Determine if the height will be transitioned
    // This is in case any styles have changed on the element
    _checkForTransition();

    if (_hasHeightTransition) {
      style.maxHeight = '${content.clientHeight}px';
    } else {
      style.display = '';
    }
  }

  /// Collapses the element.
  void _collapse() {
    var style = view.style;

    if (_hasHeightTransition) {
      // This is a hack to ensure that the max-height attribute is animated.

      // First set the max-height attribute to the client's height
      style.maxHeight = '${content.clientHeight}px';

      // Force a recompute of the height
      content.clientHeight;

      // Then set the max height to 0
      style.maxHeight = '0px';
    } else {
      style.display = 'none';
    }
  }

  /// Check for a height transition within the component.
  void _checkForTransition() {
    var computedStyle = view.getComputedStyle();
    var hasTransition = computedStyle.transitionProperty.indexOf('max-height') != -1;

    // See if the transition has changed
    if (hasTransition != _hasHeightTransition) {
      if (hasTransition) {
        // The method only gets called when expanding
        // If there is no transition then display: none is used to hide the
        // element. This makes it so the element properly transitions.
        if (expanded) {
          var style = view.style;

          style.maxHeight = '0px';
          style.display = '';
        }

        _transitionEndSubscription.resume();
      } else {
        _transitionEndSubscription.pause();
      }

      _hasHeightTransition = hasTransition;
    }
  }
}
