part of pixelate_graph;

/** The data model for the node socket */
class GraphSocket {
  /** The node that hosts this socket */
  GraphNode node;
  
  /** The socket view */
  GraphSocketView view;
  
  /** Socket id */
  String id;
  
  Point get positionOffset => getElementPosition(view);
  
  GraphSocket(this.view, this.node) {
    // Extract the id from the view
    id = view.id; 
  }
}