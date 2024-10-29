import 'package:fitness_app/themes/themes.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // initially theme is light mode
  ThemeData _themeData = lightMode;

  // getter method to access theme from other parts of the code
  ThemeData get themeData => _themeData;

  // getter method to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

  // setter method to set new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle method for switching themes
  void toggleTheme() {
    if(_themeData == lightMode){
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}