// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Droppable] mixin.
library pixelate_droppable;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates a behavior for a [PolymerElement] that handles dropping content.
///
/// When the custom element is created the [initializeDraggable] method needs to
/// be called. This sets up the behavior as a mixin cannot have a constructor.
///
///     class DroppableElement extends PolymerElement with Droppable {
///       DroppableElement.created()
///           : super.created()
///       {
///         initializeDroppable();
///       }
///     }
///
///
abstract class Droppable {
  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The class to apply when something has been dragged over the [PolymerElement].
  String get hoverclass;

  //---------------------------------------------------------------------
  // Element Properties
  //---------------------------------------------------------------------

  CssClassSet get classes;
  ElementStream<MouseEvent> get onDragEnter;
  ElementStream<MouseEvent> get onDragOver;
  ElementStream<MouseEvent> get onDragLeave;
  ElementStream<MouseEvent> get onDrop;
  Rectangle get offset;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  void initializeDroppable() {
    onDragEnter.listen(_onDragEnter);
    onDragOver.listen(_onDragOver);
    onDragLeave.listen(_onDragLeave);
    onDrop.listen(_onDrop);
  }

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  /// Callback for when something has entered the area through a drag.
  void dragEnter() {}

  /// Callback for when something has been dragged over ther area.
  void dragOver() {}

  /// Callback for when something has left the area through a drag.
  void dragLeave() {}

  /// Callback for when something has been dropped on the area.
  ///
  /// The values of [x] and [y] are relative to the element this is being
  /// dropped on. This can be used when the drop will cause a change to the
  /// destination element.
  void drop(DataTransfer dataTransfer, int x, int y) {}

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  void _onDragEnter(MouseEvent event) {
    _preventDefault(event);

    classes.add(hoverclass);

    dragEnter();
  }

  void _onDragOver(MouseEvent event) {
    _preventDefault(event);

    dragOver();
  }

  void _onDragLeave(MouseEvent event) {
    _preventDefault(event);

    // Remove the hover if the mouse is outside the bounds of the element
    if (!offset.containsPoint(event.client)) {
      classes.remove(hoverclass);
    }

    dragLeave();
  }

  void _onDrop(MouseEvent event) {
    _preventDefault(event);

    classes.remove(hoverclass);

    var offset = event.offset;

    drop(event.dataTransfer, offset.x, offset.y);
  }

  void _preventDefault(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
  }
}
