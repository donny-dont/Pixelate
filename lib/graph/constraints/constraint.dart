part of pixelate_graph;

abstract class GraphConstraint {
  /** The socket that owns this constraint */
  GraphSocket socket;
  
  /** Parameters of the constraint provided during initialization */
  Map params;
  
  GraphConstraint(this.socket, this.params);
  
  /** 
   * Checks if a link creation can be started from this socket
   * This is called when the link creation is about to be started
   */
  bool canAcceptOutgoingLink();
  
  /** 
   * Checks if the link can be created in the destination socket. 
   * This is called when a link is about to be created
   * Here, the owning socket (which this constraint object is acting on)
   * is the destination socket  
   */
  bool canAcceptIncomingLink(GraphSocket sourceSocket);
  
  /** 
   * Fetches the list of outgoing links from this socket
   */
  get _outgoingLinks => socket.links.where((GraphLink link) => link.source == socket);

  /** 
   * Fetches the list of incoming links to this socket
   */
  get _incomingLinks => socket.links.where((GraphLink link) => link.destination == socket);

}