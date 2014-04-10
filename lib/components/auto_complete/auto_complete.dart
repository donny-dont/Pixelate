// Copyright (c) 2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [AutoComplete] class.
library pixelate_auto_complete;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html' as Html;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/components/auto_complete/auto_complete_source.dart';
import 'package:pixelate/components/list_view/list_view.dart';

//---------------------------------------------------------------------
// Library Contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-auto-complete';

/// An auto complete form control.
@CustomTag(_tagName)
class AutoComplete extends PolymerElement {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------
  @observable String placeholderText = "Auto Complete";
  @observable ObservableList<String> suggestions = new ObservableList<String>();

  Html.InputElement _input;
  ListView _list;
  AutoCompleteSource _source;

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [AutoComplete] class.
  ///
  /// The constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(AutoComplete.customTagName);
  AutoComplete.created()
      : super.created()
  {
    
  }
  
  void ready() {
    var shadowRoot = getShadowRoot(customTagName);
        
    // Look for AutoCompleteSource attatched to this object
    for(Html.Element child in children) {
      if (child is AutoCompleteSource) {
        _source = child;
      }
    }
    
    // Return if we cannot find a source
    if(_source == null) {
      print("WARNING: No source found for px-auto-complete");
      return;
    }
    
    // Listen for selection events on the list view
    _list = shadowRoot.querySelector("px-list-view") as ListView;
    _list.addEventListener("selectionchanged", (event) {
      handleSelection(_list.selectedItem.selectionElement);
    });
    
    _input = shadowRoot.querySelector('input');

    var listener = _input.onInput.listen((event) {
      String value = _input.value;
      
      if(value != "") {
        lookupInput(_input.value); 
      } else {
        close();
      }
    });
  }
  
  void close() {
    suggestions.clear();
  }
  
  void handleSelection(Html.Element selectedElement) {
    _input.value = selectedElement.text;
    close();
  }

  void lookupInput(String value) {
    value = value.toLowerCase();
    
    // Find union of the two lists
    close();
    suggestions.addAll(_source.data.where((String term) {
      return term.toLowerCase().startsWith(value);
    }));
  }
}
