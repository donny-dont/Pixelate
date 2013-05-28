// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:pixelate/attribute_helpers.dart';

/// Represents a control that displays a header that has a collapsible window that displays content.
///
/// The expansion/collapse of an element can be controlled in markup by using
/// the expanded attribute, which takes a boolean string value. By default the
/// control is collapsed.
///
///     <!-- Collapsed content; the default -->
///     <div is="x-expander" expanded="false"></div>
///     <!-- Expanded content -->
///     <div is="x-expander" expanded="true"></div>
///
/// The [ExpanderComponent]'s content can be toggled on/off by clicking on the
/// header area. To prevent this from happening the disabled attribute can be
/// used.
///
///     <!-- Toggleable content; the default -->
///     <div is="x-expander" disabled="false"></div>
///     <!-- Fixed content -->
///     <div is="x-expander" disabled="true"></div>
///
/// The [ExpanderComponent] defines the following psuedo classes.
///
///     /* The header area which contains the clickable area for expanding and collapsing */
///     div[is=x-expander]::x-header { }
///     /* An area reserved for a visual indicator for whether the area is collapsed or expanded */
///     div[is=x-expander]::x-icon { }
///     /* An area within x-icon that is shown when the item can be collapsed  */
///     div[is=x-expander]::x-collapse-icon { }
///     /* An area within x-icon that is shown when the item can be expanded  */
///     div[is=x-expander]::x-expand-icon { }
///
/// The [ExpanderComponent] defines styles for the header colors, and the
/// transitions between them. Additionally the animation for the expansion of
/// the content can be styled.
///
///     div[is=x-expander] {
///       /* The default header color */
///       -webkit-var-expander-header-color: ___;
///       /* The header color used when the cursor is hovering over the area */
///       -webkit-var-expander-header-hover-color: ___;
///       /* The header color used when the cursor is being depressed */
///       -webkit-var-expander-header-active-color: ___;
///       /* The header color for when the element is selected (in an expanded state) */
///       -webkit-var-expander-header-selected-color: ___;
///       /* The transition function used when transitioning the header color */
///       -webkit-var-expander-color-transition-timing-function: ___;
///       /* The time it takes to transition between colors within the header */
///       -webkit-var-expander-color-transition-duration: ___;
///       /* The transition function used when the height of the content area is changed */
///       -webkit-var-expander-size-transition-timing-function: ___;
///       /* The time it takes to expand/collapse the content area */
///       -webkit-var-expander-size-transition-duration: ___;
///     }
class ExpanderComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The class name of the header.
  static const String _headerClass = 'x-expander_header-area';
  /// The class name of the content.
  static const String _contentClass = 'x-expander_content';
  /// The class name of the area when expanded.
  static const String _expandClass = 'x-expander_expand';
  /// The class name of the area when collapsed.
  static const String _collapseClass = 'x-expander_collapse';
  /// The class name for header selection.
  static const String _selectedClass = 'x-expander_selected';
  /// The class name to hide the content.
  static const String _hideClass = 'x-expander_hide';
  /// The class name to display no content.
  static const String _displayNoneClass = 'x-expander_display_none';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The header element.
  Element _header;
  /// The content element.
  Element _content;
  /// The icon for expanding the area.
  Element _expand;
  /// The icon for contracting the area.
  Element _contract;
  /// Whether the element is enabled.
  ///
  /// If the element is disabled it cannot be expanded or collapsed by
  /// by interacting with the header.
  bool _disabled = false;
  /// Whether the elemnt is expanded.
  ///
  /// When expanded the content is displayed.
  bool _expanded = true;
  /// Subscription to the onClick stream for the header.
  StreamSubscription _clickListener;
  /// The controller for the [onCollapsed] stream.
  StreamController<CustomEvent> _onCollapsedController;
  /// Event handler for when the content area is collapsed.
  Stream<CustomEvent> _onCollapsed;
  /// The controller for the [onExpanded] stream.
  StreamController<CustomEvent> _onExpandedController;
  /// Event handler for when the content area is expanded.
  Stream<CustomEvent> _onExpanded;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the element is enabled.
  ///
  /// If the element is disabled it cannot be expanded or collapsed by
  /// by interacting with the header.
  String get disabled => _disabled.toString();
  set disabled(String value) { _disabled = convertBoolean(value); }

  /// Whether the elemnt is expanded.
  ///
  /// When expanded the content is displayed.
  String get expanded => _expanded.toString();
  set expanded(String valueString) {
    bool value = convertBoolean(valueString);

    // Attributes are added before inserted() is called.
    // Ensure that _hide/_show are not called before this point.
    if (_header == null) {
      _expanded = value;
      return;
    }

    if (value != _expanded) {
      if (value) {
        _show();
      } else {
        _hide();
      }
    }
  }

  /// Event handler for when the content area is collapsed.
  Stream<CustomEvent> get onCollapsed => _onCollapsed;

  /// Event handler for when the content area is expanded.
  Stream<CustomEvent> get onExpanded => _onExpanded;

  //---------------------------------------------------------------------
  // Web-UI methods
  //---------------------------------------------------------------------

  /// Called when the component is inserted into the tree.
  ///
  /// Used to initialize the component.
  void inserted() {
    // Get the child elements
    _header   = host.query('.$_headerClass');
    _content  = host.query('.$_contentClass');
    _expand   = host.query('.$_expandClass');
    _contract = host.query('.$_collapseClass');

    // Create the streams
    _onCollapsedController = new StreamController<CustomEvent>();
    _onCollapsed = _onCollapsedController.stream;

    _onExpandedController = new StreamController<CustomEvent>();
    _onExpanded = _onExpandedController.stream;

    // Set the maximum height
    // This is to enable animations
    int maxHeight = _content.clientHeight;
    _content.style.maxHeight = '${maxHeight}px';

    if (_expanded) {
      _show();
    } else {
      _hide();
    }

    _clickListener = _header.onClick.listen((_) {
      if (!_disabled) {
        _toggle();
      }
    });
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Shows the content.
  void _show() {
    _header.classes.add(_selectedClass);
    _content.classes.remove(_hideClass);

    _expand.classes.add(_displayNoneClass);
    _contract.classes.remove(_displayNoneClass);

    _expanded = true;

    if (!_onExpandedController.isPaused) {
      _onExpandedController.add(new CustomEvent('expand', detail : this));
    }
  }

  /// Hides the content.
  void _hide() {
    _header.classes.remove(_selectedClass);
    _content.classes.add(_hideClass);

    _expand.classes.remove(_displayNoneClass);
    _contract.classes.add(_displayNoneClass);

    _expanded = false;

    if (!_onCollapsedController.isPaused) {
      _onCollapsedController.add(new CustomEvent('collapse', detail : this));
    }
  }

  /// Toggles whether the content is visible.
  void _toggle() {
    if (_expanded) {
      _hide();
    } else {
      _show();
    }
  }
}
