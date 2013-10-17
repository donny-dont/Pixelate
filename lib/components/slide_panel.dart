// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:web_ui/web_ui.dart';
import 'package:pixelate/selection_mode.dart';
import 'expander.dart';

/// An accordion style control.
///
/// Used to host multiple [ExpanderComponent]s and control their behavior.
///
/// The [SelectionMode] can be explictly set to allow multiple
/// [ExpanderComponent]s to be open at a time. If not set then the default is
/// [SelectionMode.Single].
///
///     <!-- Specifying a single selection; the default -->
///     <div is="x-accordion" mode="single"></div>
///     <!-- Specifying multiple selections -->
///     <div is="x-accordion" mode="multiple"></div>
///
/// The [AccordionComponent] defines styles for the borders between elements,
/// which are arranged verically. The following style variables are available
/// for themes.
///
///     div[is=x-accordion] {
///       /* The color of the border */
///       -webkit-var-accordion-border-color: ___;
///       /* The style of the border */
///       -webkit-var-accordion-border-style: ___;
///       /* The width of the border */
///       -webkit-var-accordion-border-width: ___;
///     }
class AccordionComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// Class name for [ExpanderComponent]s.
  static const String _expanderClass = 'div[is=x-expander]';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The [SelectionMode] for the [AccordionComponent].
  ///
  /// Allows only a single component to be expanded, or any number of components.
  int _mode = SelectionMode.Single;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The [SelectionMode] for the [AccordionComponent].
  ///
  /// Allows only a single component to be expanded, or any number of components.
  String get mode => SelectionMode.stringify(_mode);
  set mode(String value) {
    int newMode = SelectionMode.parse(value);

    if (newMode != _mode) {
      // Renable the selected element if going into multiple mode
      if (newMode == SelectionMode.Multiple) {
        var expanders = host.queryAll(_expanderClass);

        expanders.forEach((expander) { expander.disabled = 'false'; });
      }

      _mode = newMode;
    }
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

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Callback for when an element is expanded.
  ///
  /// In the case of [SelectionMode.Single] any expanded elements are collapsed.
  void _onExpanded(ExpanderComponent expander) {
    if (_mode == SelectionMode.Single) {
      var expanders = host.queryAll(_expanderClass);

      expanders.forEach((element) {
        var temp = element.xtag as ExpanderComponent;

        if (temp == expander) {
          temp.disabled = 'true';
        } else {
          temp.disabled = 'false';
          temp.expanded = 'false';
        }
      });
    }
  }
}
