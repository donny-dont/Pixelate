part of pixelate_graph;

/** The Graph node model */
class GraphNode {
  /** The graph data model */
  GraphDocument document;
  
  /** The node's view element */ 
  Element view;
  
  /** Node id */
  String id;
  
  /** List of sockets hosted by this node, mapped by their ids */
  var _sockets = new Map<String, GraphSocket>();
  
  GraphNode(this.id, this.view, this.document) {
    var socketViews = view.shadowRoot.querySelectorAll('px-graph-socket');
    socketViews.addAll(view.querySelectorAll('px-graph-socket'));
    
    for (var socketView in socketViews) {
      var socket = new GraphSocket(socketView, this);
      var socketId = socket.id;
      _sockets[socketId] = socket;
    }
  }
  
  /** The position of the node relative to the parent (graph canvas) */
  Point get position => getElementPosition(view);
  
  Point getSocketPosition(String socketId) {
    var socket = _sockets[socketId];
    if (socket == null) {
      return position;  // TODO: Throw
    }
    final nodePosition = position;
    final socketOffset = socket.positionOffset;
    return new Point(nodePosition.x + socketOffset.x, nodePosition.y + socketOffset.y);
  }
  
  GraphSocket getSocket(String id) => _sockets[id];
}
