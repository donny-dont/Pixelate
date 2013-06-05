// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:pixelate/attribute_helpers.dart';

class ButtonComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The class name of a disabled button.
  static const String _disabledClass = 'x-button_disabled';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the element is enabled.
  ///
  /// If the element is disabled it cannot be clicked.
  bool _disabled = false;
  /// The controller for the [onClick] stream.
  StreamController<MouseEvent> _onClickController;
  /// Event handler for when the button is clicked.
  Stream<MouseEvent> _onClick;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Event handler for when the button is clicked.
  Stream<MouseEvent> get onClick => _onClick;

  /// Whether the element is enabled.
  ///
  /// If the element is disabled it cannot be clicked.
  String get disabled => _disabled.toString();
  set disabled(String value) {
    _disabled = convertBoolean(value);

    if (_disabled) {
      host.classes.add(_disabledClass);
    } else {
      host.classes.remove(_disabledClass);
    }
  }

  //---------------------------------------------------------------------
  // Web-UI methods
  //---------------------------------------------------------------------

  /// Called when the component is inserted into the tree.
  ///
  /// Used to initialize the component.
  void inserted() {
    // Create the streams
    _onClickController = new StreamController<MouseEvent>();
    _onClick = _onClickController.stream;

    // Connect to the host onClick event
    host.onClick.listen(_onHostClick);////(e) { _onHostClick(e); });
  }

  /**
   * Callback for when the host element is clicked.
   *
   * Used to propagate the [onClick] callback when the button is not disabled.
   */
  void _onHostClick(MouseEvent event) {
    if ((!_disabled) && (!_onClickController.isPaused)) {
      _onClickController.add(event);
    } else {
      print('nope nope');
    }
  }
}
