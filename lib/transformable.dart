// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Transformable] mixin.
library pixelate_transformable;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates a behavior for a [PolymerElement] that handles zooming and translating.
///
abstract class Transformable {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  num _zoom = 1;
  num _translateX = 0;
  num _translateY = 0;

  //---------------------------------------------------------------------
  // PolymerElement properties
  //---------------------------------------------------------------------

  CssStyleDeclaration get style;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  void initializeTransformable() {
    style.transformOrigin = 'left top 0';

    _transform();
  }

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  num get zoom => _zoom;
  set zoom(num value) {
    _zoom = value;

    _transform();
  }

  num get translateX => _translateX;
  set translateX(num value) {
    _translateX = value;

    _transform();
  }

  num get translateY => _translateY;
  set translateY(num value) {
    _translateY = value;

    _transform();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Transforms the element.
  ///
  /// Used whenever the zoom or translation is changed.
  void _transform() {
    // A 2D transformation matrix looks like
    // 0 1 2
    // 3 4 5
    style.transform = 'matrix($_zoom, 0, $_translateX, 0, _zoom, $_translateY)';
  }
}
