// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library grid_test;

import 'dart:async';
import 'dart:html';
import 'package:unittest/unittest.dart';
import 'package:pixelate/components/grid_panel/grid_panel.dart';
import 'package:pixelate/components/grid_panel/column_definition.dart';
import 'package:pixelate/components/grid_panel/column_definitions.dart';
import 'package:pixelate/components/grid_panel/row_definition.dart';
import 'package:pixelate/components/grid_panel/row_definitions.dart';

GridPanel createGrid(int columns, int rows) {
  var grid = new Element.tag(GridPanel.customTagName) as GridPanel;

  var columnDefinitions = new Element.tag(ColumnDefinitions.customTagName);

  for (var i = 0; i < columns; ++i) {
    columnDefinitions.append(new Element.tag(ColumnDefinition.customTagName));
  }

  var rowDefinitions = new Element.tag(RowDefinitions.customTagName);

  for (var i = 0; i < rows; ++i) {
    rowDefinitions.append(new Element.tag(RowDefinition.customTagName));
  }

  grid.append(columnDefinitions);
  grid.append(rowDefinitions);

  return grid;
}

void testSomething() {
  var testArea = querySelector('#test-area');

  var grid = createGrid(4, 6);

  testArea.append(grid);

  var timer = new Timer(new Duration(seconds: 60), expectAsync0(() {
    expect(1, 1);
  }));
}

void main() {
  group('Grid tests', () {

    test('Bleh', testSomething);
  });
}
