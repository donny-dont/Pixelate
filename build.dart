// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:polymer/builder.dart';

main(args) {
  build(entryPoints: [
      'web/index.html',
      'web/components/accordion/index.html',
      'web/components/button/index.html',
      'web/components/expander/index.html',
      'web/components/flex_panel/index.html',
      'web/components/grid_panel/index.html',
      'web/components/progress_bar/index.html',
      'web/components/scroll_viewer/index.html',
      'web/components/tab/index.html',
      'web/components/tree_view/index.html',
      'web/getting_started/index.html',
      'example/graph/index.html',
      'example/list_view/index.html',
      'example/tree_view/index.html'
  ], options: parseOptions(args));
}
