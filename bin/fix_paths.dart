// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:convert';
import 'dart:io';

//---------------------------------------------------------------------
// File I/O
//---------------------------------------------------------------------

String readTextFile(path) {
  var file = new File(path);

  return file.readAsStringSync(encoding: ASCII).trim();
}

void writeTextFile(String path, String contents) {
  var file = new File(path);

  file.writeAsStringSync(contents, encoding: ASCII);
}

//---------------------------------------------------------------------
// Fix pub transformer issues
//---------------------------------------------------------------------

List<Map> findIndexFiles(String path) {
  var directory = new Directory(path);
  var indexFiles = [];

  directory.listSync(recursive: true).forEach((file) {
    if ((file is File) && (file.path.endsWith('.html')) && (!file.path.contains('packages'))) {
      var path = file.path;
      var parent = file.parent;
      var up = 0;

      while (parent.path != directory.path) {
        parent = parent.parent;
        up++;
      }

      if (up > 0) {
        indexFiles.add({ 'path': path, 'up': up});
      }
    }
  });

  print(indexFiles);
  return indexFiles;
}

void fixIndexFiles(List<Map> indexFiles) {
  indexFiles.forEach((info) {
    var path = info['path'];
    var up = info['up'];
    var contents = readTextFile(path);

    // Get relative path
    var relativePath = '';

    print('Path $path Up $up');

    for (var i = 0; i < up; ++i) {
      relativePath += '../';
    }

    // Replace contents
    var fixThese = [
        'packages/shadow_dom/shadow_dom.debug.js',
        'packages/custom_element/custom-elements.debug.js',
        'packages/browser/interop.js'
    ];

    fixThese.forEach((fix) {
      contents = contents.replaceFirst(fix, '${relativePath}${fix}');
    });

    writeTextFile(path, contents);
  });
}

void main() {
  fixIndexFiles(findIndexFiles('../build/web'));
}
