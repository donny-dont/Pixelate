part of pixelate_graph;

/** 
 * Limits the no. of nodes that can be emitted from a socket.
 * This constraint can be useful for creating input / output nodes
 */
class GraphConstraintInOut extends GraphConstraint {
  /** The no. of allowed incoming links. -1 indicates unlimited links */
  int allowedIncoming = -1;
  
  /** The no. of allowed outgoing links. -1 indicates unlimited links */
  int allowedOutgoing = -1;

  ///
  /// The [params] to the constraint are
  ///   multiple  : Bool value indicates if multiple nodes can emitted from this socket
  ///   type      :
  ///     Valid values are "in", "out", "inout"
  ///     "in" makes this an input socket and does not allow links to be emitted from this socket
  ///     "out" makes this an output socket and does not accept links into this socket
  ///     "inout" accepts sockets comin in and out
  GraphConstraintInOut(GraphSocket socket, Map params) : super(socket, params) {
    // Indicates if socket can emit / accept more than 1 node
    final multiple = params["multiple"];
    final type = params["type"];
    const String TYPE_IN = "in";
    const String TYPE_OUT = "out";
    const String TYPE_INOUT = "inout";
    
    allowedIncoming = 0;
    allowedOutgoing = 0;
    if (type == TYPE_IN || type == TYPE_INOUT) {
      allowedIncoming = multiple ? -1 : 1;
    }
    if (type == TYPE_OUT || type == TYPE_INOUT) {
      allowedOutgoing = multiple ? -1 : 1;
    }
  }
  
  bool canAcceptOutgoingLink() {
    if (allowedOutgoing < 0) return true;
    return _outgoingLinks.length < allowedOutgoing;
  }
  
  bool canAcceptIncomingLink(GraphSocket sourceSocket) {
    if (allowedIncoming < 0) return true;
    return _incomingLinks.length < allowedIncoming;
  }
}