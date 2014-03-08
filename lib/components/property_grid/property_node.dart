// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [PropertyNode] class.
library pixelate_property_node;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html' as Html;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/customizable.dart';
import 'package:pixelate/expandable.dart';
import 'package:pixelate/selectable.dart';
import 'package:pixelate/components/tree_view/tree_view_node.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-property-node';


@CustomTag(_tagName)
class PropertyNode extends TreeViewNode with Expandable, Customizable, Selectable {
  /// The name of the tag.
  static String get customTagName => _tagName;
  
  /// Create an instance of the [PropertyNode] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(PropertyNode.customTagName);
  PropertyNode.created()
      : super.created()
  {
  }

  void enteredView() {
    super.enteredView();
  }
  
}
