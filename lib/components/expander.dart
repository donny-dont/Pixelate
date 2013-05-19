// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:pixelate/attribute_helpers.dart';

/// Represents the control that displays a header that has a collapsible window that displays content.
class ExpanderComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The class name of the header.
  static const String _headerClass = 'x-expander_header_area';
  /// The class name of the content.
  static const String _contentClass = 'x-expander_content';
  /// The class name of the area signifying expansion.
  static const String _expandClass = 'x-expander_expand';
  /// The class name of the area signifying contraction.
  static const String _contractClass = 'x-expander_contract';
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
    _contract = host.query('.$_contractClass');

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
