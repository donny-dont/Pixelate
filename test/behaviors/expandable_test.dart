// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library expandable_test;

import 'package:unittest/unittest.dart';
import '../test_helpers.dart';
import 'expandable_element.dart';

ExpandableElement element;

void testExpansion() {
  element.expanded = true;

  waitForLayout(() {
    var totalHeight = element.headerHeight + element.contentHeight;
    print(element.headerHeight);
    print(element.contentHeight);

    expect(element.clientHeight, totalHeight);
  });
}

void testCollapse() {

}

void testToggle() {

}

void main() {
  group('Expandable tests', () {

    element = createElementInTestArea(ExpandableElement.customTagName);

    test('Testing', testExpansion);
  });
}
