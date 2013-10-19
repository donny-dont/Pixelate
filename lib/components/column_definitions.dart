// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ColumnDefinitions] class.
library column_definitions;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:collection';
import 'dart:html';

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';
import 'column_definition.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'column-definitions';

/// Defines the columns contained within a grid.
///
/// The columns are defined in the order they are inserted into the
/// [ColumnDefinitions] element.
///
///     <!-- The column definitions -->
///     <column-definitions>
///       <!-- The first column (value of 0) -->
///       <column-definition></column-definition>
///       <!-- The second column (value of 1) -->
///       <column-definition></column-definition>
///     </column-definitions>
///
/// All columns used within the [GridPanel] are required to be defined within
/// the [ColumnDefinitions].
@CustomTag(_tagName)
class ColumnDefinitions extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;
  /// The event fired when the column definition is changed.
  static const String columnsChangedEvent = 'columnschange';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The [ColumnDefinition]s contained in the element.
  List<ColumnDefinition> _columns;
  /// An umodifiable view over the [ColumnDefinition]s contained in the element.
  UnmodifiableListView<ColumnDefinition> _columnsView;
  /// Observer for changes within the element.
  MutationObserver _observer;
  /// Listeners for the [ColumnDefinition]s contained in the element.
  ///
  /// Used to intercept changes to the height attribute of the [ColumnDefinition].
  List<StreamSubscription<List<ChangeRecord>>> _columnChangeSubscriptions;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [ColumnDefinitions] class.
  ColumnDefinitions()
      : _columns = new List<ColumnDefinition>()
      , _columnChangeSubscriptions = new List<StreamSubscription<List<ChangeRecord>>>()
  {
    // Create the variables that can't be constructed in the initializer list
    _columnsView = new UnmodifiableListView<ColumnDefinition>(_columns);
    _observer = new MutationObserver(_onMutation);
  }

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The [ColumnDefinition]s contained in the element.
  UnmodifiableListView<ColumnDefinition> get columns => _columnsView;

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  void created() {
    super.created();

    // Observe changes to the host element.
    //
    // The column-definition elements are appended to the content area so using
    // the shadow dom will not result in a mutation.
    _observer = new MutationObserver(_onMutation);
    _observer.observe(host, childList: true, subtree: true);
  }

  void inserted() {
    super.inserted();

    _updateColumns();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Callback for when a mutation occurs.
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    _updateColumns();

    dispatchEvent(new CustomEvent(columnsChangedEvent));
  }

  /// Callback for when a change happens in the observer.
  void _onColumnChanged(UnmodifiableListView<ChangeRecord> records) {
    // Notify that a change happened to a column.
    //
    // Only instances of the ColumnDefinition are being observed so this event
    // can be fired right away.
    dispatchEvent(new CustomEvent(columnsChangedEvent));
  }

  /// Update the column listing.
  void _updateColumns() {
    var columnTags = host.queryAll(ColumnDefinition.customTagName);
    var columnTagCount = columnTags.length;

    // Position the tags
    for (var i = 0; i < columnTagCount; ++i) {
      var columnTag = columnTags[i] as Element;

      // See if the tag is already present
      var column = columnTag.xtag as ColumnDefinition;
      var indexOf = _columns.indexOf(column, i);

      if (indexOf != -1) {
        if (indexOf != i) {
          // Swap positioning with the current element
          _columns[indexOf] = _columns[i];
          _columns[i] = column;

          // Swap the subscription positions
          var temp = _columnChangeSubscriptions[indexOf];

          _columnChangeSubscriptions[indexOf] = _columnChangeSubscriptions[i];
          _columnChangeSubscriptions[i] = temp;
        }
      } else {
        // Insert the element at the index
        _columns.insert(i, column);

        // Subscribe to the events
        _columnChangeSubscriptions.insert(i, column.changes.listen(_onColumnChanged));
      }
    }

    // Remove the missing elements
    var columnCount = _columns.length;

    for (var i = columnCount - 1; i >= columnCount; --i) {
      // Cancel the subscription
      _columnChangeSubscriptions[i].cancel();

      // Remove the values from the list
      _columns.removeAt(i);
      _columnChangeSubscriptions.removeAt(i);
    }
  }
}
