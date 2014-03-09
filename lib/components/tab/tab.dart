// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [RowDefinitions] class.
library pixelate_tab;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html' as Html;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/components/flex_panel.dart';
import 'package:pixelate/components/tab/tab_item.dart';

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
  @published String tabplacement = 'top';

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

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  @override
  void ready() {
    super.ready();

    _tabs = querySelectorAll(TabItem.customTagName);

    _positionTabs();
    _createTabs();
    _selectTab(0);
  }

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  /// Callback
  void tabplacementChanged() {
    _positionTabs();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Creates the tabs from the tab items contained in the element.
  void _createTabs() {
    var tabArea = shadowRoot.querySelector('.tabs');

    // Clear out the old tabs
    tabArea.children.clear();

    // Add the tabs
    var tabCount = _tabs.length;

    for (var i = 0; i < tabCount; ++i) {
      var tab = _tabs[i];
      var tabContent = new Html.Element.tag(FlexPanel.customTagName);

      tabContent.classes.add('tab');
      tabContent.innerHtml = tab.header;

      if (i == 0) {
        tabContent.classes.add('selected');
      }

      tabArea.children.add(tabContent);

      tabContent.onClick.listen((_) =>_selectTab(i));
    };
  }

  /// Selects the tab at the given [index].
  void _selectTab(int index) {
    var tabCount = _tabs.length;
    var tabSelectors = shadowRoot.querySelectorAll('.tab');

    for (var i = 0; i < tabCount; ++i) {
      var isSelected = i == index;
      _tabs[i].selected = isSelected;

      if (isSelected) {
        tabSelectors[i].classes.add('selected');
      } else {
        tabSelectors[i].classes.remove('selected');
      }
    }
  }

  /// Positions the tabs.
  void _positionTabs() {
    var hostDirection;
    var tabDirection;

    if (tabplacement == 'left') {
      hostDirection = 'row';
      tabDirection = 'vertical';
    } else if (tabplacement == 'right') {
      hostDirection = 'row-reverse';
      tabDirection = 'vertical';
    } else if (tabplacement == 'bottom') {
      hostDirection = 'column-reverse';
      tabDirection = 'horizontal';
    } else {
      hostDirection = 'column';
      tabDirection = 'horizontal';
    }

    style.flexDirection = hostDirection;

    var tabs = shadowRoot.querySelector('.tabs') as FlexPanel;
    tabs.orientation = tabDirection;
    tabs.classes.add(tabplacement);
  }
}
