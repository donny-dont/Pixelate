
library pixelate_test_helpers;

import 'dart:async';
import 'dart:html';
import 'package:unittest/unittest.dart';

String _testAreaSelector = '#test-area';

Element createElementInTestArea(String tag) {
  var element = new Element.tag(tag);

  appendToTestArea(element);

  return element;
}

void appendToTestArea(Node node) {
  var testArea = querySelector(_testAreaSelector);

  testArea.append(node);
}

void clearTestArea() {
  var testArea = querySelector(_testAreaSelector);

  testArea.children.clear();
}

void waitForLayout(void callback()) {
  new Timer(new Duration(seconds: 1), expectAsync0(callback));
}
