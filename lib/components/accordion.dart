// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:web_ui/web_ui.dart';
import 'package:pixelate/selection_mode.dart';
import 'expander.dart';

/// A modal dialog host.
class AccordionComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  static const String _expanderClass = 'div[is=x-expander]';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  int _mode = SelectionMode.Single;

  String get mode => SelectionMode.stringify(_mode);
  set mode(String value) {

  }

  //---------------------------------------------------------------------
  // Web-UI methods
  //---------------------------------------------------------------------

  /// Called when the component is inserted into the tree.
  ///
  /// Used to initialize the component.
  void inserted() {
    var expanders = host.queryAll(_expanderClass);

    expanders.forEach((element) {
      var expander = element.xtag as ExpanderComponent;

      expander.onExpanded.listen((e) {
        _onExpanded(expander);
      });
    });
  }

  void _onExpanded(ExpanderComponent expander) {
    if (_mode == SelectionMode.Single) {
      var expanders = host.queryAll(_expanderClass);

      expanders.forEach((element) {
        var temp = element.xtag as ExpanderComponent;

        if (temp != expander) {
          temp.expanded = 'false';
        }
      });
    }
  }
}
