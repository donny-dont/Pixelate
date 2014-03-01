// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [RowDefinitions] class.
library pixelate_tab;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/components/tab_item.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-tab';

@CustomTag(_tagName)
class Tab extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;
  /// The class for a hidden tab.
  static const String hiddenClass = 'hidden';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  List<TabItem> _tabs;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [TabItem] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(RowDefinitions.customTagName);
  Tab.created()
      : super.created();

  void ready() {
    super.ready();

    _tabs = querySelectorAll(TabItem.customTagName);

    _selectTab(0);
  }

  void _selectTab(int index) {
    var tabCount = _tabs.length;

    for (var i = 0; i < tabCount; ++i) {
      var tabClasses = _tabs[i].classes;

      if (i == index) {
        tabClasses.remove(hiddenClass);
      } else {
        tabClasses.add(hiddenClass);
      }
    }
  }
}
