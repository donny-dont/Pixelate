// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library pixelate_expandable_element;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:pixelate/expandable.dart';

const String _tagName = 'px-expandable-element';

@CustomTag(_tagName)
class ExpandableElement extends PolymerElement with Expandable {
  Element view;
  Element content;

  @published bool expanded = false;

  static String get customTagName => _tagName;

  ExpandableElement.created()
      : super.created()
  {
    view = shadowRoot.querySelector('.view');
    content = shadowRoot.querySelector('.expandable');

    initializeExpandable();
  }

  int get headerHeight => shadowRoot.querySelector('.header').clientHeight;
  int get contentHeight => content.clientHeight;
}
