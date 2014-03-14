library pixelate_graph_canvas;

import 'package:polymer/polymer.dart';
import 'dart:svg' as s;
import 'dart:async';
import 'dart:html';
import 'dart:math' as math;
import 'package:pixelate/components/graph_node.dart';
import 'package:pixelate/components/graph_link.dart';
import 'package:pixelate/components/graph_socket.dart';
import 'package:pixelate/utils/core_utils.dart';
import 'package:pixelate/graph/graph.dart';
import 'package:pixelate/graph/graph_serializer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('px-graph-canvas')
class GraphCanvas extends PolymerElement {
  s.SvgElement svg;
  
  /** The initial document to load on the graph canvas */
  @published String src;

  /** The graph canvas id */
  String id = generateUid();
  
  /** The data model of this graph canvas */
  var document;

  /** List of graph node views */
  Map<String, GraphNodeView> nodeViews = new Map<String, GraphNodeView>();

  /** List of graph link views */
  Map<String, GraphLinkView> linkViews = new Map<String, GraphLinkView>();
  
  GraphCanvas.created() : super.created();

  /** The outer content container that holds the SVG and Node dom elements */
  Element containerElement;
  
  /** The element that host the DOM for the nodes */
  Element nodeHostElement;


  /** Handles the link creation process */
  LinkCreationHandler linkCreationHandler;
  
  @override
  void enteredView() {
    super.enteredView();
    svg = this.shadowRoot.querySelector("#diagram_svg");
    nodeHostElement = this.shadowRoot.querySelector("#diagram_dom");
    containerElement = this.shadowRoot.querySelector("#outer_content");
    containerElement.onContextMenu.listen((MouseEvent e) => e.preventDefault());

    linkCreationHandler = new LinkCreationHandler(this);
    document = new GraphDocument();
    
    // Load the initial graph document, if specified
    if (src != null && src.length > 0) {
      final serializer = new GraphSerializer();
      serializer.loadFromFile(src, this);
    }
  }
  
  math.Point get scrollOffset => new math.Point(containerElement.scrollLeft, containerElement.scrollTop);

  /**
   * Creates a node view and model based on the parameters
   *    "nodeId"  : String based id of the node
   *    "nodeType": The tag name of the node to create in the view
   *    "left"    : The Left position of the node relative to the graph canvas
   *    "top"     : The Top position of the node relative to the graph canvas
   */
  void createNode(String nodeId, String nodeType, num left, num top) {
    GraphNode node = document.createNode(nodeId, nodeType);
    GraphNodeView nodeView = new Element.tag(nodeType);
    nodeView.model = node;
    nodeView.style.position = "absolute";
    nodeView.style.left = "${left}px";
    nodeView.style.top = "${top}px";
    nodeView.onNodeMoved.listen(_onNodeMoved);
    this.children.add(nodeView);

    nodeViews[nodeId] = nodeView;
    
    // listen to node events
    nodeView.onMoved.listen(_updateLinks);
    nodeView.socketViews.values.forEach((GraphSocketView socketView) {
      socketView.onSocketChanged.listen(_updateLinks);
      socketView.onMouseDown.listen((e) => linkCreationHandler._handleLinkCreationStart(socketView, e));
      socketView.onMouseUp.listen((e) => linkCreationHandler._handleLinkCreationEndOnSocket(socketView, e));
    });
  }

  /** Deletes a link from the document */
  void deleteNode(String nodeId) {
    GraphNodeView nodeView = nodeViews[nodeId];
    if (nodeView != null) {
      nodeViews.remove(nodeId);
      nodeView.destroy();
    }
  }
  
  /**
   * Creates a link view and model based on the parameters
   *    "linkId"        : String based id of the link
   *    "sourceNodeId"  : The node id where the link originates
   *    "sourceSocketId": The socket on the node id where the link originates
   *    "destNodeId"    : The node id where the link ends
   *    "destSocketId"  : The socket on the node id where the link ends
   */
  void createLink(String linkId, String sourceNodeId, String sourceSocketId, String destNodeId, String destSocketId) {
    // Create the link model
    GraphLink link = document.createLink(linkId, sourceNodeId, sourceSocketId, destNodeId, destSocketId);
    final linkView = new GraphLinkView(link, this);
    linkView.update(nodeViews);
    
    linkViews[linkId] = linkView;
  }

  /** Deletes a link from the document */
  void deleteLink(String linkId) {
    GraphLinkView linkView = linkViews[linkId];
    if (linkView != null) {
      linkViews.remove(linkId);
      linkView.destroy();
    }
  }
  
  void clear() {
    nodeViews.clear();
    linkViews.clear();
    
    document.clear();
  }
  void _updateLinks(e) {
    // TODO: Optimize by updating only dirty links
    linkViews.values.forEach((GraphLinkView linkView) => linkView.update(nodeViews));
  }
  
  void _onNodeMoved(GraphNodeView nodeView) {
    // Resize the SVG whenever the size of the node container increases
    _updateSVGBounds(); // TODO: Optimize
  }
  
  /** Keeps the SVG element's size in sync with the node DOM container element */
  void _updateSVGBounds() {
    svg.style.width = "${containerElement.scrollWidth}px";
    svg.style.height = "${containerElement.scrollHeight}px";
  }
  
}

/** Handles the link creation logic */
class LinkCreationHandler {
  /** Host graph canvas */
  GraphCanvas canvas;
  
  /** 
   * The temporary link view used to display a link from the origin to the cursor
   * Hence, this link would be connected to only the source and the other end
   * follows the mouse cursor while it is being moved to the desitnation node
   */
  GraphLinkView creationLink;

  /** The socket where the drag initiated from */
  GraphSocketView originSocket;
  
  LinkCreationHandler(this.canvas) {
  }
  
  StreamSubscription<MouseEvent> linkCreationDragStream;
  StreamSubscription<MouseEvent> linkCreationDragStopStream;
  
  /** the point when the drag started */
  Point startDragPoint;
  
  bool dragging = false;
  
  /** Fired when the link creation is initiated */
  void _handleLinkCreationStart(GraphSocketView socketView, MouseEvent e) {
    // Check the constraints of the socket to determine if it can create a link from here
    if (!socketView.socket.canAcceptOutgoingLink()) {
      // Does not accept outgoing links.  Do not create a link from here
      return;
    }
    
    originSocket = socketView;
    
    // Hook to the window's mouse events
    linkCreationDragStream = window.onMouseMove.listen(_handleLinkCreationDrag);
    linkCreationDragStopStream = window.onMouseUp.listen(_handleLinkCreationEnd);
    
    // Create a new link to draw from the source socket to the cursor position, till the mouse is released
    creationLink = new GraphLinkView(null, canvas);
    
    startDragPoint = new Point(e.page.x, e.page.y);
    
    dragging = true;
  }
  /** Handle the link creation process, while the pointer has not yet reached the destination */
  void _handleLinkCreationDrag(MouseEvent e) {
    if (!dragging || creationLink == null) return;
    // update the temporary link's path from the source to the cursor position
    Point source = originSocket.position;
    Point sourceDirection = originSocket.plugDirection;
    Point destinationDirection = new Point(-sourceDirection.x, -sourceDirection.y);
    Point mouseOffsetSinceStart = new Point(e.page.x - startDragPoint.x, e.page.y - startDragPoint.y);
    Point destination = new Point(source.x + mouseOffsetSinceStart.x, source.y + mouseOffsetSinceStart.y);

    creationLink.updateFromMetrics(source, sourceDirection, destination, destinationDirection, 0, 0);
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
    
    dragging = false;
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
  void _handleLinkCreationEndOnSocket(GraphSocketView socketView, MouseEvent e) {
    if (!dragging) return;
    dragging = false;
    
    if (creationLink != null) {
      creationLink.destroy();
      creationLink = null;
    }
  
    if (socketView == originSocket) {
      // Source and destination sockets are the same. ignore
      return;
    }

    _cancelGlobalMouseStream();
    
    // Check if we can create a link with this socket as the destination
    if (!socketView.socket.canAcceptIncomingLink(originSocket.socket)) {
      // This socket does not allow incoming nodes. Do not create a link
      return;
    }

    // Create a new link in the document
    final linkId = generateUid();
    final sourceNodeId = originSocket.nodeView.model.id;
    final sourceSocketId = originSocket.socket.id;
    final destNodeId = socketView.nodeView.model.id;
    final destSocketId = socketView.socket.id;
    canvas.createLink(linkId, sourceNodeId, sourceSocketId, destNodeId, destSocketId);
  }
}


