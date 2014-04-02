// Copyright (c) 2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [AutoComplete] class.
library pixelate_auto_complete;

//----
// Standard libraries
//-----

import 'dart:html' as Html;

//-------------
// Package libraries
//--------

import 'package:polymer/polymer.dart';

//--
// Library Contents
//----

/// Tag name for the class.
const String _tagName = 'px-auto-complete';

/// An auto complete form control.
@CustomTag(_tagName)
class AutoComplete extends PolymerElement {
  //--
  // Class variables
  //--
  @observable String placeholderText = "Auto Complete";
  @observable ObservableList<String> suggestions = new ObservableList<String>();

  Html.Element _input;

  /// The name of the tag.
  static String get customTagName => _tagName;

  //--
  // Construction
  //--

  /// Create an instance of the [AutoComplete] class.
  ///
  /// The constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(AutoComplete.customTagName);
  AutoComplete.created()
      : super.created()
  {
    var shadowRoot = getShadowRoot(customTagName);

    _input = shadowRoot.querySelector('input');

    var listener = _input.onInput.listen(
      (event) => lookupInput(_input.value));
  }

  void lookupInput(String value) {
    print("Value is: " + value);

    suggestions.clear();
    suggestions.add("Hello");
    suggestions.add("World");
  }
}
