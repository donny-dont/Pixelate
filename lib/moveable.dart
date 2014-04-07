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

/// Creates a behavior for a [PolymerElement] that handles moveable content.
///
/// The [Moveable] mixin allows the user to reposition an element within the
/// layout by selecting it and moving it to a new position on the screen.
///
/// When the custom element is created the [initializeMoveable] method needs to
/// be called. This sets up the behavior as a mixin cannot have a constructor.
/// Additionally a moveable element should be used in conjunction with the
/// [Transformable] mixin which handles 2D transformations.
///
///     class MoveableElement extends PolymerElement with Moveable, Transformable {
///       DroppableElement.created()
///           : super.created()
///       {
///         initializeTransformable();
///         initializeMoveable();
///       }
///     }
abstract class Moveable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  static const String movedEvent = 'moved';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the element is being moved.
  bool _isMoving = false;
  /// The last x position of the element.
  int _lastX = 0;
  /// The last y position of the element.
  int _lastY = 0;
  /// A subscription to mouse up events.
  StreamSubscription<Html.MouseEvent> _mouseUpSubscription;
  /// A subscription to mouse move events.
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
  bool dispatchEvent(Html.Event event);

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

    // Notify that the element was moved
    dispatchEvent(new Html.CustomEvent(movedEvent, detail: this));
  }
}
