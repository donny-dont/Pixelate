// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'package:web_ui/web_ui.dart';
import 'package:pixelate/dom_utils.dart';


class SliderComponent extends WebComponent {
  /// The class name of the filled bar.
  static const String _fillClass = 'x-slider_fill';
  
  /** The element that displays the filled portion of the slider */
  Element _fill;
  
  /// Mouse move event subscription. This is attached to the window
  /// to receive mouse events outside the host element
  StreamSubscription<MouseEvent> _mouseMoveSubscription;

  /// Mouse up event subscription. This is attached to the window
  /// to receive mouse events outside the host element
  StreamSubscription<MouseEvent> _mouseUpSubscription;
  
  /// The minimum value of the slider
  @observable
  num _minValue = 0.0;
  num get minValue => _minValue;
  set minValue(val) {
    _minValue = _parseDynamicValue(val);
    _recalculateDimensions();
  }
  
  /// The maximum value of the slider
  @observable
  num _maxValue = 100.0;
  num get maxValue => _maxValue;
  set maxValue(val) {
    _maxValue = _parseDynamicValue(val);
    _recalculateDimensions();
  }
  
  @observable
  num _value = 50.0;
  /// The value of the slider
  num get value => _value;
  set value(v) => _setValue(_parseDynamicValue(v));

  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {
    _fill = host.query('.$_fillClass');
    host.onMouseDown.listen(_onMouseDown);

    // Listen for global mouse move events. resumed when the mouse is pressed on the host
    _mouseMoveSubscription = window.onMouseMove.listen(_onMouseMove);
    _mouseMoveSubscription.pause();
    
    // Listen for global mouse up events. resumed when the mouse is pressed on the host
    _mouseUpSubscription = window.onMouseUp.listen(_onMouseUp);
    _mouseUpSubscription.pause();
    
    _recalculateDimensions();
  }

  void _onMouseDown(MouseEvent e) {
    // Listen for global mouse events so we can still listen for them 
    // outside the host element
    _mouseMoveSubscription.resume();
    _mouseUpSubscription.resume();
  }
  
  void _onMouseMove(MouseEvent e) {
    var elementPageOffset = getPageOffset(host);
    final elementPageOffsetX = elementPageOffset[0];
    final elementPageOffsetY = elementPageOffset[1];
    
    // The mouse coordinates relative to the element
    var pointerX = e.pageX;
    
    // Get the start / end X-coordinates of the host element 
    final hostWidth = host.clientWidth;
    final start = elementPageOffsetX + window.scrollX;
    final end = start + hostWidth;
    
    // Clamp the relative mouse position to the start / end
    pointerX = max(start, min(end, pointerX));
    
    // Get pointerX normalized value from [0..1] relative to the element's bounds 
    final ratio = (pointerX - start) / (end - start);
    
    // Set the value of the slider
    value = minValue + (maxValue - minValue) * ratio;
  }

  void _onMouseUp(MouseEvent e) {
    // Dragging has stopped. Stop listening to global window mouse events
    _mouseMoveSubscription.pause();
    _mouseUpSubscription.pause();
  }

  /// Sets the value of the slider. Also updates the UI based on the value
  void _setValue(num val) {
    _value = val;
    if (_fill == null) return;
    final hostWidth = host.clientWidth;
    final ratio = (val - minValue) / (maxValue - minValue);
    final fillWidth = hostWidth * ratio;
    _fill.style.width = "${fillWidth}px";
  }
  
  /// Recalculates the UI element's dimensions
  void _recalculateDimensions() {
    value = value;
  }
  
  /// Parses a dynamic value into a num.  [val] could be a string or an num
  num _parseDynamicValue(val) {
    if (val is num) return val;
    return double.parse(val.toString());
  }
}