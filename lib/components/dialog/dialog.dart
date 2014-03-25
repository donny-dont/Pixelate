// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Dialog] class.
library pixelate_dialog;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html' as Html;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-dialog';


@CustomTag(_tagName)
class Dialog extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  Dialog.created()
      : super.created() { print('Dialog!'); }

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  void show() {
  }

  void hide() {
  }
}
