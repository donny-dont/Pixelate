// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library web.link;

import 'dart:html';
import 'package:dartdoc_viewer/item.dart';
import 'package:dartdoc_viewer/search.dart' show searchIndex;
import 'package:polymer/polymer.dart';
import 'package:dartdoc_viewer/location.dart';
import 'package:dartdoc_viewer/member.dart';

// TODO(jmesserly): just extend HtmlElement?
@CustomTag("dartdoc-link")
class LinkElement extends PolymerElement with ChangeNotifier  {
  @reflectable @published LinkableType get type => __$type; LinkableType __$type; @reflectable set type(LinkableType value) { __$type = notifyPropertyChange(#type, __$type, value); }

  LinkElement.created() : super.created();

  attached() {
    super.attached();
    searchIndex.onLoad(typeChanged);
  }

  void typeChanged() {
    this.children.clear();
    if (type == null) return;

    Element child;
    final location = type.loc.withoutAnchor;
    if (searchIndex.map.containsKey(location)) {
      child = new AnchorElement()
        ..href = locationPrefixed(type.loc.withAnchor)
        ..onClick.listen((event) => rerouteLink(event, null, event.target));
    } else {
      child = new Element.tag('i');
    }
    this.append(child..text = type.simpleType);
  }

  /// This is called from the template, so needs to be available
  /// as an instance method.
  void rerouteLink(event, detail, target) => routeLink(event, detail, target);
}
