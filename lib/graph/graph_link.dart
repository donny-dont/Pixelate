part of pixelate_graph;

/** A graph link is the link connecting two node sockets */
class GraphLink {
  /** The source node socket. The link originates from here */ 
  GraphSocket source;
  
  /** The destination node socket. The link ends here */
  GraphSocket destination;
  
  /** The document that hosts this link */
  GraphDocument document;
  
  /** The link id */
  String id;
  
  /** The link view */
  GraphLinkView view;
  
  /** Create a graph link from existing socket objects */
  GraphLink.from(this.id, this.document, this.source, this.destination);
  
  GraphLink(this.id, this.document, String sourceNodeId, String sourceSocketId,
        String destNodeId, String destSocketId) {
    source = document.getNode(sourceNodeId).getSocket(sourceSocketId);
    destination = document.getNode(destNodeId).getSocket(destSocketId);
    source.links.add(this);
    destination.links.add(this);
  }
  
  void update() {
    view.update();
  }
  
  void destroy() {
    source.links.remove(this);
    destination.links.remove(this);
    view.destroy();
  }
}