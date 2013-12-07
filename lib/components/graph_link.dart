library pixelate_graph_link;
import 'dart:svg';
import 'dart:math' as math;
import 'package:pixelate/graph/graph.dart';

/** The graph link view for rendering the spline path on the svg document */
class GraphLinkView {
  /** The host SVG element */
  SvgElement svg;
  
  /** The link data model */
  GraphLink link;
  
  /** The spline path element */
  PathElement path = new PathElement();
  
  GraphLinkView(this.link, this.svg) {
    path.setAttribute("stroke", "red");
    path.setAttribute("stroke-width", "1.5");
    path.setAttribute("fill", "none");
    svg.children.add(path);
    update();
  }
  
  void update() {
    final startPosition = link.source.position;
    final endPosition = link.destination.position;
    final splineStrength = 100;
    final startControlPoint = new math.Point(startPosition.x + splineStrength, startPosition.y);
    final endControlPoint = new math.Point(endPosition.x - splineStrength, endPosition.y);
    
    final a = startPosition;
    final b = startControlPoint;
    final c = endControlPoint;
    final d = endPosition;
    path.setAttribute("d", "M ${a.x} ${a.y} C ${b.x} ${b.y} ${c.x} ${c.y} ${d.x} ${d.y}");
  }
  
  void destroy() {
    svg.children.remove(path);
  }
}
