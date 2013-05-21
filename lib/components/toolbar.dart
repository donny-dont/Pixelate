import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'tool_button.dart';

class ToolbarComponent extends WebComponent {
  static const String _classNameToolBar = "x-toolbar_toolbar";
  static const String _selectorToolButtons = 'span[is=x-tool-button]';
  
  Element _elementToolbar;
  String _textAlignment = "left";
  String _orientation = "horizontal";
  
  String get alignment => _textAlignment;
  set alignment(String value) => _setTextAlignment(value);
  set orientation(String value) => _orientation = value;
  
  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {
    // Find all tool buttons and insert the appropriate CSS based on the orientation
    _elementToolbar = host.query(".$_classNameToolBar");
    _elementToolbar.style.textAlign = _textAlignment;
    
    // Set the orientation of all the child tool buttons
    var buttons = host.queryAll(_selectorToolButtons);
    buttons.forEach((button) {
      var toolButton = button.xtag as ToolButtonComponent;
      toolButton.orientation = _orientation;
    });
  }
  
  _setTextAlignment(String value) {
    _textAlignment = value;
  }
}
