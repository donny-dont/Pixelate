// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Selectable] mixin.
library pixelate_selectable;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'dart:html';
import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates a behavior for a [PolymerElement] that makes it selectable with a mouse click
///
abstract class Selectable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  static const String selectionChangedEvent = 'selectionchanged';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the content area is expanded.
  bool _selected = false;
  bool get selected => _selected;
  set selected(bool value) => setSelected(value);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The CSS class to be applied on the element on selected state.
  String get selectedclass;

  /// The element that is affected by the selection state.
  Element get selectionElement;

  //---------------------------------------------------------------------
  // Element methods
  //---------------------------------------------------------------------

  bool dispatchEvent(Event event);

  //---------------------------------------------------------------------
  // Element methods
  //---------------------------------------------------------------------

  void setSelected(bool value, [bool notifySelectionChanged = true]) {
    _selected = value;

    var classes = selectionElement.classes;

    if (_selected) {
      classes.add(selectedclass);
    } else {
      classes.remove(selectedclass);
    }

    if (notifySelectionChanged) {
      // Notify the parent
      dispatchEvent(new CustomEvent(selectionChangedEvent, detail: this));
    }
  }
}
