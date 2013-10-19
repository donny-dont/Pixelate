// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [RowDefinitions] class.
library row_definitions;

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
import 'row_definition.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Tag name for the class.
const String _tagName = 'row-definitions';

/// Defines the rows contained within a grid.
///
/// The rows are defined in the order they are inserted into the
/// [RowDefinitions] element.
///
///     <!-- The row definitions -->
///     <row-definitions>
///       <!-- The first row (value of 0) -->
///       <row-definition></row-definition>
///       <!-- The second row (value of 1) -->
///       <row-definition></row-definition>
///     </row-definitions>
///
/// All rows used within the [GridPanel] are required to be defined within the
/// [RowDefinitions].
@CustomTag(_tagName)
class RowDefinitions extends PolymerElement {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The name of the tag.
  static String get customTagName => _tagName;
  /// The event fired when the row definition is changed.
  static const String rowsChangedEvent = 'rowschange';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The [RowDefinition]s contained in the element.
  List<RowDefinition> _rows;
  /// An umodifiable view over the [RowDefinition]s contained in the element.
  UnmodifiableListView<RowDefinition> _rowsView;
  /// Observer for changes within the element.
  MutationObserver _observer;
  /// Listeners for the [RowDefinition]s contained in the element.
  ///
  /// Used to intercept changes to the height attribute of the [RowDefinition].
  List<StreamSubscription<List<ChangeRecord>>> _rowChangeSubscriptions;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Create an instance of the [RowDefinitions] class.
  RowDefinitions()
      : _rows = new List<RowDefinition>()
      , _rowChangeSubscriptions = new List<StreamSubscription<List<ChangeRecord>>>()
  {
    // Create the variables that can't be constructed in the initializer list
    _rowsView = new UnmodifiableListView<RowDefinition>(_rows);
    _observer = new MutationObserver(_onMutation);
  }

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The [RowDefinition]s contained in the element.
  UnmodifiableListView<RowDefinition> get rows => _rowsView;

  //---------------------------------------------------------------------
  // Polymer methods
  //---------------------------------------------------------------------

  void created() {
    super.created();

    // Observe changes to the host element.
    //
    // The row-definition elements are appended to the content area so using
    // the shadow dom will not result in a mutation.
    _observer = new MutationObserver(_onMutation);
    _observer.observe(host, childList: true, subtree: true);
  }

  void inserted() {
    super.inserted();

    _updateRows();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Callback for when a mutation occurs.
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    _updateRows();

    dispatchEvent(new CustomEvent(rowsChangedEvent));
  }

  /// Callback for when a change happens in the observer.
  void _onRowChanged(UnmodifiableListView<ChangeRecord> records) {
    // Notify that a change happened to a row.
    //
    // Only instances of the RowDefinition are being observed so this event can
    // be fired right away.
    dispatchEvent(new CustomEvent(rowsChangedEvent));
  }

  /// Update the row listing.
  void _updateRows() {
    var rowTags = host.queryAll(RowDefinition.customTagName);
    var rowTagCount = rowTags.length;

    // Position the tags
    for (var i = 0; i < rowTagCount; ++i) {
      var rowTag = rowTags[i] as Element;

      // See if the tag is already present
      var row = rowTag.xtag as RowDefinition;
      var indexOf = _rows.indexOf(row, i);

      if (indexOf != -1) {
        if (indexOf != i) {
          // Swap positioning with the current element
          _rows[indexOf] = _rows[i];
          _rows[i] = row;

          // Swap the subscription positions
          var temp = _rowChangeSubscriptions[indexOf];

          _rowChangeSubscriptions[indexOf] = _rowChangeSubscriptions[i];
          _rowChangeSubscriptions[i] = temp;
        }
      } else {
        // Insert the element at the index
        _rows.insert(i, row);

        // Subscribe to the events
        _rowChangeSubscriptions.insert(i, row.changes.listen(_onRowChanged));
      }
    }

    // Remove the missing elements
    var rowCount = _rows.length;

    for (var i = rowCount - 1; i >= rowCount; --i) {
      // Cancel the subscription
      _rowChangeSubscriptions[i].cancel();

      // Remove the values from the list
      _rows.removeAt(i);
      _rowChangeSubscriptions.removeAt(i);
    }
  }
}
