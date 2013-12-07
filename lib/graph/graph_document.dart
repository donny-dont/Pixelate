part of pixelate_graph;

/** The graph canvas interface */
abstract class IGraphCanvas {
  Element createNodeView(String nodeId, String nodeType, num left, num top);
}

/** The data model of the graph canvas */
class GraphDocument {
  IGraphCanvas canvas;
  
  /** List of nodes in the document mapped by their ids */
  var _nodes = new Map<String, GraphNode>();
  
  /** Graph document id */
  String id;
  
  /** Retrieve a node model from its id */
  GraphNode getNode(String id) => _nodes[id];

  GraphDocument(this.canvas);
  
  void clear() {
    _nodes.clear();
    // TODO: clear links when implemented
  }
  
  Point getSocketPosition(String nodeId, String socketId) {
    final node = _nodes[nodeId];
    if (node == null) {
      return new Point();  //TODO: Throw
    }
    return node.getSocketPosition(socketId);
  }
  
  /** Load the document from a file path */
  Future loadFromFile(String path) {
    var completer = new Completer();
    var request = HttpRequest.getString(path).then((String text) {
      loadFromJson(text);
      completer.complete(this);
    });
    return completer.future;
  }
  
  /** Load the document from json */
  void loadFromJson(String json) {
    var data = JSON.decode(json);
    this.id = data["diagramId"];
    
    clear();
    
    var nodeInfoList = data["nodes"];
    for (var nodeInfo in nodeInfoList) {
      createNode(nodeInfo);
    }
  }
  
  /**
   * Creates a node view and model based on the parameters
   * The following key-values are expected in the map
   *    "nodeId": String based id of the node
   *    "nodeType": The tag name of the node to create in the view
   *    "left": The Left position of the node relative to the graph canvas
   *    "top": The Top position of the node relative to the graph canvas
   */
  void createNode(nodeInfo) {
    String nodeId = nodeInfo["nodeId"];
    String nodeType = nodeInfo["nodeType"];
    int left = nodeInfo["left"];
    int top = nodeInfo["top"];
    
    // Create the view
    final nodeView = canvas.createNodeView(nodeId, nodeType, left, top);
    
    // Create the node model
    final node = new GraphNode(id, nodeView, this);
    _nodes[id] = node;
  }
  

}

