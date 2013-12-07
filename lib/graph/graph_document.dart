part of pixelate_graph;

/** The graph canvas interface */
abstract class IGraphCanvas {
  Element createNodeView(String nodeId, String nodeType, num left, num top);
  GraphLinkView createLinkView(GraphLink link);
}

/** The data model of the graph canvas */
class GraphDocument {
  IGraphCanvas canvas;
  
  /** List of nodes in the document mapped by their ids */
  var _nodes = new Map<String, GraphNode>();
  
  /** List of links in the document mapped by their ids */
  var _links = new Map<String, GraphLink>();
  
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
    
    // Create nodes
    var nodeInfoList = data["nodes"];
    for (var nodeInfo in nodeInfoList) {
      createNode(nodeInfo);
    }
    
    // Create links
    var linkInfoList = data["links"];
    for (var linkInfo in linkInfoList) {
      createLink(linkInfo);
    }
  }
  
  /**
   * Creates a node view and model based on the parameters
   * The following key-values are expected in the map
   *    "nodeId"  : String based id of the node
   *    "nodeType": The tag name of the node to create in the view
   *    "left"    : The Left position of the node relative to the graph canvas
   *    "top"     : The Top position of the node relative to the graph canvas
   */
  void createNode(nodeInfo) {
    String nodeId = nodeInfo["nodeId"];
    String nodeType = nodeInfo["nodeType"];
    int left = nodeInfo["left"];
    int top = nodeInfo["top"];
    
    // Create the view
    final nodeView = canvas.createNodeView(nodeId, nodeType, left, top);
    
    // Create the node model
    final node = new GraphNode(nodeId, nodeView, this);
    _nodes[nodeId] = node;
    
    // listen to node events
    node.onMoved.listen((GraphNodeEvent e) {
      // update all links
      // TODO: Optimize by updating only links attached to this node
      _links.values.forEach((GraphLink link) => link.update());
    });
  }
  
  
  /**
   * Creates a link view and model based on the parameters
   * The following key-values are expected in the map
   *    "linkId"        : String based id of the link
   *    "sourceNodeId"  : The node id where the link originates
   *    "sourceSocketId": The socket on the node id where the link originates
   *    "destNodeId"    : The node id where the link ends
   *    "destSocketId"  : The socket on the node id where the link ends
   */
  void createLink(linkInfo) {
    String linkId = linkInfo["linkId"];
    String sourceNodeId = linkInfo["sourceNodeId"];
    String sourceSocketId = linkInfo["sourceSocketId"];
    String destNodeId = linkInfo["destNodeId"];
    String destSocketId = linkInfo["destSocketId"];
    
    // Create the link model
    final link = new GraphLink(linkId, this, sourceNodeId, sourceSocketId, destNodeId, destSocketId);
    
    // Create the link view
    final linkView = canvas.createLinkView(link);
    link.view = linkView;
    
    _links[linkId] = link;
  }
  
}

