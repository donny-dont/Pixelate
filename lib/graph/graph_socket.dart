part of pixelate_graph;

/** The data model for the node socket */
class GraphSocket {
  /** The node that hosts this socket */
  GraphNode node;
  
  /** The socket view */
  GraphSocketView view;
  
  /** Socket id */
  String id;
  
  /** Links connected to the socket */
  var links = new List<GraphLink>();

  /** The direction from which the link is plugged into this socket */
  Point get plugDirection => view.plugDirection; 
  
  GraphSocket(this.view, this.node) {
    // Extract the id from the view
    id = view.id; 
  }
  
  Point getPositionOffset() {
    final offset = getElementOffset(view);
    final size = view.size;
    return new Point(offset.x + size.x / 2, offset.y + size.y / 2);
  }
  
  Point get position {
    final nodePosition = node.position;
    final socketOffset = getPositionOffset();
    return new Point(nodePosition.x + socketOffset.x, nodePosition.y + socketOffset.y);
  }
  
}
