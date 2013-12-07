part of pixelate_graph;

/** A graph link is the link connecting two node sockets */
class GraphLink {
  /** The source node socket. The link originates from here */ 
  GraphSocket source;
  
  /** The destination node socket. The link ends here */
  GraphSocket destination;
  
  /** The link id */
  String id;
  
  /** Create a graph link from existing socket objects */
  GraphLink.from(this.id, this.source, this.destination);
  
  GraphLink(this.id, GraphDocument document, String sourceNodeId, String sourceSocketId,
        String destNodeId, String destSocketId) {
    source = document.getNode(sourceNodeId).getSocket(sourceSocketId);
    destination = document.getNode(destNodeId).getSocket(destSocketId);
  }
}