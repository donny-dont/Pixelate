part of pixelate_graph;

/** The Graph node model */
class GraphNode {
  /** The graph data model */
  GraphDocument document;
    
  /** Node id */
  String id;
  
  /** List of sockets hosted by this node, mapped by their ids */
  var _sockets = new Map<String, GraphSocket>();
  
  get sockets => _sockets;
  
  GraphNode(this.id, this.document) {
    // TODO register sockets
  }
  
  GraphSocket getSocket(String id) => _sockets[id];
  
  /** Updates the node view. Called when the state of the node changes (e.g. during dragging etc) */
  void update() {
    
  }
  
  void destroy() {
  }
  
  GraphSocket createSocket(String id) {
    assert (id != null);
    final socket = new GraphSocket(id, this);
    _sockets[id] = socket;
    return socket;
  }
}
