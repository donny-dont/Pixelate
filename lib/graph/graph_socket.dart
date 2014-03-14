part of pixelate_graph;

/** The data model for the node socket */
class GraphSocket {
  /** The node that hosts this socket */
  GraphNode node;
  
  /** Socket id */
  String id;
  
  /** Links connected to the socket */
  var links = new List<GraphLink>();

  /** 
   * The list of constraints attached to this node
   * Constraints are used to determine if a link be attached to this socket 
   */
  List<GraphConstraint> constraints = [];
  
  GraphSocket(this.id, this.node);

  /** Checks all the constraints and determines if an outgoing link can be accepted from this socket */
  bool canAcceptOutgoingLink() {
    var result = true;
    constraints.forEach((constraint) { result = result && constraint.canAcceptOutgoingLink(); });
    return result;
  }
  
  /** Checks all the constraints and determines if an incoming link can be accepted from this socket */
  bool canAcceptIncomingLink(GraphSocket sourceSocket) {
    var result = true;
    constraints.forEach((constraint) { result = result && constraint.canAcceptIncomingLink(sourceSocket); });
    return result;
  }
}
