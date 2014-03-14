library pixelate_graph_link;
import 'dart:svg';
import 'dart:html';
import 'dart:math' as math;
import 'package:pixelate/graph/graph.dart';
import 'package:pixelate/utils/core_utils.dart';
import 'package:pixelate/components/graph_node.dart';

/** The graph link view for rendering the spline path on the svg document */
class GraphLinkView {
  /** The graph canvas that hosts this link */
  var canvas;
  
  /** The host SVG element */
  SvgElement get svg => canvas.svg;
  
  /** The link data model */
  GraphLink link;
  
  /** The spline path element */
  PathElement path = new PathElement();

  /** 
   * The selection spline path element which is thicker than the actual path
   * This path aids in selecting the actual path more easily. E.g. instead of 
   * forcing the user to carefully align the mouse cursor over a line of thickness
   * 1 pixel, an invisible path of a higher thickness, say 5-6 pixels is placed
   * along side the actual path and it's mouse over events are tracked
   */
  PathElement selectionPath = new PathElement();

  /** The color of the link */
  final String strokeColor = "#111";
  
  /** The color of the link on mouse over */
  final String hoverStrokeColor = "red";
  
  /** Determins how stiff/strong the spline is. Higher values would make it more stiffer */
  final splineStrength = 70;  // TODO: Make it observable in the view for external customization
  
  /** The stroke line thickness */
  final lineThickness = 1.5;
  
  /** The thickness of the invisibile selection area */
  final lineSelectionThickness = 8;
  
  GraphLinkView(this.link, this.canvas) {
    path.setAttribute("stroke", strokeColor);
    path.setAttribute("stroke-width", "$lineThickness");
    path.setAttribute("fill", "none");
    path.setAttribute("marker-end", "url(#head)");
    
    selectionPath.setAttribute("stroke", "transparent");
    selectionPath.setAttribute("stroke-width", "$lineSelectionThickness");
    selectionPath.setAttribute("fill", "none");
    
    // Listen for mouse events on the selection path, rather than the actual path
    // The selection path is usually thicker and aids in easier selection with the mouse
    selectionPath.onMouseOver.listen(_onMouseOver);
    selectionPath.onMouseOut.listen(_onMouseOut);
    selectionPath.onMouseDown.listen(_onMouseDown);

    svg.children.add(path);
    svg.children.add(selectionPath);
  }
  
  void _onMouseOver(e) {
    path.setAttribute("stroke", hoverStrokeColor);
  }
  
  void _onMouseOut(e) {
    path.setAttribute("stroke", strokeColor);
  }

  void _onMouseDown(MouseEvent e) {
    if (e.which == 3) { // Right click
      if (link != null) {
        // delete the link
        canvas.deleteLink(link.id);
        return;
      }
    }
  }
  
  void update(Map<String, GraphNodeView> nodeViews) {
    if (link == null) return;
    link.update();
    // Get the nodes references by this link
    final sourceNodeView = nodeViews[link.source.node.id];
    final destNodeView = nodeViews[link.destination.node.id];
    
    // Get the sockets within these nodes that are referenced by this link
    final sourceSocketView = sourceNodeView.socketViews[link.source.id];
    final destSocketView = destNodeView.socketViews[link.destination.id];
    assert(sourceSocketView != null && destSocketView != null);
    
    final startPosition = sourceSocketView.position;
    final endPosition = destSocketView.position;
    final startPlugDirection = sourceSocketView.plugDirection;
    final endPlugDirection = destSocketView.plugDirection;
    final startRadius = sourceSocketView.radius;
    final endRadius = destSocketView.radius;
    updateFromMetrics(startPosition, startPlugDirection, endPosition, endPlugDirection, startRadius, endRadius);
  }
  
  void updateFromMetrics(math.Point startPosition, math.Point startPlugDirection, 
                         math.Point endPosition, math.Point endPlugDirection, num startRadius, num endRadius) {
    final startControlPoint = new math.Point(
        startPosition.x + startPlugDirection.x * splineStrength, 
        startPosition.y + startPlugDirection.y * splineStrength);
    final endControlPoint = new math.Point(
        endPosition.x + endPlugDirection.x * splineStrength, 
        endPosition.y + endPlugDirection.y * splineStrength);
    
    final a = addPoint(startPosition, multiplyPointScalar(startPlugDirection, startRadius));
    final b = startControlPoint;
    final c = endControlPoint;
    final d = addPoint(endPosition, multiplyPointScalar(endPlugDirection, startRadius));
    final splineData = "M ${a.x} ${a.y} C ${b.x} ${b.y} ${c.x} ${c.y} ${d.x} ${d.y}";
    path.setAttribute("d", splineData);
    selectionPath.setAttribute("d", splineData);
  }
  
  void destroy() {
    if (link != null) {
      link.destroy();
    }
    svg.children.remove(path);
    svg.children.remove(selectionPath);
  }
}
