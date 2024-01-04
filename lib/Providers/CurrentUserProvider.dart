import 'package:flutter/material.dart';
import '../models/user.dart';

class CurrentUserProvider with ChangeNotifier {
  User? currentUser;

  void UpdateCurrentUserInfo(User user) {
    currentUser = user;
    notifyListeners();
  }
}