library pixelate_utils_core;

import 'dart:html';
import 'dart:math';

/** Generates a unique id */
int _idGenerationCounter = 0;
String generateUid() {
  return "${++_idGenerationCounter}";
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
Element findChildElementByTagName(Element element, String tagName) {
  return _findChildElement(element, (e) => e.tagName.toLowerCase() == tagName.toLowerCase());
}

/** Finds the child recursively element with the specified [tagName] */  
Element findChildElementById(Element element, String id) {
  return _findChildElement(element, (e) => e.id == id);
}

Point addPoint(Point a, Point b) {
  return new Point(a.x + b.x, a.y + b.y);
}

Point multiplyPoint(Point a, Point b) {
  return new Point(a.x * b.x, a.y * b.y);
}

Point multiplyPointScalar(Point a, num b) {
  return new Point(a.x * b, a.y * b);
}

typedef bool VerifyElement(Element e);
Element _findChildElement(Element element, VerifyElement verifyElement) {
  if (element == null) return null;
  if (verifyElement(element)) {
    // Match found.
    return element;
  }
  
  var children = new List.from(element.children, growable: true);
  if (element.shadowRoot != null) {
    children.addAll(element.shadowRoot.children);
  }
  
  // Recursively search all children
  for (var child in children) {
    if (child is Element) {
      var result = _findChildElement(child, verifyElement);
      
      // Found the correct node from this parent
      if (result != null) return result;
    }
  }
  
  // Not found
  return null;
}


