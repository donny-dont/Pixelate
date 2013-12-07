library pixelate_graph_node;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

/**
 * Polymer diagram node view
 */
@CustomTag('px-graph-node')
class GraphNodeView extends PolymerElement {
  /** The ID of the DOM element for dragging this node with the mouse */
  @published String dragHandleId;

  var _onNodeMoved = new StreamController<GraphNodeView>();
  Stream<GraphNodeView> get onNodeMoved => _onNodeMoved.stream;
  
  GraphNodeView.created() : super.created();
  
  void ready() {
    super.ready();
    var elementDragHandle = this.children.first.querySelector("#$dragHandleId");
    var elementDragBody = this.shadowRoot.querySelector("#node");
    
    // Enable dragging
    var draggable = new Draggable(elementDragHandle, elementDragBody);
    draggable.onDrag.listen((_) => _onNodeMoved.add(this));
  }
}


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

  /** Stream controller to fire drag events */
  var _onDrag = new StreamController<DragEvent>();
  
  /** Stream to dispatch drag events */
  Stream<DragEvent> get onDrag => _onDrag.stream;
  
  /** Drags [body] when the [handle] is dragged around with the mouse */ 
  Draggable(this.dragHandle, this.dragBody) {
    // Listen to global mouse events when the mouse is pressed on the handle
    dragHandle.onMouseDown.listen(_startDrag);
  }
  
  void _startDrag(MouseEvent e) {
    dragStream = window.onMouseMove.listen(_performDrag);
    dragStopStream = window.onMouseUp.listen(_stopDrag);
    mouseDragStart.x = e.page.x;
    mouseDragStart.y = e.page.y;
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
    final newX = bodyDragStart.x + mouseOffsetX;
    final newY = bodyDragStart.y + mouseOffsetY;
    dragBody.style.position = "absolute";
    dragBody.style.left = "${newX}px";
    dragBody.style.top = "${newY}px";
    _onDrag.add(new DragEvent(newX, newY));
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
