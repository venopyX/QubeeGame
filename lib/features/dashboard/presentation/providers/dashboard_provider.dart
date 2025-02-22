import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  int _counter = 0;
  bool _isLoading = false;

  int get counter => _counter;
  bool get isLoading => _isLoading;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}