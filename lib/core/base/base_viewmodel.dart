import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error }

class BaseViewModel extends ChangeNotifier {
  ViewState state = ViewState.idle;

  String errorMessage = "";

  void setLoading() {
    state = ViewState.loading;

    notifyListeners();
  }

  void setSuccess() {
    state = ViewState.success;

    notifyListeners();
  }

  void setError(String message) {
    errorMessage = message;

    state = ViewState.error;

    notifyListeners();
  }
}
