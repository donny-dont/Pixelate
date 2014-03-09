// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ProgressBar] class.
library pixelate_progress_bar;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-progress-bar';

/// A progress bar.
///
/// The amount filled can be controlled in markup by using the max and value
/// attributes. By default the max value is set to 1, while the value is
/// initially set to 0. The minimum value is always assumed to be 0. The bar
/// will be filled by (value / max) * width.
///
///     <!-- A bar filled halfway -->
///     <px-progress-bar value="0.5"></px-progress-bar>
///     <!-- Another bar filled halfway but with a different maximum -->
///     <px-progress-bar value="5" max="10"></px-progress-bar>
@CustomTag(_tagName)
class ProgressBar extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The current value of the progress bar.
  @published num value = 0.0;
  /// The maximum value of the progress bar.
  @published num max = 1.0;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [ProgressBar] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(ProgressBar.customTagName);
  ProgressBar.created()
      : super.created();

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  void ready() {
    super.ready();

    _computeFill();
  }

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  /// Callback for when the [value] changes.
  void valueChanged(num oldValue) {
    _computeFill();
  }

  /// Callback for when the [max] value changes.
  void maxChanged(num oldValue) {
    _computeFill();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Computes the percentage the bar should be filled.
  void _computeFill() {
    var percentage = (value / max) * 100.0;

    if (percentage > 100) {
      percentage = 100.0;
    }

    var fill = shadowRoot.querySelector('span');
    fill.style.width = '${percentage}%';
  }
}
