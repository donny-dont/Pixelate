library pixelate_demo_graph_appnode;
import 'package:polymer/polymer.dart';
import 'package:pixelate/components/graph_node.dart';

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
