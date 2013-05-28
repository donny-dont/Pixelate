// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dom_utils;
import 'dart:html';

/// Gets the absolute position of an element in DOM
/// Returns an array with the aboslute [x, y] 
List<int> getPageOffset(Element element) {
  var _x = 0;
  var _y = 0;
  while(element != null && element.offsetLeft != null && element.offsetTop != null) {
    _x += element.offsetLeft - element.scrollLeft;
    _y += element.offsetTop - element.scrollTop;
    element = element.offsetParent;
  }
  return [_x, _y];
}
