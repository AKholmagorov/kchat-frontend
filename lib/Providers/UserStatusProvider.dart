import 'package:flutter/material.dart';
import 'package:kchat/utils/data_converter.dart';
import '../models/user.dart';

class UserStatusProvider with ChangeNotifier {
  List<User>? users;

  void UpdateUserList(List<User>? usersList) {
    users = usersList;
    notifyListeners();
  }

  void UpdateUserStatus(int userID, bool newStatus, int? updatedLastSeen) {
    if (users != null) {
      User user = users!.firstWhere((element) => element.id == userID);

      user.isOnline = newStatus;
      if (updatedLastSeen != null)
        user.lastSeen = ConvertLastSeen(updatedLastSeen).toString();

      notifyListeners();
    }
  }

  User GetUser(int userID) {
    return users!.firstWhere((element) => element.id == userID);
  }
}
