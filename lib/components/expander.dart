// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Expander] class.
library pixelate_expander;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/expandable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-expander';

@CustomTag(_tagName)
class Expander extends PolymerElement with Expandable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  Element _view;
  Element _content;
  @published String header;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  Expander.created()
      : super.created()
  {
    var shadowRoot = getShadowRoot(customTagName);

    _content = shadowRoot.querySelector('#expandable');
    _view = shadowRoot.querySelector('#view');

    initializeExpandable();
  }

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  //---------------------------------------------------------------------
  // Expandable properties
  //---------------------------------------------------------------------

  Element get content => _content;
  Element get view => _view;

  void toggle() {
    expanded = !expanded;
  }
}
