library pixelate_graph_node;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:pixelate/utils/core_utils.dart';
import 'package:pixelate/graph/graph.dart';
import 'package:pixelate/components/graph_canvas/graph_socket.dart';
import 'package:pixelate/components/graph_canvas/graph_canvas.dart';

/**
 * Polymer diagram node view
 */
@CustomTag('px-graph-node')
class GraphNodeView extends PolymerElement {
  /** The ID of the DOM element for dragging this node with the mouse */
  @published String dragHandleId;

  /** The data model of this node. This is will be set by the canvas after creation of this object */
  GraphNode _model;
  GraphNode get model => _model;
  set model(GraphNode value) {
    _model = value;
    _rebuildSockets();
  }

  /** A reference to the graph canvas. Will be set by the view on this object creation */
  GraphCanvas canvas;

  var _onNodeMoved = new StreamController<GraphNodeView>.broadcast();
  Stream<GraphNodeView> get onNodeMoved => _onNodeMoved.stream;

  GraphNodeView.created() : super.created();

  var _onMoved = new StreamController<GraphNodeEvent>();
  Stream<GraphNodeEvent> get onMoved => _onMoved.stream;

  /** The position of the node relative to the parent (graph canvas) */
  Point get position => getElementPosition(this);


  /** List of sockets views hosted by this node view, mapped by their ids */
  var _socketViews = new Map<String, GraphSocketView>();
  Map<String, GraphSocketView> get socketViews => _socketViews;

  @override
  void attached() {
    super.attached();

    // Listen to node drag events
    onNodeMoved.listen((e) => _onMoved.add(new GraphNodeEvent(this)));
  }

  /**
   * Called when the node view is about to be destroyed.
   * Do not call this directly. Call GraphCanvas.destroyNode instead
   */
  void destroy() {
   model.destroy();
  }

  void _rebuildSockets() {
    // grab all the sockets from the DOM and register them with the node model
    var socketViews = shadowRoot.querySelectorAll('px-graph-socket');
    socketViews.addAll(querySelectorAll('px-graph-socket'));

    for (GraphSocketView socketView in socketViews) {
      GraphSocket socket = model.createSocket(socketView.id);
      socketView.socket = socket;
      socketView.nodeView = this;
      _socketViews[socket.id] = socketView;
    }
  }

  void enableDragging(String handleId) {
    final dragHandle = findChildElementById(this, handleId);
    final dragBody = this;
    var draggable = new Draggable(dragHandle, dragBody, _getScrollOffset);
    draggable.onDrag.listen((_) => _onNodeMoved.add(this));

  }

  /** Get the scroll offset of the canvas */
  Point _getScrollOffset() => (canvas != null) ? canvas.scrollOffset : new Point(0, 0);
}

typedef Point ScrollOffsetProvider();

// TODO: Move this to a utility class as part of the core library
/** Allows the user to drag a dom element with the mouse */
class Draggable {
  /** The DOM element used for dragging the body */
  Element dragHandle;

  /** The body that would be dragged when the handle is dragged by the mouse */
  Element dragBody;

  /** The window mouse move stream active during a drag operation */
  var dragStream, dragStopStream;

  /** The coordinates of the mouse when the drag started, relative to the page */
  var mouseDragStart = new Point2();

  /** The coordinates of the body when the drag started */
  var bodyDragStart = new Point2();

  /** The scroll position when the drag started */
  var scrollDragStart = new Point2();

  /** Stream controller to fire drag events */
  var _onDrag = new StreamController<DragEvent>();

  /** Stream to dispatch drag events */
  Stream<DragEvent> get onDrag => _onDrag.stream;

  /** Provides the scroll offset of the parent element that hosts the element being dragged */
  ScrollOffsetProvider scrollOffsetProvider;

  /** Drags [body] when the [handle] is dragged around with the mouse */
  Draggable(this.dragHandle, this.dragBody, [this.scrollOffsetProvider]) {
    // Listen to global mouse events when the mouse is pressed on the handle
    dragHandle.onMouseDown.listen(_startDrag);
  }

  void _startDrag(MouseEvent e) {
    dragStream = window.onMouseMove.listen(_performDrag);
    dragStopStream = window.onMouseUp.listen(_stopDrag);
    mouseDragStart.x = e.page.x;
    mouseDragStart.y = e.page.y;
    scrollDragStart = _getScrollOffset();
    bodyDragStart.x = _parsePixel(dragBody.style.left, dragBody.client.left);
    bodyDragStart.y = _parsePixel(dragBody.style.top, dragBody.client.top);
  }

  void _stopDrag(MouseEvent e) {
    if (dragStream != null) {
      dragStream.cancel();
      dragStream = null;
    }
    if (dragStopStream != null) {
      dragStopStream.cancel();
      dragStopStream = null;
    }
  }

  void _performDrag(MouseEvent e) {
    final mouseOffsetX = e.page.x - mouseDragStart.x;
    final mouseOffsetY = e.page.y - mouseDragStart.y;
    final currentScrollOffset = _getScrollOffset();
    final scrollOffsetX = currentScrollOffset.x - scrollDragStart.x;
    final scrollOffsetY = currentScrollOffset.y - scrollDragStart.y;
    final newX = bodyDragStart.x + mouseOffsetX + scrollOffsetX;
    final newY = bodyDragStart.y + mouseOffsetY + scrollOffsetY;
    dragBody.style.position = "absolute";
    dragBody.style.left = "${newX}px";
    dragBody.style.top = "${newY}px";
    _onDrag.add(new DragEvent(newX, newY));
  }

  Point _getScrollOffset() {
    if (this.scrollOffsetProvider != null) {
      return scrollOffsetProvider();
    }
    return new Point(0, 0);
  }

  /** Parses the string "Npx" to an integer N */
  num _parsePixel(String text, [int defaultValue = 0]) {
    if (text == null || text.length == 0) return defaultValue;
    if (!text.endsWith("px")) return defaultValue;
    return int.parse(text.replaceAll("px", ""));
  }
}

class DragEvent {
  num elementX;
  num elementY;
  DragEvent(this.elementX, this.elementY);
}

class Point2 { num x, y; }


/** Node event object passed as parameter when firing various node events */
class GraphNodeEvent {
  GraphNodeView nodeView;
  GraphNodeEvent(this.nodeView);
}

