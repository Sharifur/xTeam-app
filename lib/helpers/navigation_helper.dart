import 'package:flutter/cupertino.dart';

class NavigationHelper with ChangeNotifier {
  int currentIndex = 0;

  setNavIndex(value) {
    if (value == currentIndex) {
      return;
    }
    currentIndex = value;
    notifyListeners();
  }
}
