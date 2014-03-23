// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [SelectionGroup] mixin.
library pixelate_selection_group;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:collection';
import 'dart:html' as Html;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:pixelate/selectable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates a behavior for a [PolymerElement] that makes it selectable with a mouse click
///
abstract class SelectionGroup {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The value of [selectedIndex] when nothing is selected.
  static const int none = -1;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Observer for changes within the element.
  Html.MutationObserver _observer;
  /// The currently selected index.
  ///
  /// Returns [none] if no elements are selected.
  int _selectedIndex = none;
  /// The list of selectable items.
  List<Selectable> _selectableItems = [];
  /// The list of selected items.
  List<Selectable> _selected = [];
  /// An immutable view over the selected items.
  UnmodifiableListView<Selectable> _selectedView;

  /// Whether multiple elements can be selected
  bool get multiple;
  set multiple(bool value);

  /// The selectors for the selectable items.
  String get selectableSelectors;

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  void initializeSelectionGroup() {
    // Create the view over the selected items
    _selectedView = new UnmodifiableListView<Selectable>(_selected);

    // Connect to the selection event
    on[Selectable.selectionChangedEvent].listen(_onSelection);

    // Get the selectable items
    _getSelectableItems();

    // Look for mutations in the DOM
    _observer = new Html.MutationObserver(_onMutation);
    _observer.observe(this as Html.Node, childList: true, subtree: true);
  }

  //---------------------------------------------------------------------
  // Element methods
  //---------------------------------------------------------------------

  Html.ElementList<dynamic> querySelectorAll(String selectors);
  Html.ElementEvents get on;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The index of the first currently selected item.
  ///
  /// When [multiple] is true then the setter will remove all existing
  /// selections. A call to [selectedItems] immediately afterward will return
  /// an array only containing a single item.
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    if (_selectableItems.length <= value) {
      throw new ArgumentError('Invalid index');
    }

    var selected = _selectableItems[_selectedIndex];

    // Update the index
    _selectedIndex = value;

    // Update the selected element list
    _clearSelections();
    _selected.add(selected);

    // Set the element as selected
    selected.selected = true;
  }

  /// The first of the currently selected items.
  ///
  /// When [multiple] is true then the setter will remove all existing
  /// selections. A call to [selectedItems] immediately afterward will return
  /// an array only containing a single item.
  Selectable get selectedItem => (_selectedIndex != none) ? _selected[0] : null;
  set selectedItem(Selectable value) {
    var indexOf = _selectableItems.indexOf(value);

    if (indexOf == -1) {
      throw new ArgumentError('Invalid element');
    }

    _selectedIndex = indexOf;

    // Update the selected element list
    _clearSelections();
    _selected.add(value);

    // Set the element as selected
    value.selected = true;
  }

  /// The currently selected items.
  UnmodifiableListView<Selectable> get selectedItems => _selectedView;

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  void multipleChanged(bool oldValue) {
    if ((!multiple) && (_selected.length > 1)) {
      selectedIndex = selectedIndex;
    }
  }

  /// Callback for when an item is selected.
  void _onSelection(Html.CustomEvent event) {
    var selectable = event.detail as Selectable;

    assert(_selectableItems.contains(selectable));

    if (selectable.selected) {
      if ((!multiple) && (_selected.length > 0)) {
        assert(_selected.length == 1);

        _selected[0].selected = false;
        _selected.clear();
      }

      _selected.add(selectable);
    } else {
     _selected.remove(selectable);
    }

    // Update the index of the selected element
    _updateSelectedIndex();
  }

  /// Callback for when a mutation occurs in the element.
  void _onMutation(List<Html.MutationRecord> mutations, Html.MutationObserver observer) {
    // \TODO take into account the mutation targets and choose accordingly
    _getSelectableItems();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Gets the currently selectable items within the group.
  void _getSelectableItems() {
    // Get the selectable items
    var selectableItems = this.querySelectorAll(selectableSelectors);

    _selectableItems.clear();

    selectableItems.forEach((value) {
      var selectable = value as Selectable;

      _selectableItems.add(selectable);
    });

    // Update the selected items
    _selected.removeWhere((value) => !_selectableItems.contains(value));

    // Get the index of the first selected item
    _updateSelectedIndex();
  }

  /// Determines what the selected index is.
  void _updateSelectedIndex() {
    _selectedIndex = (_selected.length != 0)
        ? _selectableItems.indexOf(_selected[0])
        : none;
  }

  /// Clears the currently selected items.
  void _clearSelections() {
    // Update the elements
    _selected.forEach((selection) {
      selection.selected = false;
    });

    // Clear the list
    _selected.clear();
  }
}
