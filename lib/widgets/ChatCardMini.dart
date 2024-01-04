import 'package:flutter/material.dart';
import 'package:kchat/Providers/UpdatableLastMsg.dart';
import 'package:kchat/Providers/UpdatableUserStatus.dart';
import 'package:kchat/Providers/UpdatableUnreadMsgCount.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/KChat.dart';
import '../models/chat.dart';
import '../models/user.dart';

class ChatCardMini extends StatelessWidget {
  const ChatCardMini({super.key, required this.chat, this.user});

  final Chat chat;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => KChat(chat: chat, receiverProfile: user)));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 8, 30, 8),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: chat.chatAvatar.image,
                ),
                chat.isPersonal
                    ? UpdatableUserStatus(user: user!, isChatCardMini: true)
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    !chat.isPersonal
                        ? Row(
                            children: [
                              Icon(Icons.groups,
                                  size: 20, color: Color(0xFF717171)),
                              SizedBox(width: 5),
                              Text(
                                chat.chatName,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            chat.chatName,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 5),
                UpdatableLastMessage(chatID: chat.chatID),
              ],
            ),
            Spacer(),
            chat.unreadMsgCount > 0
                ? UpdatableUnreadMsgCount(chatID: chat.chatID)
                : Text(''),
          ],
        ),
      ),
    );
  }
}
