import 'package:flutter/material.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/Providers/UpdatableMessage.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/UserProfile.dart';
import 'package:kchat/utils/data_converter.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.msg, required this.chatID, this.showExtraData = false});
  final int chatID;
  final Message msg;
  final bool showExtraData;

  @override
  Widget build(BuildContext context) {
    int currentUserID = context.read<CurrentUserProvider>().currentUser!.id;
    bool isMyMessage = currentUserID == msg.senderID;

    // 0 code means user message
    // if code more than 0 it's a system message
    if (msg.code != 0) {
      return UnconstrainedBox(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(msg.text, textAlign: TextAlign.center),
          constraints: BoxConstraints(
            maxWidth: 150,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }
    else {
      if (!showExtraData) {
        return UnconstrainedBox(
          alignment: isMyMessage ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(
                maxWidth: 150,
              ),
              color: isMyMessage ? Color(0xFF434b7c) : Color(0xFF222244),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(ConvertMsgDate(msg.date), style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 7),
                      isMyMessage
                          ? UpdatableMessageStatus(chatID: chatID, msgID: msg.msgID!)
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              )
          ),
        );
      }
      else {
        return UnconstrainedBox(
          alignment: isMyMessage ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Row(
            children: [
              !isMyMessage
                ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(user: msg.sender!))),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: msg.sender!.avatar.image,
                    ),
                  ),
                )
              : SizedBox.shrink(),
              Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    maxWidth: 150,
                  ),
                  color: isMyMessage ? Color(0xFF434b7c) : Color(0xFF222244),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !isMyMessage
                        ? Text(
                            msg.sender!.username,
                            style: TextStyle(
                            color: Colors.greenAccent
                            ),
                          )
                        : SizedBox.shrink(),
                      !isMyMessage
                          ? SizedBox(height: 8)
                          : SizedBox.shrink(),
                      Text(
                        msg.text,
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(ConvertMsgDate(msg.date), style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 7),
                          isMyMessage
                              ? UpdatableMessageStatus(chatID: chatID, msgID: msg.msgID!)
                              : SizedBox.shrink(),
                        ],
                      ),
                    ],
                  )
              ),
            ],
          )
        );
      }
    }
  }
}
