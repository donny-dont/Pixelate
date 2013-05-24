// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:pixelate/attribute_helpers.dart';

///
class FileDropComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The class name for the drag highlight.
  static const _overClass = 'x-file-drop_over';
  /// The class name for the error highlight.
  static const _errorClass = 'x-file-drop_error';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The accepted file types.
  List<String> _types = new List<String>();
  /// The file input element.
  FileUploadInputElement  _fileInput;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The accepted file types.
  ///
  /// If empty then all file types are accepted.
  String get accept => _types.join(' ');
  set accept(String value) {
    _types = convertList(value);
  }

  //---------------------------------------------------------------------
  // Web-UI methods
  //---------------------------------------------------------------------

  /// Called when the component is inserted into the tree.
  ///
  /// Used to initialize the component.
  void inserted() {
    _fileInput = host.query('input');

    onDragEnter.listen((e) {
      classes.add(_overClass);
      print('Drag enter');
    });

    onDragLeave.listen((e) {
      classes.remove(_overClass);
      print('Drag leave');
      print(e);
    });

    onDragOver.listen((e) {
      e.preventDefault();
    });

    onDrop.listen((e) {
      classes.remove(_overClass);
      print('Drop');
      e.stopPropagation();
      e.preventDefault();
      print(e.dataTransfer.files);
      _onFileDrop(e.dataTransfer.files);
    });
  }

  void browse() {
    _fileInput.browse();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Callback for when files are dropped.
  void _onFileDrop(List<File> files) {
    int length = files.length;

    if (length > 0) {
      var validFiles;

      if (_types.isEmpty) {
        validFiles = files;
      } else {
        validFiles = new List<File>();

        for (int i = 0; i < length; ++i) {
          var file = files[i];
          var extension = _getExtension(file.name);

          if (_types.contains(extension)) {
            validFiles.add(file);
          }
        }
      }

      if (!validFiles.isEmpty) {
        print('NOT EMPTY');
        return;
      }
    }

    // Provide a visual indicator that the files are invalid
    classes.remove(_errorClass);

    // There needs to be a delay between removing and adding the
    // class otherwise the animation won't replay so just use a timeout
    Timer.run(() {
      classes.add(_errorClass);
    });
  }

  /// Determines the extension of the file.
  ///
  /// Uses the string from lastIndexOf('.') to the endpoint of the string as
  /// the extension type. If no extension is specified it returns the empty
  /// empty string.
  static String _getExtension(String name) {
    var split = name.split('.');
    int length = split.length;

    return (length != 1) ? split[length - 1] : '';
  }
}
