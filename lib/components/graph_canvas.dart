library pixelate_diagram;

import 'package:polymer/polymer.dart';
import 'dart:svg';
import 'dart:html';
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

  @override
  void enteredView() {
    super.enteredView();
    svg = this.shadowRoot.querySelector("#diagram_svg");
    document = new GraphDocument(this);
    
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

  /** 
   * Creates a link view. 
   * Do NOT call this directly
   * Call document.createLink instead
   */
  GraphLinkView createLinkView(GraphLink link) {
    return new GraphLinkView(link, svg);
  }
  
  
}
