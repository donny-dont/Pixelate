library pixelate_graph_link;
import 'dart:svg';
import 'dart:html';
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
  
  GraphLinkView(this.link, this.svg) {
    path.setAttribute("stroke", strokeColor);
    path.setAttribute("stroke-width", "$lineThickness");
    path.setAttribute("fill", "none");
    
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
    update();
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
        link.document.deleteLink(link.id);
        return;
      }
    }
  }
  
  void update() {
    if (link == null) return;
    final startPosition = link.source.position;
    final endPosition = link.destination.position;
    final startPlugDirection = link.source.plugDirection;
    final endPlugDirection = link.destination.plugDirection;
    updateFromMetrics(startPosition, startPlugDirection, endPosition, endPlugDirection);
  }
  
  void updateFromMetrics(math.Point startPosition, math.Point startPlugDirection, 
                         math.Point endPosition, math.Point endPlugDirection) {
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
    final splineData = "M ${a.x} ${a.y} C ${b.x} ${b.y} ${c.x} ${c.y} ${d.x} ${d.y}";
    path.setAttribute("d", splineData);
    selectionPath.setAttribute("d", splineData);
  }
  
  void destroy() {
    svg.children.remove(path);
    svg.children.remove(selectionPath);
  }
}
