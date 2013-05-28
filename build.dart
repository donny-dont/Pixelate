import 'dart:io';
import 'package:web_ui/component_build.dart';

// Ref: http://www.dartlang.org/articles/dart-web-components/tools.html
main() {
  build(new Options().arguments, [
      'web/index.html', 
      'web/toolbar_demo.html',
      'web/toast_demo.html',
      'web/slider_demo.html' 
  ]);
}
