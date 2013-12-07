library pixelate_utils_core;

import 'package:uuid/uuid.dart';
import 'dart:html';
import 'dart:math';

var idGeneratorUid = new Uuid();
/** Generates a unique id */
String generateUid() {
  return idGeneratorUid.v4();
}

/** Parses the string "Npx" to an integer N */
num parsePixel(String text, [int defaultValue = 0]) {
  if (text == null || text.length == 0) return defaultValue;
  if (!text.endsWith("px")) return defaultValue;
  return int.parse(text.replaceAll("px", ""));
}

Point getElementPosition(Element e) {
  final x = parsePixel(e.style.left, e.client.left);
  final y = parsePixel(e.style.top, e.client.top);
  return new Point(x, y);
}

Point getElementOffset(Element e) {
  final x = parsePixel(e.style.left, e.offset.left);
  final y = parsePixel(e.style.top, e.offset.top);
  return new Point(x, y);
}

/** Finds the child recursively element with the specified [tagName] */  
Element findChildElement(Element element, String tagName) {
  if (element == null) return null;
  if (element.tagName.toLowerCase() == tagName.toLowerCase()) return element;
  
  var children = new List.from(element.children, growable: true);
  if (element.shadowRoot != null) {
    children.addAll(element.shadowRoot.children);
  }
  
  // Recursively search all children
  for (var child in children) {
    if (child is Element) {
      var result = findChildElement(child, tagName);
      
      // Found the correct node from this parent
      if (result != null) return result;
    }
  }
  
  // Not found
  return null;
}