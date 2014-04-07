// Copyright (c) 2013-2014, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Customizable] mixin.
library pixelate_customizable;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
// \TODO This might be a bug in Dartium. Seems like querySelector should point to the class not the free function.
import 'dart:html' hide querySelector;

//---------------------------------------------------------------------
// Package libraries
//---------------------------------------------------------------------

import 'package:polymer/polymer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------



class _PropertyInfo {
  /// Whether the property has been overriden.
  bool overriden = false;
  /// The [Symbol] for the property.
  final Symbol name;
  /// The selector for overriding the default control.
  final String selector;
  /// The selector for the default control.
  final String defaultSelector;
  /// The callback to invoke.

  _PropertyInfo(this.name, this.selector, this.defaultSelector);
}

abstract class Customizable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  static const String hiddenClass = 'hidden';

  Stream<List<ChangeRecord>> get changes;
  ShadowRoot get shadowRoot;

  MutationObserver _observer;
  List<_PropertyInfo> _customizableProperties = new List<_PropertyInfo>();

  //---------------------------------------------------------------------
  // Initialization
  //---------------------------------------------------------------------

  /// Initializes the behavior.
  void initializeCustomizable() {
    if (_observer == null) {
      _observer = new MutationObserver(_onMutation);
      _observer.observe(this as Node, childList: true, subtree: true);

      changes.listen(_onPropertyChange);
    }
  }

  //---------------------------------------------------------------------
  // Element methods
  //---------------------------------------------------------------------

  Element querySelector(String selectors);

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  void customizeProperty(Symbol symbol, String selector, String defaultSelector) {
    var propertyInfo = new _PropertyInfo(symbol, selector, defaultSelector);

    _customizableProperties.add(propertyInfo);

    // Act as though a property change or mutation occurred.
    _modifyProperty(propertyInfo);
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Callback for when a mutation occurs.
  ///
  /// Used to determine when a property should be overriden.
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    for (var mutation in mutations) {
      // Check the target of the mutation
      var property = _findProperty(mutation.target);

      if (property == null) {
        // Check for the property being added
        property = _findPropertyInList(mutation.addedNodes);

        if (property == null) {
          // Check for the property being removed
          property = _findPropertyInList(mutation.removedNodes);
        }
      }

      if (property != null) {
        _modifyProperty(property);
      }
    }
  }

  _PropertyInfo _findProperty(Node node) {
    if (node is HtmlElement) {
      for (var property in _customizableProperties) {
        if (node.classes.contains(property.selector)) {
          return property;
        }
      }
    }

    return null;
  }

  _PropertyInfo _findPropertyInList(List<Node> nodes) {
    var property;

    for (var node in nodes) {
      property = _findProperty(node);

      if (property != null) {
        break;
      }
    }

    return property;
  }

  /// Callback for when an [Observable] property is changed.
  ///
  /// Used to determine when a property should be overriden.
  void _onPropertyChange(List<ChangeRecord> records) {
    for (var record in records) {
      if (record is PropertyChangeRecord) {
        for (var property in _customizableProperties) {
          if (record.name == property.name) {
            _modifyProperty(property);
          }
        }
      }
    }
  }

  /// Modifies the property.
  ///
  /// Determines if an override is currently present within the element. If so
  /// then the default is hidden, and the override shown in its place.
  void _modifyProperty(_PropertyInfo propertyInfo) {
    var overrideElement = querySelector('.' + propertyInfo.selector);
    var defaultElement = shadowRoot.querySelector('.' + propertyInfo.defaultSelector);

    var shouldOverride = overrideElement != null;

    if (propertyInfo.overriden != shouldOverride) {
      if (shouldOverride) {
        overrideElement.classes.remove(hiddenClass);
        defaultElement.classes.add(hiddenClass);
      } else {
        defaultElement.classes.remove(hiddenClass);
      }

      propertyInfo.overriden = shouldOverride;
    }
  }
}
