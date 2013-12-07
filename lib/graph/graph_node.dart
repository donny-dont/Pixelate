part of pixelate_graph;

/** The Graph node model */
class GraphNode {
  /** The graph data model */
  GraphDocument document;
  
  /** The node's view element */ 
  Element view;
  
  /** The graph node view element.  This would be composed inside the customized view element */
  GraphNodeView nodeView;
  
  /** Node id */
  String id;
  
  var _onMoved = new StreamController<GraphNodeEvent>();
  Stream<GraphNodeEvent> get onMoved => _onMoved.stream;
  
  /** List of sockets hosted by this node, mapped by their ids */
  var _sockets = new Map<String, GraphSocket>();
  
  GraphNode(this.id, this.view, this.document) {
    // grab all the sockets from the DOM and register them with the document
    var socketViews = view.shadowRoot.querySelectorAll('px-graph-socket');
    socketViews.addAll(view.querySelectorAll('px-graph-socket'));
    
    for (var socketView in socketViews) {
      var socket = new GraphSocket(socketView, this);
      socketView.socket = socket;
      
      var socketId = socket.id;
      _sockets[socketId] = socket;
    }
    
    // Find the node view. It might be inside the customized view element
    nodeView = findChildElement(view, "px-graph-node");
    
    // Listen to the inner node element for drag event and dispatch it to the framework
    nodeView.onNodeMoved.listen((e) => _onMoved.add(new GraphNodeEvent(this)));
  }
  
  /** The position of the node relative to the parent (graph canvas) */
  Point get position => getElementPosition(view);
  
  GraphSocket getSocket(String id) => _sockets[id];
  
  /** Updates the node view. Called when the state of the node changes (e.g. during dragging etc) */
  void update() {
    
  }
}

/** Node event object passed as parameter when firing various node events */
class GraphNodeEvent {
  GraphNode node;
  GraphNodeEvent(this.node);
}
