import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';

class SliderComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------
  /// The id of the progress bar
  static const String _progressBarId = 'x-progress_bar';
  
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------
  /// Reference to the Progress bar web component
  Element _progressBar;

  /// Subscription to the mouse down stream 
  StreamSubscription _mouseDownListener;

  /// Subscription to the mouse up stream
  StreamSubscription _mouseUpListener;

  /// Subscription to the mouse move stream
  StreamSubscription _mouseMoveListener;
  
  /// Flag to track if the progress bar is being dragged
  bool _dragging = false;

  //---------------------------------------------------------------------
  // Web-UI methods
  //---------------------------------------------------------------------

  /// Called when the component is inserted into the tree.
  ///
  /// Used to initialize the component.
  void inserted() {
    // Get the child elements
    _progressBar = host.query('#$_progressBarId');
    _progressBar.onMouseUp.listen(_onMouseUp);
    _progressBar.onMouseDown.listen(_onMouseDown);
    _progressBar.onMouseMove.listen(_onMouseMove);
    
  }


  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------
  void _onMouseDown(MouseEvent e) {
    _dragging = true;
  }
  
  void _onMouseUp(MouseEvent e) {
    _dragging = false;
  }
  
  void _onMouseMove(MouseEvent e) {
    if (_dragging) {
      
    }
  }
  
  /// Called when the slider control is being dragged
  /// The [ratio] is from [0..1] and is calculated based on the mouse position 
  void _onDrag(num ratio) {
    
  }
}
