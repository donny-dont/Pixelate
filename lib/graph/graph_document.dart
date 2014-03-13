part of pixelate_graph;

/** The data model of the graph canvas */
class GraphDocument {
  
  /** List of nodes in the document mapped by their ids */
  var _nodes = new Map<String, GraphNode>();
  
  /** List of links in the document mapped by their ids */
  var _links = new Map<String, GraphLink>();
  
  /** Graph document id */
  String id;
  
  /** Retrieve a node model from its id */
  GraphNode getNode(String id) => _nodes[id];
  
  GraphDocument() {
  }
  
  void clear() {
    _nodes.clear();
    _links.clear();
  }
  
  Point getSocketPosition(String nodeId, String socketId) {
    final node = _nodes[nodeId];
    if (node == null) {
      return new Point(0, 0);  //TODO: Throw
    }
    return node.getSocketPosition(socketId);
  }
  
  
  /**
   * Creates a node view and model based on the parameters
   *    [nodeId] is a String based id of the node
   *    [nodeType] The tag name of the node to create in the view
   */
  GraphNode createNode(String nodeId, String nodeType) {
    // Create the node model
    // TODO: use a factory to create the node object
    final node = new GraphNode(nodeId, this);
    _nodes[nodeId] = node;
    return node;
  }
  
  void deleteNode(String nodeId) {
    GraphNode node = _nodes[nodeId];
    if (node != null) {
      _nodes.remove(nodeId);
      node.destroy();
    }
  }
  
  /**
   * Creates a link view and model based on the parameters
   *    "linkId"        : String based id of the link
   *    "sourceNodeId"  : The node id where the link originates
   *    "sourceSocketId": The socket on the node id where the link originates
   *    "destNodeId"    : The node id where the link ends
   *    "destSocketId"  : The socket on the node id where the link ends
   */
  GraphLink createLink(String linkId, String sourceNodeId, String sourceSocketId, String destNodeId, String destSocketId) {
    final link = new GraphLink(linkId, this, sourceNodeId, sourceSocketId, destNodeId, destSocketId);
    _links[linkId] = link;
    return link;
  }
  
  /** Deletes a link from the document */
  void deleteLink(String linkId) {
    GraphLink link = _links[linkId];
    if (link != null) {
      _links.remove(linkId);
      link.destroy();
    }
  }
}

