import 'package:flutter/material.dart';

import 'package:bulletter/Config/definitions.dart' as definitions;

class CardProvider extends ChangeNotifier {
  void requestChangeAppState(definitions.EAppState newState) {
    definitions.BulletterSingleton.instance.appState = newState;
    notifyListeners();
  }
}
