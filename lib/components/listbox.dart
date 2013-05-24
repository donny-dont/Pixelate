import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';

class ListBoxComponent extends WebComponent {
  List items = [];
  static const String classNameItem = "listitem";
  static const String classNameItemSelected = "listitem-selected";
  
  /** Stream controller for triggering selection changed event */
  StreamController<ListBoxEvent> _onSelectionChangedController;
  
  /** Selection changed event stream */
  Stream<ListBoxEvent> get onSelectionChanged => _onSelectionChangedController.stream;
  
  int _selectedIndex = -1;
  var _selectedItem;
  get selectedItem => _selectedItem;
  
  /** 
   * Sets the selected item on the list.  If the value does not belong to any child
   * list, then no items in the listbox are selected.  [value] can be null
   */
  set selectedItem(value) {
    if (value == _selectedItem) return;
    _setSelectedItem(value);
  }
  
  ListBoxComponent() {
    _onSelectionChangedController = new StreamController<ListBoxEvent>();
  }
  
  /**
   * Fires when a child list item is clicked. Fired from the on click
   * handler registered in the html template.  [item] is the data object
   * associated with the listitem. 
   */
  onItemClicked(item) {
    _setSelectedItem(item);
  }
  
  /**
   * Iterates through all the items in the list and
   * updates the selection state of the items
   * [item] is the data object associated with the listitem. 
   * If [item] does not belong in any of the list items,
   * then no items are selected. A null can be passed to [item]
   * to deselect all list items
   */
  void _setSelectedItem(item) {
    int index = 0;
    host.queryAll("li").forEach((childElement) {
      var listItemComponent = childElement.xtag;
      var itemElement = listItemComponent.item;
      
      // Check if the data item belongs to this list item element
      bool matches = (item == itemElement);
      listItemComponent.selected = matches;
      
      if (matches) {
        _selectedItem = item;
        _selectedIndex = index;
        
        // Raise a selection changed event
        _onSelectionChangedController.sink.add(new ListBoxEvent(_selectedIndex, _selectedItem));
      }

      index++;
    });
  }
}


class ListBoxEvent {
  int index;
  var item;
  ListBoxEvent(this.index, this.item);
}