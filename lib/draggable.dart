// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Droppable] mixin.
library pixelate_draggable;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';


abstract class Draggable {
  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  String get dragdata;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initialize the behavior
  void initializeDraggable() {
    draggable = true;

    style.cursor = 'move';

    onDragStart.listen((event) {
      event.dataTransfer.setData('text/plain', dragdata);
    });
  }

  //---------------------------------------------------------------------
  // Element methods
  //---------------------------------------------------------------------

  set draggable(bool value);
  CssStyleDeclaration get style;
  ElementStream<MouseEvent> get onDragStart;
}
