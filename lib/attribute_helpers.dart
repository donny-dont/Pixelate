// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library attribute_helpers;

/// Converts a value to a boolean.
///
/// Remove if web_ui gets helpers for binding boolean values to attributes.
bool convertBoolean(String value) {
  var lowerValue = value.toLowerCase();

  if (lowerValue == 'true') {
    return true;
  } else if (lowerValue == 'false') {
    return false;
  }

  throw new ArgumentError('The value is not a boolean');
}
