import 'package:flutter/material.dart';

class KSpyProvider with ChangeNotifier {

  Widget? openedWidget;

  void SetOpenedWidget(Widget? openedWidget) {
    this.openedWidget = openedWidget;
  }

  void ResetOpenedWidget() {
    this.openedWidget = null;
  }
}
