import 'package:flutter/material.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/Providers/GroupsProvider.dart';
import 'package:kchat/main.dart';
import 'package:kchat/models/user.dart';
import 'package:provider/provider.dart';
import 'message.dart';

class Chat {
  int chatID;
  int? receiverID;        // only for personal chats
  int unreadMsgCount = 0;
  int lastActivity = 0;   // timestamp
  bool isPersonal;
  Message? lastMsg;
  String chatName;
  Image chatAvatar;
  List<Message> messages = [];

  bool isMessagesLoaded = false;

  void MarkMyMessagesAsRead() {
    User? currentUser = navigatorKey.currentContext!
        .read<CurrentUserProvider>()
        .currentUser;

    // mark messages as read till reach first of already read
    if (currentUser != null) {
      for (int i = messages.length - 1; i >= 0; i--) {
        if (!messages[i].isRead && messages[i].senderID == currentUser.id)
          messages[i].isRead = true;
        // this else if protect from situation
        // when users sent their messages together
        // and one of senders won't mark his msg as read
        else if (messages[i].senderID != currentUser.id)
          continue;
        else
          break;
      }
    }
  }

  void UpdateChatLastActivity(int newLastActivityValue) {
    this.lastActivity = newLastActivityValue;
  }

  void UpdateUnreadMsgCount(int unreadMsgCount) {
    this.unreadMsgCount = unreadMsgCount;
  }

  void UpdateLastMsg(Message lastMsg) {
    this.lastMsg = lastMsg;
  }

  void UploadMessageList(List<Message> msgList) {
    this.messages = msgList;
    isMessagesLoaded = true;
  }

  List<Message>? GetMessageList() {
    return messages;
  }

  void AddMessage(Message msg) {
    messages.add(msg);
    isMessagesLoaded = true;
  }

  Chat(this.chatID, this.chatName, this.lastMsg, this.chatAvatar,
      this.isPersonal, this.receiverID, this.messages);

  Chat.fromJson({required Map<String, dynamic> jsonData, List<User>? users})
      : chatID = jsonData['chatID'],
        receiverID = jsonData['receiverID'],
        unreadMsgCount = jsonData['unreadMsgCount'],
        isPersonal = jsonData['isPersonal'] == 1 ? true : false,
        lastMsg = jsonData['lastMsg'] != null ? Message.fromJson(jsonData['lastMsg']) : null,
        lastActivity = jsonData['lastActivity'],
        chatName = jsonData['isPersonal'] == 1
          ? users!
            .firstWhere((element) => element.id == jsonData['receiverID'])
            .username
          : navigatorKey.currentContext!.read<GroupsProvider>().groups.firstWhere((e) => e.chatID == jsonData['chatID']).name,
        chatAvatar = jsonData['isPersonal'] == 1
          ? users!
            .firstWhere((element) => element.id == jsonData['receiverID'])
            .avatar
          : navigatorKey.currentContext!.read<GroupsProvider>().groups.firstWhere((e) => e.chatID == jsonData['chatID']).avatar;
}
