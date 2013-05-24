import 'dart:html';
import 'package:web_ui/web_ui.dart';

class ImagePreviewComponent extends WebComponent {
  static const String _classNameImage = "x-image-preview_preview";
  static const String _classNameLoading= "x-image-preview_loading";
  
  ImageElement image;
  Element loadingElement;
  
  String get src => image.src;
  set src(String value) {
    if (image.src == value) return;
    _setLoadingScreenVisible(true);
    image.src = value;
  }
  
  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {
    loadingElement = host.query(".$_classNameLoading"); 
    image = host.query(".$_classNameImage");
    image.onLoad.listen(_onImageLoadComplete);
  }

  void _onImageLoadComplete(Event e) {
    _setLoadingScreenVisible(false);
  }
  
  /** Shows / hides the loading screen */
  void _setLoadingScreenVisible(bool visible) {
    loadingElement.style.display = visible ? "block" : "none";
    image.style.display = !visible ? "block" : "none";
  }
}
