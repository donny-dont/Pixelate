part of pixelate_graph;

class ConstraintFactory {
  static GraphConstraint create(String type, GraphSocket socket, Map params) {
    if (type == "inout") {
      return new GraphConstraintInOut(socket, params);
    }
    else if (type == "same_node") {
      return new GraphConstraintSameNode(socket, params);
    }
    throw new StateError("Unsupported constraint type: $type");
  }
}