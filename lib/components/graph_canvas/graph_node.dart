// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [GraphNode] class.
library pixelate_graph_node;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html' as Html;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/moveable.dart';
import 'package:pixelate/transformable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-graph-node';


@CustomTag(_tagName)
class GraphNode extends PolymerElement with Transformable, Moveable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  Html.Element _moveableElement;

  @published String header = '';

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [GraphNode] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(GraphNode.customTagName);
  GraphNode.created()
      : super.created()
  {
    // Get the moveable element
    _moveableElement = getShadowRoot(GraphNode.customTagName).querySelector('.header');

    // Setup the mixins
    initializeMoveable();
    initializeTransformable();
  }

  //---------------------------------------------------------------------
  // Moveable properties
  //---------------------------------------------------------------------

  Html.Element get moveableElement => _moveableElement;
}
