// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:pixelate/attribute_helpers.dart';

/// The base class for all button controls.
class ButtonBaseComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The class name of a disabled button.
  static const String _disabledClass = 'x-button-base_disabled';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the element is enabled.
  ///
  /// If the element is disabled it cannot be clicked.
  bool _disabled = false;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

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
}
