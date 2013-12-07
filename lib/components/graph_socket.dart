library pixelate_diagram_socket;

import 'dart:html';
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
  
  /** The socket model */
  GraphSocket socket;
  
  ImageElement imageElement;
  GraphSocketView.created() : super.created() {}
  
  Point get size => new Point(imageElement.clientWidth, imageElement.clientHeight);
  
  @override
  void enteredView() {
    super.enteredView();
    imageElement = this.shadowRoot.querySelector("#socket_image");
    imageElement.onMouseEnter.listen((_) => imageElement.src = hoverImage);
    imageElement.onMouseLeave.listen((_) => imageElement.src = image);
  }
}

