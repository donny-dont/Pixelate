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
import 'package:pixelate/components/auto_complete/auto_complete_source.dart';

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

  Html.InputElement _input;
  AutoCompleteSource _source;

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
    
    // Look for data source attatched to this object
    _source = this.querySelector("px-auto-complete-source") as AutoCompleteSource;
    
    if(_source == null) {
      print("WARNING: No source found for px-auto-complete");
      return;
    }
    
    _input = shadowRoot.querySelector('input');

    var listener = _input.onInput.listen((event) {
      String value = _input.value;
      
      if(value != "") {
        lookupInput(_input.value); 
      } else {
        suggestions.clear();
      }
    });
  }

  void lookupInput(String value) {
    value = value.toLowerCase();
    
    // Find union of the two lists
    suggestions.clear();
    suggestions.addAll(_source.data.where((String term) {
      return term.toLowerCase().startsWith(value);
    }));
  }
}
