// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library pixelate_demo_graph_appnode;
import 'package:polymer/polymer.dart';
import 'package:pixelate/components/graph_canvas/graph_node.dart';

@CustomTag('app-node')
class AppNode extends GraphNodeView with Observable {
  @observable String title = "Node";
  @published int x;
  @published int y;
  AppNode.created() : super.created();

  @override
  void enteredView() {
    super.enteredView();
    enableDragging("drag_handle");
  }
}
