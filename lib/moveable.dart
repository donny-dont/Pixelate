// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Moveable] mixin.
library pixelate_moveable;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:html' as Html;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:pixelate/transformable.dart';

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
abstract class Moveable {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the element is being moved.
  bool _isMoving = false;
  int _lastX = 0;
  int _lastY = 0;
  StreamSubscription<Html.MouseEvent> _mouseUpSubscription;
  StreamSubscription<Html.MouseEvent> _mouseMoveSubscription;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The element that is used to move the element.
  Html.Element get moveableElement;

  //---------------------------------------------------------------------
  // Element properties
  //---------------------------------------------------------------------

  Html.CssStyleDeclaration get style;

  //---------------------------------------------------------------------
  // Transformable properties
  //---------------------------------------------------------------------

  num get zoom;
  num get translateX;
  set translateX(num value);
  num get translateY;
  set translateY(num value);

  Html.Element get parent;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  void initializeMoveable() {
    // Style the element's pointer
    moveableElement.style.cursor = 'move';

    // Element will move around with an absolute positioning
    style.position = 'absolute';

    // Hook into the events
    moveableElement.onMouseDown.listen(_onMoveBegin);

    _mouseUpSubscription = Html.window.onMouseUp.listen(_onMoveEnd);
    _mouseUpSubscription.pause();

    _mouseMoveSubscription = Html.window.onMouseMove.listen(_onMove);
    _mouseMoveSubscription.pause();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  void _onMoveBegin(Html.MouseEvent event) {
    var startPoint = event.screen;

    _lastX = startPoint.x;
    _lastY = startPoint.y;
    _isMoving = true;

    _mouseUpSubscription.resume();
    _mouseMoveSubscription.resume();
  }

  void _onMoveEnd(Html.MouseEvent event) {
    _isMoving = false;

    _mouseUpSubscription.pause();
    _mouseMoveSubscription.pause();
  }

  void _onMove(Html.MouseEvent event) {
    if (!_isMoving) return;

    var zoomLevel = 1.0;
    var parentNode = parent;

    while ((parentNode != null) && (parentNode is Transformable)) {
      var transformable = parentNode as Transformable;
      zoomLevel *= transformable.zoom;

      parentNode = parentNode.parent;
    }

    var mousePoint = event.screen;
    var mouseX = mousePoint.x;
    var mouseY = mousePoint.y;
    var invZoomLevel = 1.0 / zoomLevel;

    translateX += (mouseX - _lastX) * invZoomLevel;
    translateY += (mouseY - _lastY) * invZoomLevel;

    _lastX = mouseX;
    _lastY = mouseY;
  }
}
