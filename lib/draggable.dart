// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Droppable] mixin.
library pixelate_draggable;

import 'dart:html';

abstract class Draggable {

  String get dragdata;
  set draggable(bool value);

  ElementStream<MouseEvent> get onDragStart;

  /// Initialize the behavior
  void initializeDraggable() {
    draggable = true;

    onDragStart.listen((event) {
      event.dataTransfer.setData('text/plain', dragdata);
    });
  }
}
