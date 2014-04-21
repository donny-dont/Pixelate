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
import 'package:pixelate/components/list_view/list_view_item.dart';
import 'package:pixelate/selectable.dart';

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
  String highlightClass = "highlighted";

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
      : super.created();
  
  @override void ready() {
    var shadowRoot = getShadowRoot(customTagName);
        
    // Look for AutoCompleteSource attatched to this object
    for (var child in children) {
      if (child is AutoCompleteSource) {
        _source = child;
      }
    }
    
    // Return if we cannot find a source
    if (_source == null) {
      print("WARNING: No source found for px-auto-complete");
      return;
    }
    
    // Listen for selection events on the list view
    _list = shadowRoot.querySelector("px-list-view") as ListView;
    _list.on[Selectable.selectionChangedEvent].listen((event) {
      if (_list.selectedItem != null) {
        handleSelection(_list.selectedItem.selectionElement);
      }
    });
    
    _list.onMouseOver.listen((event) {
      if(event.target is ListViewItem) {
        _list.querySelectorAll("px-list-view-item.${highlightClass}").forEach((el) {
          el.classes.remove(highlightClass);
        });
        
        (event.target as Html.Element).classes.add(highlightClass);
      }
    });
    
    _input = shadowRoot.querySelector('input');

    var listener = _input.onInput.listen((event) {
      String value = _input.value;
      
      if (value.isNotEmpty) {
        lookupInput(_input.value); 
      } else {
        close();
      }
    });
    
    var keyListener = _input.onKeyDown.listen((event) {
      Selectable selected = _list.querySelector("px-list-view-item.${highlightClass}") as Selectable;
      var itemIndex = _list.selectableItems.indexOf(selected);
      
      if (event.keyCode == Html.KeyCode.DOWN) {
        if (itemIndex + 1 < _list.selectableItems.length) {
          if (itemIndex != -1) selected.selectionElement.classes.remove(highlightClass);
          itemIndex += 1;
          _list.selectableItems[itemIndex].selectionElement.classes.add(highlightClass);
          event.preventDefault();
        }
      } else if (event.keyCode == Html.KeyCode.UP) {
        if (itemIndex - 1 >= 0) {
          if (itemIndex != -1) selected.selectionElement.classes.remove(highlightClass);
          itemIndex -= 1;
          _list.selectableItems[itemIndex].selectionElement.classes.add(highlightClass);
          event.preventDefault();
        }
      } else if (event.keyCode == Html.KeyCode.ENTER) {
        if (itemIndex != -1) {
          _list.selectedItem = selected;
          event.preventDefault();
        }
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
