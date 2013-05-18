// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library selection_mode;

class SelectionMode {
  static const String _singleName = 'single';
  static const String _multipleName = 'multiple';

  static const int Single = 0;
  static const int Multiple = 1;

  /// Converts the [SelectionMode] enumeration to a [String].
  static String stringify(int value) {
    if (value == Single) {
      return _singleName;
    } else if (value == Multiple) {
      return _multipleName;
    }

    assert(false);
    return _singleName;
  }
}
