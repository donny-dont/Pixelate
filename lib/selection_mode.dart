// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library selection_mode;

/// Specifies whether a single element or multiple elements can be selected.
///
/// Used by components such as the [AccordionComponent] to specify how child
/// elements can be interacted with.
///
/// \TODO Remove if web_ui gets a way to specify a boolean attribute. This fits
/// more with how HTML is used. See the <input> element which allows multiple
/// to be explictly specified
class SelectionMode {
  //---------------------------------------------------------------------
  // Serialization names
  //---------------------------------------------------------------------

  /// String representation of [Single].
  static const String _singleName = 'single';
  /// String representation of [Multiple].
  static const String _multipleName = 'multiple';

  //---------------------------------------------------------------------
  // Enumerations
  //---------------------------------------------------------------------

  /// Only a single item can be selected at a time.
  static const int Single = 0;
  /// Multiple items can be selected at a time.
  static const int Multiple = 1;

  //---------------------------------------------------------------------
  // Class methods
  //---------------------------------------------------------------------

  /// Convert from a [String] name to the corresponding [SelectionMode] enumeration.
  static int parse(String name) {
    name = name.toLowerCase();

    if (name == _singleName) {
      return Single;
    } else if (name == _multipleName) {
      return Multiple;
    }

    assert(false);
    return Single;
  }

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

  /// Checks whether the value is a valid enumeration.
  ///
  /// Should be gotten rid of when enums are supported properly.
  static bool isValid(int value) {
    return ((value == Single) || (value == Multiple));
  }
}
