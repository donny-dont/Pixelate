import 'package:polymer/polymer.dart';
import 'dart:svg';

/**
 * A Polymer click counter element.
 */
@CustomTag('px-diagram')
class DiagramView extends PolymerElement {
  SvgElement svg;
  
  DiagramView.created() : super.created() {
  }
  
  @override
  void ready() {
    super.ready();
    svg = this.shadowRoot.querySelector("#diagram_svg");
    
    // test path
    PathElement path = new PathElement();
    path.setAttribute("d", "M 100 100 C 300 100 300 400 500 400");
    path.setAttribute("stroke", "black");
    path.setAttribute("stroke-width", "1.5");
    path.setAttribute("fill", "none");
    svg.nodes.add(path);
  }
  
}

