part of pixelate_graph;

/** The data model for the node socket */
class GraphSocket {
  /** The node that hosts this socket */
  GraphNode node;
  
  /** Socket id */
  String id;
  
  /** Links connected to the socket */
  var links = new List<GraphLink>();

  GraphSocket(this.id, this.node);
  
}
