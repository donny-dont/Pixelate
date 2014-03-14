part of pixelate_graph;

/** 
 * Makes sure a link is not attached to two sockets from the same node
 */
class GraphConstraintSameNode extends GraphConstraint {

  /// The constraint does not require any [params]
  GraphConstraintSameNode(GraphSocket socket, Map params) : super(socket, params);
  
  bool canAcceptOutgoingLink() {
    return true;
  }
  
  bool canAcceptIncomingLink(GraphSocket sourceSocket) {
    // Make sure the sockets do not belog to the same node
    return this.socket.node != sourceSocket.node;
  }
}