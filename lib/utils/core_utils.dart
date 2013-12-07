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
