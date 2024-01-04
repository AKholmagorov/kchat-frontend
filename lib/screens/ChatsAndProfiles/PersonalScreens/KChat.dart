import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/Providers/GroupsProvider.dart';
import 'package:kchat/Providers/KSpyProvider.dart';
import 'package:kchat/main.dart';
import 'package:kchat/models/message.dart';
import 'package:kchat/services/ws_manager.dart';
import 'package:kchat/views/message_view.dart';
import 'package:kchat/widgets/GroupCardMini.dart';
import 'package:kchat/widgets/KMessageField.dart';
import 'package:kchat/widgets/UserCardMini.dart';
import 'package:provider/provider.dart';
import '../../../models/chat.dart';
import '../../../models/user.dart';

class KChat extends StatefulWidget {
  KChat({super.key, required this.chat, this.receiverProfile});

  final Chat? chat;
  final User? receiverProfile;

  @override
  State<KChat> createState() => _KChatState(chat);
}

class _KChatState extends State<KChat> {
  _KChatState(this.chat);

  Chat? chat;

  @override
  void initState() {
    super.initState();
    context.read<KSpyProvider>().SetOpenedWidget(widget);
  }

  @override
  void dispose() {
    navigatorKey.currentContext!.read<KSpyProvider>().ResetOpenedWidget();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    bool showExtraDataInMsg;

    if (chat != null && !chat!.isPersonal)
      showExtraDataInMsg = true;
    else
      showExtraDataInMsg = false;

    // chatID can be null if users hadn't messaged yet.
    // after one of them sent a message,
    // new chat will be created and chatID need to be updated.
    // otherwise user need to reopen Chat to see messages.
    int? getActualChatID() {
      return chat?.chatID;
    }

    // *** Load messages from opened chat if exists ***
    context.read<WS_Manager>().GetMessagesFromChat(chat?.chatID);

    Future<void> SendMessage() async {
      String msgText = _controller.text;
      _controller.clear();

      ChatsProvider chatsProvider = context.read<ChatsProvider>();
      if (chat == null) {
        // if both users have opened an empty chat with each other,
        // after sending messages they will create 2 difference chats.
        // the code below solve this problem.
        chat = chatsProvider.chats.firstWhereOrNull((e) => e.receiverID == widget.receiverProfile!.id);

        if (chat == null) {
          chat = await context.read<WS_Manager>().CreateNewChat(widget.receiverProfile!.id);
        }
        else {
          context.read<WS_Manager>().GetMessagesFromChat(chat!.chatID);
        }
      }

      int senderID = context.read<CurrentUserProvider>().currentUser!.id;
      Message msg = Message(text: msgText, chatID: chat!.chatID, senderID: senderID);
      context.read<WS_Manager>().SendMessage(msg);
      msg.msgID = await context.read<WS_Manager>().GetSentMsgID();
      chatsProvider.AddNewMessageToChat(msg);
      chatsProvider.UpdateLastMsg(msg);

      _controller.clear();
    }

    return Scaffold(
      appBar: AppBar(
        // *** Opponent's profile ***
        title: widget.receiverProfile != null // if receiver is null this is a group
                  ? UserCardMini(user: widget.receiverProfile!, avatarRadius: 20, isChatReopen: true)
                  : GroupCardMini(group: context.read<GroupsProvider>().groups.firstWhere((e) => e.chatID == chat!.chatID)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Color(0xFF13162C), BlendMode.hardLight),
                  scale: 1,
                  repeat: ImageRepeat.repeat,
                  image: AssetImage("assets/images/chat_bg.jpg"),
                ),
              ),
              child: MessageView(onChatIDChanged: getActualChatID, showExtraData: showExtraDataInMsg),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            color: Color(0xFF13162C),
            child: Row(
              children: [
                KMessageField(controller: _controller),
                IconButton(
                  style: ButtonStyle(

                  ),
                  splashColor: Color(0xFF13162C),
                  highlightColor: Color(0xFF13162C),
                  hoverColor: Color(0xFF13162C),
                  onPressed: () async {
                    if (!_controller.text.isEmpty) await SendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Color(0xFF0C4AA6),
                    size: 28,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
