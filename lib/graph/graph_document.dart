part of pixelate_graph;

/** The graph canvas interface */
abstract class IGraphCanvas {
  svg.SvgElement get svg;
  Element createNodeView(String nodeId, String nodeType, num left, num top);
  GraphLinkView createLinkView(GraphLink link);
  
  /** The scroll position of the canvas view */
  Point get scrollOffset;
}

/** The data model of the graph canvas */
class GraphDocument {
  IGraphCanvas canvas;
  
  /** List of nodes in the document mapped by their ids */
  var _nodes = new Map<String, GraphNode>();
  
  /** List of links in the document mapped by their ids */
  var _links = new Map<String, GraphLink>();
  
  /** Graph document id */
  String id;
  
  /** Retrieve a node model from its id */
  GraphNode getNode(String id) => _nodes[id];

  /** Handles the link creation process */
  LinkCreationHandler linkCreationHandler;
  
  GraphDocument(this.canvas) {
    linkCreationHandler = new LinkCreationHandler(this);
  }
  
  void clear() {
    _nodes.clear();
    // TODO: clear links when implemented
  }
  
  Point getSocketPosition(String nodeId, String socketId) {
    final node = _nodes[nodeId];
    if (node == null) {
      return new Point(0, 0);  //TODO: Throw
    }
    return node.getSocketPosition(socketId);
  }
  
  /** Load the document from a file path */
  Future loadFromFile(String path) {
    var completer = new Completer();
    var request = HttpRequest.getString(path).then((String text) {
      loadFromJson(text);
      completer.complete(this);
    });
    return completer.future;
  }
  
  /** Load the document from json */
  void loadFromJson(String json) {
    var data = JSON.decode(json);
    this.id = data["diagramId"];
    
    clear();
    
    // Create nodes
    var nodeInfoList = data["nodes"];
    for (var nodeInfo in nodeInfoList) {
      createNode(nodeInfo);
    }
    
    // Create links
    var linkInfoList = data["links"];
    for (var linkInfo in linkInfoList) {
      createLink(linkInfo);
    }
  }
  
  /**
   * Creates a node view and model based on the parameters
   * The following key-values are expected in the map
   *    "nodeId"  : String based id of the node
   *    "nodeType": The tag name of the node to create in the view
   *    "left"    : The Left position of the node relative to the graph canvas
   *    "top"     : The Top position of the node relative to the graph canvas
   */
  void createNode(nodeInfo) {
    String nodeId = nodeInfo["nodeId"];
    String nodeType = nodeInfo["nodeType"];
    int left = nodeInfo["left"];
    int top = nodeInfo["top"];
    
    // Create the view
    final nodeView = canvas.createNodeView(nodeId, nodeType, left, top);
    
    // Create the node model
    final node = new GraphNode(nodeId, nodeView, this);
    _nodes[nodeId] = node;
    
    // listen to node events
    // TODO: Optimize
    node.onMoved.listen(_updateLinks);
    node.sockets.values.forEach((GraphSocket socket) {
      socket.view.onSocketChanged.listen(_updateLinks);
      socket.view.onMouseDown.listen((e) => linkCreationHandler._handleLinkCreationStart(socket, e));
      socket.view.onMouseUp.listen((e) => linkCreationHandler._handleLinkCreationEndOnSocket(socket, e));
    });
  }
  
  void _updateLinks(e) {
    // TODO: Optimize by updating only dirty links
    _links.values.forEach((GraphLink link) => link.update());
  }
  
  /**
   * Creates a link view and model based on the parameters
   * The following key-values are expected in the map
   *    "linkId"        : String based id of the link
   *    "sourceNodeId"  : The node id where the link originates
   *    "sourceSocketId": The socket on the node id where the link originates
   *    "destNodeId"    : The node id where the link ends
   *    "destSocketId"  : The socket on the node id where the link ends
   */
  void createLink(linkInfo) {
    String linkId = linkInfo["linkId"];
    String sourceNodeId = linkInfo["sourceNodeId"];
    String sourceSocketId = linkInfo["sourceSocketId"];
    String destNodeId = linkInfo["destNodeId"];
    String destSocketId = linkInfo["destSocketId"];
    
    // Create the link model
    final link = new GraphLink(linkId, this, sourceNodeId, sourceSocketId, destNodeId, destSocketId);
    
    // Create the link view
    final linkView = canvas.createLinkView(link);
    link.view = linkView;
    
    _links[linkId] = link;
  }
}


/** Handles the link creation logic */
class LinkCreationHandler {
  /** Host document model */
  GraphDocument document;
  
  /** 
   * The temporary link view used to display a link from the origin to the cursor
   * Hence, this link would be connected to only the source and the other end
   * follows the mouse cursor while it is being moved to the desitnation node
   */
  GraphLinkView creationLink;

  /** The socket where the drag initiated from */
  GraphSocket originSocket;
  
  LinkCreationHandler(this.document) {
  }
  
  StreamSubscription<MouseEvent> linkCreationDragStream;
  StreamSubscription<MouseEvent> linkCreationDragStopStream;
  
  /** the point when the drag started */
  Point startDragPoint;
  
  /** Fired when the link creation is initiated */
  void _handleLinkCreationStart(GraphSocket socket, MouseEvent e) {
    originSocket = socket;
    
    // Hook to the window's mouse events
    linkCreationDragStream = window.onMouseMove.listen(_handleLinkCreationDrag);
    linkCreationDragStopStream = window.onMouseUp.listen(_handleLinkCreationEnd);
    
    // Create a new link to draw from the source socket to the cursor position, till the mouse is released
    creationLink = new GraphLinkView(null, document.canvas.svg);
    
    startDragPoint = new Point(e.page.x, e.page.y);
  }
  /** Handle the link creation process, while the pointer has not yet reached the destination */
  void _handleLinkCreationDrag(MouseEvent e) {
    // update the temporary link's path from the source to the cursor position
    Point source = originSocket.position;
    Point sourceDirection = originSocket.plugDirection;
    Point destinationDirection = new Point(-sourceDirection.x, -sourceDirection.y);
    Point mouseOffsetSinceStart = new Point(e.page.x - startDragPoint.x, e.page.y - startDragPoint.y);
    Point destination = new Point(source.x + mouseOffsetSinceStart.x, source.y + mouseOffsetSinceStart.y);

    creationLink.updateFromMetrics(source, sourceDirection, destination, destinationDirection);
  }
  
  /** 
   * Handle the link creation end event.  Either the mouse
   * pointer is on top of another node socket, in which case
   * a link would be created. Otherwise, the link creation 
   * is cancelled
   */
  void _handleLinkCreationEnd(MouseEvent e) {
    if (creationLink != null) {
      creationLink.destroy();
      creationLink = null;
    }
    
    _cancelGlobalMouseStream();
  }

  /** cancels the stream subscription to stop listening to global mouse events */ 
  void _cancelGlobalMouseStream() {
    if (linkCreationDragStream != null) {
      linkCreationDragStream.cancel();
      linkCreationDragStream = null;
    }
    if (linkCreationDragStopStream != null) {
      linkCreationDragStopStream.cancel();
      linkCreationDragStopStream = null;
    }
  }
  
  
  /** Cursor was released on a socket. Create a link if necessary */
  void _handleLinkCreationEndOnSocket(GraphSocket socket, MouseEvent e) {
    print ("LINK CREATION STOP << NODE");
    if (creationLink != null) {
      creationLink.destroy();
      creationLink = null;
    }
  
    if (socket == originSocket) {
      // Source and destination sockets are the same. ignore
      return;
    }

    _cancelGlobalMouseStream();

    // Create a new link in the document
    var linkInfo = new Map();
    linkInfo["linkId"] = generateUid();
    linkInfo["sourceNodeId"] = originSocket.node.id;
    linkInfo["sourceSocketId"] = originSocket.id;
    linkInfo["destNodeId"] = socket.node.id;
    linkInfo["destSocketId"] = socket.id;
    document.createLink(linkInfo);
  }
}

