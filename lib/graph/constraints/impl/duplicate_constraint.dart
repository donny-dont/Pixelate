part of pixelate_graph;

/** 
 * Makes sure a duplicate links are not created
 */
class GraphConstraintDuplicate extends GraphConstraint {

  /// The constraint does not require any [params]
  GraphConstraintDuplicate(GraphSocket socket, Map params) : super(socket, params);
  
  bool canAcceptOutgoingLink() {
    // We check only when the link is about to be created
    return true;
  }
  
  bool canAcceptIncomingLink(GraphSocket sourceSocket) {
    // Make sure the sockets do not belog to the same node
    for (GraphLink incomingLink in _incomingLinks) {
      if (incomingLink.source == sourceSocket) {
        // A link between these two sockets has already been created. Do not allow a duplicate
        return false;
      }
    }
    return true;
  }
}