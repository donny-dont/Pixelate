import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';

class ToastComponent extends WebComponent {
  static const String _classNameHide = "x-toast_content-invisible";
  static const String _classNameContent = "x-toast_content";
  Element elementContent;
  
  /** 
   * A toast tracking id tracks the timeout callback and makes sure that 
   * the scheduled hide callback is executed only if no other new toast operations
   * were initiated during the wait.   For e.g., If a toast is requested
   * for 5 seconds, a future hide callback is registered immediately to execute
   * after 5 seconds.  If on the 4th second, another Toast request is recieved,
   * which replaces the original message,  the hide callback of the previous message
   * would exeucte after one second and hide this new message within a second.
   * The tracking id avoid this scenario
   */
  int _toastTrackingId = 0;
  
  /** The message to display in the toast */
  String message = "";
  
  /** The optional icon to display */
  String icon;
  
  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {
    elementContent = host.query(".$_classNameContent");
  }
  
  /** 
   * Shows a toast for [duration] seconds
   * Set the duration to 0 to show the message indefinitely 
   */
  void show(String message, {num duration, String icon}) {
    this.message = message;
    if (duration == null) { 
      duration = 5; 
    }
    
    this.icon = icon;
    
    // TODO: Change to observers
    dispatch();
    
    _setVisible(true);
    
    // Increment the tracking id to invalidate any pending scheduled hide requests for 
    // previous show calls
    _toastTrackingId++;
    
    // Create a hide timeout callback only if duration is specified
    if (duration > 0) {
      var originalToastId = _toastTrackingId;
      new Future.delayed(new Duration(seconds: duration), () {
        if (originalToastId == _toastTrackingId) {
          // No new show requests were initiated during the timeout delay. 
          // Hide the toast
          hide();
        }
      });
    }
  }
  
  /** Hides a toast  */
  hide() {
    _setVisible(false);
  }
  
  void _setVisible(bool visible) {
    if (visible) {
      elementContent.classes.remove(_classNameHide);
    } else {
      elementContent.classes.add(_classNameHide);
    }
  }
}
