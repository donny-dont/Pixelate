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

  /** Determins how stiff/strong the spline is. Higher values would make it more stiffer */
  final splineStrength = 70;  // TODO: Make it observable in the view for external customization
  
  GraphLinkView(this.link, this.svg) {
    path.setAttribute("stroke", "#111");
    path.setAttribute("stroke-width", "1.5");
    path.setAttribute("fill", "none");
    svg.children.add(path);
    update();
  }
  
  void update() {
    final startPosition = link.source.position;
    final endPosition = link.destination.position;
    final startPlugDirection = link.source.plugDirection;
    final endPlugDirection = link.destination.plugDirection;
    final startControlPoint = new math.Point(
        startPosition.x + startPlugDirection.x * splineStrength, 
        startPosition.y + startPlugDirection.y * splineStrength);
    final endControlPoint = new math.Point(
        endPosition.x + endPlugDirection.x * splineStrength, 
        endPosition.y + endPlugDirection.y * splineStrength);
    
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
