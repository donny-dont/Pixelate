// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:unittest/html_enhanced_config.dart';
import 'package:polymer/polymer.dart';
export 'package:polymer/init.dart';

import 'behaviors/customizable_test.dart' as customizable_test;
import 'behaviors/expandable_test.dart' as expandable_test;
import 'grid/grid_test.dart' as grid_test;

@initMethod
void init() {
  useHtmlEnhancedConfiguration();

  // Behavior tests
  //customizable_test.main();
  expandable_test.main();

  // Grid tests
  //grid_test.main();
}
