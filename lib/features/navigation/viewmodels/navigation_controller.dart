import 'package:flutter/cupertino.dart';

class NavigationController extends ChangeNotifier{
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<String> menuItems = [
    "About",
    "Skills",
    "Projects",
    "Experience",
    "Contact"
  ];

  void selectIndex(int index)
  {
    _currentIndex = index;
    notifyListeners();
  }
}