// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Expander] class.
library pixelate_expander;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:html';
@MirrorsUsed(targets: const ['pixelate_expandable.Expandable.toggle', 'pixelate_expandable.Expandable.expandedChanged'])
import 'dart:mirrors';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'package:pixelate/customizable.dart';
import 'package:pixelate/expandable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'px-expander';

/// Represents a control that displays a header that has a collapsible window that displays content.
///
/// The expansion/collapse of an element can be controlled in markup by using
/// the expanded attribute, which takes a boolean value. By default the control
/// is collapsed.
///
///     <!-- Collapsed content; the default -->
///     <px-expander></px-expander>
///     <!-- Expanded content -->
///     <px-expander expanded></px-expander>
@CustomTag(_tagName)
class Expander extends PolymerElement with Expandable, Customizable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The view for the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Element _view;
  /// The content contained in the expandable portion.
  ///
  /// Required for the [Expandable] mixin to function.
  Element _content;

  /// The text for the header.
  @published String header;

  @published bool expanded = false;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [Expander] class.
  ///
  /// This constructor should not be called directly. Instead use the
  /// [Element.tag] constructor as follows.
  ///
  ///     var instance = new Element.tag(Expander.customTagName);
  Expander.created()
      : super.created()
  {
    // Initialize the expandable mixin
    var shadowRoot = getShadowRoot(customTagName);

    _content = shadowRoot.querySelector('.expandable');
    _view = shadowRoot.querySelector('.view');

    initializeExpandable();

    // Intitialize the customizable mixin
    initializeCustomizable();
    customizeProperty(#header, 'expander-header', 'default-expander-header');
  }

  //---------------------------------------------------------------------
  // Expandable properties
  //---------------------------------------------------------------------

  Element get content => _content;
  Element get view => _view;
}
