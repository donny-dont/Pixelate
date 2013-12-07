library pixelate_diagram;

import 'package:polymer/polymer.dart';
import 'dart:svg';
import 'dart:html';
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

  @override
  void ready() {
    super.ready();
    svg = this.shadowRoot.querySelector("#diagram_svg");
    document = new GraphDocument(this);
    
    // test path
    PathElement path = new PathElement();
    path.setAttribute("d", "M 100 100 C 300 100 300 400 500 400");
    path.setAttribute("stroke", "black");
    path.setAttribute("stroke-width", "1.5");
    path.setAttribute("fill", "none");
    svg.nodes.add(path);

    // Load the initial graph document, if specified
    if (src != null && src.length > 0) {
      document.loadFromFile(src);
    }
  }

  /** 
   * Creates a node view. 
   * Do NOT call this directly
   * Call document.createNode instead
   */
  Element createNodeView(String nodeId, String nodeType, num left, num top) {
    var nodeView = new Element.tag(nodeType);
    nodeView.style.position = "absolute";
    nodeView.style.left = "${left}px";
    nodeView.style.top = "${top}px";
    this.children.add(nodeView);
    return nodeView;
  }

}
