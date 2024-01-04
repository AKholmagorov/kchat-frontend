import 'package:flutter/material.dart';
import '../models/user.dart';

class UsersProvider with ChangeNotifier {
  List<User>? users;

  User GetUserByID(int userID) {
    return users!.firstWhere((e) => e.id == userID);
  }

  void UploadUsers(List<User> users) {
    this.users = users;
    notifyListeners();
  }

  void AddNewUser(User user) {
    if (users != null) {
      users!.add(user);
    }
    else {
      users = [];
      users!.add(user);
    }

    notifyListeners();
  }

  int GetUsersCount() {
    return users!.length;
  }
}
