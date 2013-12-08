library pixelate_diagram;

import 'package:polymer/polymer.dart';
import 'dart:svg';
import 'dart:html';
import 'dart:math' as math;
import 'package:pixelate/components/graph_node.dart';
import 'package:pixelate/components/graph_link.dart';
import 'package:pixelate/utils/core_utils.dart';
import 'package:pixelate/graph/graph.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('px-graph-canvas')
class GraphCanvas extends PolymerElement implements IGraphCanvas {
  SvgElement svg;
  
  /** The initial document to load on the graph canvas */
  @published String src;

  /** The graph canvas id */
  String id = generateUid();
  
  /** The data model of this graph canvas */
  var document;

  GraphCanvas.created() : super.created();

  /** The outer content container that holds the SVG and Node dom elements */
  Element containerElement;
  
  /** The element that host the DOM for the nodes */
  Element nodeHostElement;
  
  @override
  void enteredView() {
    super.enteredView();
    svg = this.shadowRoot.querySelector("#diagram_svg");
    nodeHostElement = this.shadowRoot.querySelector("#diagram_dom");
    containerElement = this.shadowRoot.querySelector("#outer_content");
    containerElement.onContextMenu.listen((MouseEvent e) => e.preventDefault());
    
    document = new GraphDocument(this);
    
    // Load the initial graph document, if specified
    if (src != null && src.length > 0) {
      document.loadFromFile(src);
    }

  }
  
  math.Point get scrollOffset => new math.Point(containerElement.scrollLeft, containerElement.scrollTop);

  /** 
   * Creates a node view. 
   * Do NOT call this directly
   * Call document.createNode instead
   */
  Element createNodeView(String nodeId, String nodeType, num left, num top) {
    GraphNodeView nodeView = new Element.tag(nodeType);
    nodeView.style.position = "absolute";
    nodeView.style.left = "${left}px";
    nodeView.style.top = "${top}px";
    nodeView.onNodeMoved.listen(_onNodeMoved);
    this.children.add(nodeView);
    return nodeView;
  }

  /** 
   * Creates a link view. 
   * Do NOT call this directly
   * Call document.createLink instead
   */
  GraphLinkView createLinkView(GraphLink link) {
    return new GraphLinkView(link, svg);
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
