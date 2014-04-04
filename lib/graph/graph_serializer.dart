library pixelate_graph_serializer;

import 'dart:convert';
import 'dart:async';
import 'dart:html';
import 'package:pixelate/components/graph_canvas/graph_canvas.dart';


  /////////// Serialization. TODO: Move to another library /////////////////
class GraphSerializer {
  /** Load the document from a file path */
  Future loadFromFile(String path, GraphCanvas canvas) {
    var completer = new Completer();
    var request = HttpRequest.getString(path).then((String text) {
      loadFromJson(text, canvas);
      completer.complete(this);
    });
    return completer.future;
  }

  /** Load the document from json */
  void loadFromJson(String json, GraphCanvas canvas) {
    var data = JSON.decode(json);
    canvas.document.id = data["diagramId"];

    canvas.clear();

    // Create nodes
    var nodeInfoList = data["nodes"];
    for (var nodeInfo in nodeInfoList) {

      final nodeId = nodeInfo["nodeId"];
      final nodeType = nodeInfo["nodeType"];
      final left = nodeInfo["left"];
      final top = nodeInfo["top"];
      canvas.createNode(nodeId, nodeType, left, top);
    }

    // Create links
    var linkInfoList = data["links"];
    for (var linkInfo in linkInfoList) {
      final linkId = linkInfo["linkId"];
      final sourceNodeId = linkInfo["sourceNodeId"];
      final sourceSocketId = linkInfo["sourceSocketId"];
      final destNodeId = linkInfo["destNodeId"];
      final destSocketId = linkInfo["destSocketId"];
      canvas.createLink(linkId, sourceNodeId, sourceSocketId, destNodeId, destSocketId);
    }
  }

}

