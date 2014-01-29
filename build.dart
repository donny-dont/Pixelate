// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:polymer/builder.dart';

main(args) {
  build(entryPoints: [
      'web/test.html',
      'web/tests/graph/graph_demo.html',
      'web/components.html'
  ], options: parseOptions(args));
}
