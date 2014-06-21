library pixelate_diagram_socket;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:pixelate/graph/graph.dart';
import 'package:pixelate/utils/core_utils.dart';

/**
 * Graph node socket view
 */
@CustomTag('px-graph-socket')
class GraphSocketView extends PolymerElement {
  /** The image of the socket */
  @published String image = "";

  /** The image of the socket when the mouse is hovered over it */
  @published String hoverImage = "";

  /** The direction from which the link is plugged into this socket */
  @published String dir;

  /** The data type used by this socket */
  @published String data;

  /** The type of socket. valid values are "in", "out", "inout". Default is "inout" */
  @published String type = "inout";

  /** Flag to indicate if the socket allows multiple links */
  @published bool multiple = false;


  /**
   * The direction from which the links are connected from.
   * This is used to apply tension on the spline. This value is parsed by the dir attribute
   */
  var plugDirection = new Point(1, 0);

  /** The socket model */
  GraphSocket socket;

  /** the node view that hosts this socket */
  var nodeView;

  var _onSocketChanged = new StreamController<GraphSocket>.broadcast();
  Stream<GraphSocket> get onSocketChanged => _onSocketChanged.stream;

  ImageElement imageElement;
  GraphSocketView.created() : super.created() {}

  Point get size => new Point(imageElement.clientWidth, imageElement.clientHeight);

  @override
  void attached() {
    super.attached();
    imageElement = this.shadowRoot.querySelector("#socket_image");
    imageElement.onMouseEnter.listen((_) => imageElement.src = hoverImage);
    imageElement.onMouseLeave.listen((_) => imageElement.src = image);
    imageElement.onLoad.listen((_) => _onSocketChanged.add(socket));
    imageElement.draggable = false;


    // Parse the plug direction
    if (dir != null) {
      var tokens = dir.split(",");
      if (tokens.length >= 2) {
        final x = double.parse(tokens[0]);
        final y = double.parse(tokens[1]);

        // Normalize the direction
        var length = sqrt(x * x + y * y);
        if (length < 1e-6) length = 1;
        plugDirection = new Point(x / length, y / length);
      }
    }

    // Add default constraints
    {
      final constraints = [
         ConstraintFactory.create("inout", socket, {"multiple": multiple, "type": type}),
         ConstraintFactory.create("same_node", socket),
         ConstraintFactory.create("duplicate", socket),
      ];
      socket.constraints.addAll(constraints);
    }
  }

  Point getPositionOffset() {
    final offset = getElementOffset(this);
    return new Point(offset.x + size.x / 2, offset.y + size.y / 2);
  }

  Point get position {
    final nodePosition = nodeView.position;
    final socketOffset = getPositionOffset();
    return new Point(nodePosition.x + socketOffset.x, nodePosition.y + socketOffset.y);
  }

  num get radius {
    return clientWidth / 2.0;    // TODO: Avoid using clientWidth for performance reasons
  }
}
