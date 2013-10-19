// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library grid_panel;

import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'column_definitions.dart';
import 'row_definitions.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'grid-panel';

/// Defines a grid for laying out elements.
///
/// A [GridPanel] is defined through the use of [RowDefinitions], and
/// [ColumnDefinitions] which specify the dimensions of the grid. The placement
/// of individual elements is done by setting data attributes specifying the
/// column and row that contains the element. This allows the positioning to be
/// specified in markup rather than CSS.
///
///     <!-- Definition of a 3x2 grid -->
///     <grid-panel>
///       <column-definitions>
///         <column-definition></column-definition>
///         <column-definition></column-definition>
///         <column-definition></column-definition>
///       </column-definitions>
///       <row-definitions>
///         <row-definition></row-definition>
///         <row-definition></row-definition>
///       </row-definitions>
///       <div data-column="0" data-row="0">0, 0</div>
///       <div data-column="1" data-row="0">1, 0</div>
///       <div data-column="2" data-row="0">2, 0</div>
///       <div data-column="0" data-row="1">0, 1</div>
///       <div data-column="1" data-row="1">1, 1</div>
///       <div data-column="2" data-row="1">2, 1</div>
///     </grid-panel>
///
/// Additionally the grid elements can span multiple rows and columns.
///
///     <!-- Definition of a 3x2 grid -->
///     <grid-panel>
///       <column-definitions>
///         <column-definition></column-definition>
///         <column-definition></column-definition>
///         <column-definition></column-definition>
///       </column-definitions>
///       <row-definitions>
///         <row-definition></row-definition>
///         <row-definition></row-definition>
///       </row-definitions>
///       <div data-column="0" data-row="0">A</div>
///       <div data-column="2" data-row="0" data-rowspan="2">B</div>
///       <div data-column="0" data-row="1" data-columnspan="2">C</div>
///     </grid-panel>
///
/// The [GridPanel] relies on the [CSS Grid Layout](http://dev.w3.org/csswg/css-grid/)
/// specification. Before using within an application verify that the feature
/// is [compatible](http://caniuse.com/css-grid) with the browsers being
/// supported.
///
/// Currently Internet Explorer is the only browser that supports the
/// specification. Chrome 31+ hides the implementation behind the Enable
/// Experimental Web Platform Features flag within chrome://flags.
@CustomTag(_tagName)
class GridPanel extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The [ColumnDefinitions] contained in the element.
  ColumnDefinitions _columns;
  /// The [RowDefinitions] contained in the element.
  RowDefinitions _rows;
  /// Observer for changes within the element.
  MutationObserver _observer;

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  void inserted() {
    super.inserted();

    _layoutColumns();
    _layoutRows();
    _layoutChildren();
  }

  void created() {
    super.created();

    // Observe changes to the host element.
    //
    // The row-definition elements are appended to the content area so using
    // the shadow dom will not result in a mutation.
    _observer = new MutationObserver(_onMutation);
    _observer.observe(host, childList: true, subtree: true);
  }

  //---------------------------------------------------------------------
  // Events
  //---------------------------------------------------------------------

  void onRowsChanged(CustomEvent event) {
    _layoutRows();
  }

  void onColumnsChanged(CustomEvent event) {
    _layoutColumns();
  }

  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    // \TODO take into account the mutation targets and choose accordingly
    _layoutColumns();
    _layoutRows();
    _layoutChildren();
  }

  //---------------------------------------------------------------------
  // Layout methods
  //---------------------------------------------------------------------

  /// Sets the layout for the columns.
  void _layoutColumns() {
    var columns = host.query(ColumnDefinitions.customTagName);
    var property = '';

    if (columns != null) {
      _columns = columns.xtag;

      for (var column in _columns.columns) {
        property += column.width + ' ';
      }
    } else {
      _columns = null;
    }

    // Set the style
    host.style.setProperty('grid-definition-columns', property);
  }

  /// Sets the layout for the rows.
  void _layoutRows() {
    var rows = host.query(RowDefinitions.customTagName);
    var property = '';

    if (rows != null) {
      _rows = rows.xtag;

      for (var row in _rows.rows) {
        property += row.height + ' ';
      }
    } else {
      _rows = null;
    }

    print(property);

    // Set the style
    host.style.setProperty('grid-definition-rows', property);
  }

  /// Lays out the child elements.
  void _layoutChildren() {
    for (var child in host.children) {
      var localName = child.localName;

      if ((localName != RowDefinitions.customTagName) && (localName != ColumnDefinitions.customTagName)) {
        _setGridPosition(child);
      }
    }
  }

  /// Sets the position of the [element] within the grid.
  ///
  /// Uses the attributes contained in the element to determine the styling
  /// required to position the grid.
  void _setGridPosition(Element element) {
    var attributes = element.attributes;
    var style = element.style;

    // Set the column
    var column = int.parse(attributes['data-column']) + 1;

    var columnSpan = attributes.containsKey('data-columnspan')
        ? int.parse(attributes['data-columnspan'])
        : 1;

    style.setProperty('grid-column', '$column / span $columnSpan');

    // Set the row
    var row = int.parse(attributes['data-row']) + 1;

    var rowSpan = attributes.containsKey('data-rowspan')
        ? int.parse(attributes['data-rowspan'])
        : 1;

    style.setProperty('grid-row', '$row / span $rowSpan');
  }
}
