import 'dart:html';
import 'package:web_ui/web_ui.dart';

class ToolButtonComponent extends WebComponent {
  static const String _classNameButton = "x-tool-button_toolbar-item";
  static const String _classNameOrientationHorizontal = "x-tool-button_toolbar-item-horizontal";
  static const String _classNameOrientationVerticle = "x-tool-button_toolbar-item-verticle";

  Element _elementButton;
  String _iconName = "icon-file";
  String _orientation = "horizontal";

  String get icon => _iconName;
  set icon(String value) => _iconName = value;

  String get orientation => _orientation;
  set orientation(String value) {
    _orientation = value;
    if (_elementButton == null) return; 
    // TODO: use constant
    if (_orientation == "verticle") {
      _elementButton.classes.add(_classNameOrientationVerticle);
    } else {
      _elementButton.classes.add(_classNameOrientationHorizontal);
    }
  }

  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {
    _elementButton = host.query(".$_classNameButton");
  }
}

