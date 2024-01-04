import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kchat/main.dart';
import 'package:kchat/models/user.dart';
import 'package:provider/provider.dart';
import '../Providers/UsersProvider.dart';

class Group {
  int chatID; // group ID is the same as its chatID
  int adminID;
  List<User> members;
  String name;
  Image avatar;
  bool isStandardAvatar = true;

  Group(
      {required this.chatID,
      required this.name,
      required this.avatar,
      this.isStandardAvatar = true,
      required this.members,
      required this.adminID});

  factory Group.fromJson(Map<String, dynamic> jsonData) {
    List<User> members = getUsersInstanceByID(List<int>.from(
        jsonData['membersID'].map((item) => int.parse(item.toString()))));

    return Group(
      chatID: jsonData['chatID'],
      adminID: jsonData['adminID'],
      members: members,
      name: jsonData['name'],
      avatar: jsonData['avatar'] != null
        ? Image.memory(base64Decode(jsonData['avatar'] as String))
        : Image(image: AssetImage('assets/images/default_avatar.png')),
      isStandardAvatar: jsonData['avatar'] == null ? true : false,
    );
  }

  static List<User> getUsersInstanceByID(List<int> membersID) {
    List<User> groupMembers = [];
    List<User>? users = navigatorKey.currentContext!.read<UsersProvider>().users;

    groupMembers.addAll(users!.where((user) => membersID.contains(user.id)));
    return groupMembers;
  }
}
