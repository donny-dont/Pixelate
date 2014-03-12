// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Transformable] mixin.
library pixelate_transformable;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'dart:html' as Html;

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

  Html.CssStyleDeclaration get style;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  ///
  /// Use [promoteLayer] to force the element to its own compositing layer in
  /// WebKit based browsers. While this will help paint times within the
  /// browser it will result in blurring of the element's contents when zoomed
  /// in.
  void initializeTransformable([bool promoteLayer = false]) {
    // Set the origin to the upper left corner
    style.transformOrigin = 'left top 0';

    // In webkit browsers a 2D transform will not promote the element to its
    // own compositor layer. To force this the backface-visibility attribute
    // is set to hidden.
    //
    // \TODO Replace with will-change when landed.
    if (promoteLayer) {
      style.backfaceVisibility = 'hidden';
    }

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
    // 0 2 4
    // 1 3 5
    style.transform = 'matrix($_zoom, 0, 0, $_zoom, $_translateX, $_translateY)';
  }
}
