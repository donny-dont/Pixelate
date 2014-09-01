// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library shared;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';
import 'package:dartdoc_viewer/components/main.dart';

final defaultSyntax = new _DefaultSyntaxWithEvents();

/// This is the cut off point between mobile and desktop in pixels.
// TODO(janicejl): Use pixel density rather than how many pixels. Look at:
// http://www.mobilexweb.com/blog/ipad-mini-detection-for-html5-user-agent
const int DESKTOP_SIZE_BOUNDARY = 1006;

MainElement get dartdocMain => _dartdocMain == null ?
    _dartdocMain = querySelector("#dartdoc-main") :
    _dartdocMain;

MainElement _dartdocMain;

/// Set to true if we want to use the behavior of what was formerly the
/// "useHistory" git branch. This format does not create links that are solely
/// after a hash ("#") but rather are part of the main URL. To prevent
/// round-tripping to the server every time the user clicks a link.
const bool useHistory = false;

// TODO(jmesserly): for now we disable polymer expressions
class _DefaultSyntaxWithEvents extends BindingDelegate with 
    PolymerEventBindings {
  prepareBinding(String path, name, node) {
    if (name.startsWith('on-')) {
      return prepareEventBinding(path, name, node);
    }
    return super.prepareBinding(path, name, node);
  }
}
