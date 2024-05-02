import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isDarkModeOn = false;

  bool get isDarkModeOn => _isDarkModeOn;

  ThemeData getTheme() {
    return _isDarkModeOn ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);
  }

  void toggleTheme() {
    _isDarkModeOn = !_isDarkModeOn;
    notifyListeners();
  }
}