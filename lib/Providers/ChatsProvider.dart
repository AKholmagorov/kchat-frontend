import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'package:collection/collection.dart';

class ChatsProvider with ChangeNotifier {
  List<User>? users;
  List<Chat> chats = [];
  bool isLoaded = false; // using to prevent chat reopening from userProfile

  void UpdateChatsState() {
    notifyListeners();
  }

  bool GetMsgStatus(int chatID, int msgID) {
    Chat chat = chats.firstWhere((e) => e.chatID == chatID);
    bool msgStatus = chat.messages.firstWhere((e) => e.msgID == msgID).isRead;

    return msgStatus;
  }

  Message? GetLastMsg(int chatID) {
    return chats.firstWhereOrNull((e) => e.chatID == chatID)?.lastMsg;
  }

  void UpdateUnreadMsgCount(int chatID, int unreadMsgCount) {
    chats.firstWhere((e) => e.chatID == chatID).UpdateUnreadMsgCount(unreadMsgCount);
    notifyListeners();
  }

  void MarkMyMessagesAsRead(int chatID) {
    chats.firstWhere((e) => e.chatID == chatID).MarkMyMessagesAsRead();
    notifyListeners();
  }

  // TODO: refactor
  void UpdateLastMsg(Message msg) {
    Chat chat = chats.firstWhere((e) => e.chatID == msg.chatID);
    chat.UpdateLastMsg(msg);
    chat.UpdateChatLastActivity(msg.date);
    notifyListeners();
  }

  void UploadMessageList(int chatID, List<Message> msgList) {
    chats.firstWhere((e) => e.chatID == chatID).UploadMessageList(msgList);
    notifyListeners();
  }

  void UpdateUserList(List<User>? usersList) {
    users = usersList;
    notifyListeners(); // TODO: remove?
  }

  void UploadChatList(List<Chat>? chatsList) {
    chats = chatsList != null ? chatsList : chats;
    this.isLoaded = true;
    notifyListeners();
  }

  int GetChatLength(int? chatID) {
    if (chatID != null)
      return chats.firstWhere((e) => e.chatID == chatID).messages.length;
    else
      return 0;
  }

  void AddNewChat(Chat chat) {
    chats.add(chat);
    notifyListeners();
  }

  void RemoveChat(Chat chat) {
    chats.remove(chat);
    notifyListeners();
  }

  void AddNewMessageToChat(Message msg) {
    Chat? chat = chats.firstWhereOrNull((e) => e.chatID == msg.chatID);

    if (chat != null) {
      chats.firstWhere((e) => e.chatID == msg.chatID).AddMessage(msg);
      notifyListeners();
    }
  }
}
