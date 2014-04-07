// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:polymer/polymer.dart';
import 'app_node.dart';

@CustomTag('normal-map-node')
class NormalMapNode extends AppNode {
  NormalMapNode.created() : super.created() {
    title = "Normal Map";
  }
}
