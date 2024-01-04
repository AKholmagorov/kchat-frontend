import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/user.dart';

class MessagesProvider with ChangeNotifier{

  List<User>? users;
  List<Chat>? chats;
  bool isLoaded = false; // using to prevent chat reopening from userProfile

  void UpdateUserList(List<User>? usersList) {
    users = usersList;
    notifyListeners(); // TODO: remove?
  }

  void UpdateChatsList(List<Chat>? chatsList) {
    chats = chatsList;
    this.isLoaded = true;
    notifyListeners();
  }

}
