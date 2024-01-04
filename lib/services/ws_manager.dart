import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/Providers/GroupsProvider.dart';
import 'package:kchat/Providers/KSpyProvider.dart';
import 'package:kchat/Providers/UsersProvider.dart';
import 'package:kchat/main.dart';
import 'package:kchat/models/chat.dart';
import 'package:kchat/models/group.dart';
import 'package:kchat/models/message.dart';
import 'package:kchat/models/new_group_data.dart';
import 'package:kchat/models/user.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/KChat.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/KChats.dart';
import 'package:kchat/services/k_jwt.dart';
import 'package:kchat/Providers/UserStatusProvider.dart';
import 'package:kchat/utils/KDataTypes.dart';
import 'package:kchat/utils/KSnackBar.dart';
import 'package:kchat/utils/fatalErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:collection/collection.dart';

class WS_Manager with ChangeNotifier {
  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  Completer<void> usersCompleter = Completer();
  Completer<void> groupsCompleter = Completer();
  Completer<void> chatsCompleter = Completer();
  Function(Chat)? onChatCreatedCallback;
  Function(int)? onNewMessageIDCallback;

  WS_Manager() {
    connect();
  }

  void LoadInitData() async {
    GetUsers();
    await usersCompleter.future;
    GetGroups();
    await groupsCompleter.future;
    GetChats();
    await chatsCompleter.future;
  }

  void startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _channel?.sink.add(jsonEncode({'req_type': 'heartbeat_msg'}));
    });
  }

  Future<void> connect() async {
    final url = 'ws://localhost:8080/ws?token=${await getToken()}';
    _channel = await WebSocketChannel.connect(Uri.parse(url));

    // Providers
    UsersProvider usersProvider = navigatorKey.currentContext!.read<
        UsersProvider>();
    UserStatusProvider userStatusProvider = navigatorKey.currentContext!.read<
        UserStatusProvider>();
    ChatsProvider chatsProvider = navigatorKey.currentContext!.read<
        ChatsProvider>();
    CurrentUserProvider currentUserProvider = navigatorKey.currentContext!.read<
        CurrentUserProvider>();
    GroupsProvider groupProvider = navigatorKey.currentContext!.read<
        GroupsProvider>();
    KSpyProvider kSpyProvider = navigatorKey.currentContext!.read<
        KSpyProvider>();

    LoadInitData();
    startHeartbeat();

    _channel?.stream.listen((message) {
      print('GOT MSG');
      var jsonData = jsonDecode(message);

      switch (jsonData['res_type']) {
        case 'get_users':
          print('GOT USERS');
          List<dynamic>? jsonUsers = jsonData['users'];
          usersProvider.users = jsonUsers!.map((jsonUser) => User.fromJson(jsonUser)).toList();

          // extract current user
          User curUser = usersProvider.users!.firstWhere((e) =>
          e.id == jsonData['currentUserID']);
          currentUserProvider.UpdateCurrentUserInfo(curUser);

          // send users list to other providers
          chatsProvider.UpdateUserList(usersProvider.users);
          userStatusProvider.UpdateUserList(usersProvider.users);
          usersCompleter.complete();

        case 'get_groups':
          print('GOT GROUPS');
          List<dynamic>? jsonGroups = jsonData['groups'];

          if (jsonGroups != null) {
            List<Group> groups = jsonGroups.map((jsonGroup) =>
                Group.fromJson(jsonGroup)).toList();
            groupProvider.UploadGroups(groups);
          }
          groupsCompleter.complete();

        case 'get_chats':
          print('GOT CHATS');
          List<dynamic>? jsonChats = jsonData['chats'];
          List<Chat>? chats = jsonChats
              ?.map((jsonChat) =>
              Chat.fromJson(jsonData: jsonChat, users: usersProvider.users))
              .toList();
          chatsProvider.UploadChatList(chats);
          chatsCompleter.complete();

        case 'user_status_updated':
          int userID = jsonData['id'];
          int? updatedLastSeen = jsonData['updatedLastSeen'];
          bool newStatus = jsonData['newStatus'];

          userStatusProvider.UpdateUserStatus(userID, newStatus, updatedLastSeen);

        case 'get_messages':
          int chatID = jsonData['chatID'];
          List<dynamic>? jsonMessages = jsonData['messages'];

          List<Message>? msgListFromJson = jsonMessages!.map((e) =>
              Message.fromJson(e)).toList();
          chatsProvider.UploadMessageList(chatID, msgListFromJson);

        case 'message_read':
          print('message_read');

        case 'chat_created':
          Chat chat = Chat.fromJson(jsonData: jsonData['chat'], users: usersProvider.users);
          chatsProvider.AddNewChat(chat);
          onChatCreatedCallback?.call(chat);

        case 'group_invitation':
          groupProvider.AddNewGroup(Group.fromJson(jsonData['group']));
          chatsProvider.AddNewChat(Chat.fromJson(jsonData: jsonData['chat']));

        case 'new_message':
          Message msg = Message.fromJson(jsonData['msg']);
          Chat chat = chatsProvider.chats.firstWhere((e) =>
          e.chatID == msg.chatID);
          chatsProvider.UpdateLastMsg(msg);
          chatsProvider.UpdateUnreadMsgCount(msg.chatID!, ++chat.unreadMsgCount);

          if (chat.isMessagesLoaded)
            chatsProvider.AddNewMessageToChat(msg);

        case 'messages_read':
          int chatID = jsonData['chatID'];
          Chat? chat = chatsProvider.chats.firstWhereOrNull((e) =>
          e.chatID == chatID);

          if (chat != null)
            chatsProvider.MarkMyMessagesAsRead(chatID);

        case 'message_sent':
          onNewMessageIDCallback?.call(jsonData['msgID']);

        case 'new_group_member':
          User newMember = usersProvider.users!.firstWhere((e) => e.id == jsonData['newMemberID']);
          groupProvider.AddNewMemberToGroup(jsonData['chatID'], newMember);

        case 'group_member_left':
          User removedMember = usersProvider.users!.firstWhere((e) => e.id == jsonData['userID']);

          // if kicked member is you
          if (removedMember.id == currentUserProvider.currentUser!.id) {
            // close group chat or profile if it has opened
            if (kSpyProvider.openedWidget is KChat &&
                (kSpyProvider.openedWidget as KChat).chat?.chatID == jsonData['chatID']) {
              Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => KChats()),
                    (Route<dynamic> route) => false,
              );

              if(jsonData['isForceKick'])
                ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(KSnackBar(text: 'You\'ve kicked from the group.'));
              else
                ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(KSnackBar(text: 'You\'ve left the group.'));

              /* TODO: if will be added chat deleting for personal chats
              there will a bug when user starts new dialog
              and then delete it (current if statement will not work)
              it happens cuz initChat will be null */
            }
            // give time to close screen and remove local data about group
            Future.delayed(Duration(milliseconds: 500), () {
              // remove group
              Group group = groupProvider.groups.firstWhere((e) => e.chatID == jsonData['chatID']);
              groupProvider.groups.remove(group);
              // remove chat
              Chat chat = chatsProvider.chats.firstWhere((e) => e.chatID == jsonData['chatID']);
              chatsProvider.RemoveChat(chat);
            });
          }
          else {
            groupProvider.RemoveMemberFromGroup(jsonData['chatID'], removedMember);
          }

        case 'new_user_signed_up':
          usersProvider.AddNewUser(User.fromJson(jsonData['user']));

        default:
          print('default: $message');
      }
    }, onDone: () {
      showFatalDialog('Info', 'Connection has closed.');
    });
  }

  void MarkMessagesAsRead(int chatID) {
    _channel?.sink.add(jsonEncode({'req_type': 'mark_messages_as_read', 'chatID': chatID}));
  }

  void GetUsers() {
    _channel?.sink.add(jsonEncode({'req_type': 'get_users'}));
    usersCompleter = Completer();
  }

  void GetGroups() {
    _channel?.sink.add(jsonEncode({'req_type': 'get_groups'}));
    groupsCompleter = Completer();
  }

  void GetChats() {
    _channel?.sink.add(jsonEncode({'req_type': 'get_chats'}));
    chatsCompleter = Completer();
  }

  void SendMessage(Message msg) {
    print("sndMsg");
    _channel?.sink.add(jsonEncode({'req_type': 'send_message', 'msg': msg.toJson()}));
  }

  void ChangeProfileData(String? newData, KDataTypes dataType) {
    _channel?.sink.add(jsonEncode({
      'req_type': 'change_profile_data',
      'data_type': '${dataType.name}',
      'data': newData
    }));
  }

  void AddUserToGroup(int chatID, int userID) {
    _channel?.sink.add(jsonEncode({'req_type': 'add_user_to_group', 'chatID': chatID, 'userID': userID}));
  }

  void RemoveUserFromGroup(int chatID, int userID, bool isForceKick) {
    _channel?.sink.add(jsonEncode({
      'req_type': 'remove_user_from_group',
      'chatID': chatID,
      'userID': userID,
      'isForceKick': isForceKick
    }));
  }

  void RemoveGroup(int chatID) {
    _channel?.sink.add(jsonEncode({'req_type': 'remove_group', 'chatID': chatID}));
  }

  void GetMessagesFromChat(int? chatID) {
    bool? isChatLoaded = navigatorKey.currentContext!
        .read<ChatsProvider>()
        .chats
        .firstWhereOrNull((e) => e.chatID == chatID)
        ?.isMessagesLoaded;

    if (chatID != null && !isChatLoaded!) {
      _channel?.sink.add(
          jsonEncode({'req_type': 'get_messages', 'chatID': chatID}));
    }
  }

  void CreateNewGroup(NewGroupData group) async {
    _channel?.sink.add(jsonEncode({'req_type': 'create_group', 'group': await group.toJson()}));
  }

  // TODO: think about refactoring of this function
  Future<Chat> CreateNewChat(int receiverID) {
    var completer = Completer<Chat>();
    onChatCreatedCallback = (Chat chat) {
      completer.complete(chat);
      onChatCreatedCallback = null;
    };
    _channel?.sink.add(jsonEncode({'req_type': 'create_chat', 'receiverID': receiverID}));

    return completer.future;
  }

  Future<int> GetSentMsgID() {
    var completer = Completer<int>();

    onNewMessageIDCallback = (int msgID) {
      completer.complete(msgID);
      onChatCreatedCallback = null;
    };

    return completer.future;
  }
}
