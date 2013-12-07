library pixelate_diagram_socket;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:pixelate/graph/graph.dart';

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
  
  var plugDirection = new Point(1, 0);
  
  /** The socket model */
  GraphSocket socket;

  var _onSocketChanged = new StreamController<GraphSocket>();
  Stream<GraphSocket> get onSocketChanged => _onSocketChanged.stream;
  
  ImageElement imageElement;
  GraphSocketView.created() : super.created() {}
  
  Point get size => new Point(imageElement.clientWidth, imageElement.clientHeight);
  
  @override
  void enteredView() {
    super.enteredView();
    imageElement = this.shadowRoot.querySelector("#socket_image");
    imageElement.onMouseEnter.listen((_) => imageElement.src = hoverImage);
    imageElement.onMouseLeave.listen((_) => imageElement.src = image);
    imageElement.onLoad.listen((_) => _onSocketChanged.add(this));
    imageElement.draggable = false;
    
    
    // Parse the plug direction
    if (dir != null) {
      var tokens = dir.split(",");
      if (tokens.length >= 2) {
        final x = double.parse(tokens[0]);
        final y = double.parse(tokens[1]);
        plugDirection = new Point(x, y);
      }
    }
  }
}

