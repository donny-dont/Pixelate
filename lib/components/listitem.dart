import 'dart:html';
import 'package:web_ui/web_ui.dart';

class ListItemComponent extends WebComponent {
  static const String classNameItem = "x-listitem_listitem";
  static const String classNameItemSelected = "x-listitem_listitem-selected";

  /** Data item for this list box item */
  var item;
  
  Element itemElement;
  
  bool _selected = false;
  bool get selected => _selected;
  set selected(bool value) {
    _selected = value;
    if (_selected) {
      itemElement.classes.add(classNameItemSelected);
    } else {
      itemElement.classes.remove(classNameItemSelected);
    }
  }
  
  ListItemComponent();

  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {
    itemElement = host.query(".$classNameItem");
  }

}
