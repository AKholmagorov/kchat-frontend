import 'package:flutter/material.dart';
import 'package:kchat/models/group.dart';
import '../models/user.dart';

class GroupsProvider with ChangeNotifier {
  List<Group> groups = [];

  void UploadGroups(List<Group> groups) {
    this.groups = groups;
  }

  void AddNewGroup(Group group) {
    groups.add(group);
    notifyListeners();
  }

  void AddNewMemberToGroup(int chatID, User user) {
    groups.firstWhere((e) => e.chatID == chatID).members.add(user);
    notifyListeners();
  }

  void RemoveMemberFromGroup(int chatID, User user) {
    groups.firstWhere((e) => e.chatID == chatID).members.removeWhere((e) => e.id == user.id);
    notifyListeners();
  }

  int GetMembersCount(int groupID) {
    return groups.firstWhere((e) => e.chatID == groupID).members.length;
  }
}
