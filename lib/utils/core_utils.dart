library pixelate_utils_core;

import 'package:uuid/uuid.dart';

var idGeneratorUid = new Uuid();
String generateUid() {
  return idGeneratorUid.v4();
}