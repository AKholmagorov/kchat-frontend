import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/main.dart';
import 'package:kchat/utils/data_converter.dart' as MyTimeConverter;
import 'package:provider/provider.dart';

class User {
  int id;
  String username;
  String? bio;
  String lastSeen;
  bool isOnline;
  Image avatar;

  bool isStandardAvatar = true;
  bool isStandardBio = true;

  @override
  bool operator ==(Object other) => other is User && other.id == id;

  void SetUsername(String username) {
    this.username = username;
    navigatorKey.currentContext!.read<CurrentUserProvider>().UpdateCurrentUserInfo(this);
  }

  void SetBio(String newBio) {
    this.bio = newBio.isEmpty ? null : newBio;
    this.isStandardBio = newBio.isEmpty ? true : false;

    navigatorKey.currentContext!.read<CurrentUserProvider>().UpdateCurrentUserInfo(this);
  }

  void SetAvatar(String? avatar) async {
   if (avatar != null) {
     this.avatar = Image.memory(base64Decode(avatar));
     this.isStandardAvatar = false;
   } else {
     this.avatar = Image(image: AssetImage('assets/images/default_avatar.png'));
     this.isStandardAvatar = true;
   }

   navigatorKey.currentContext!.read<CurrentUserProvider>().UpdateCurrentUserInfo(this);
  }

  User({
      required this.id,
      required this.username,
      required this.bio,
      required this.lastSeen,
      required this.isOnline,
      required this.avatar,
      this.isStandardAvatar = true,
      this.isStandardBio = true});

  User.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        username = jsonData['username'],
        avatar = jsonData['avatar'] != null
            // TODO: Should I write as String?
            ? Image.memory(base64Decode(jsonData['avatar'] as String))
            : Image(image: AssetImage('assets/images/default_avatar.png')),
        isStandardAvatar = jsonData['avatar'] == null ? true : false,
        isOnline = jsonData['isOnline'] == 1 ? true : false,
        lastSeen = MyTimeConverter.ConvertLastSeen(jsonData['lastSeen']),
        bio = jsonData['bio'] == null ? 'user has no bio yet.' : jsonData['bio'],
        isStandardBio = jsonData['bio'] == null ? true : false;
}
