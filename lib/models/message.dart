import 'package:kchat/Providers/UsersProvider.dart';
import 'package:kchat/main.dart';
import 'package:kchat/models/user.dart';
import 'package:provider/provider.dart';

class Message {
  int date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  int? msgID;
  int? senderID;
  int? chatID;
  String text;
  bool isRead;
  int code;

  User? sender;

  Message(
      {required this.text,
      this.chatID,
      required this.senderID,
      this.msgID,
      this.isRead = false,
      this.code = 0});

  factory Message.fromJson(Map<String, dynamic> jsonData) {
    String msgText = jsonData['code'] == 0 ? jsonData['text'] : ConvertMsgCodeToText(jsonData['code'], jsonData);

    Message msg = Message(
        chatID: jsonData['chatID'],
        text: msgText,
        msgID: jsonData['msgID'],
        senderID: jsonData['senderID'],
        isRead: jsonData['isRead'] == 1 ? true : false,
        code: jsonData['code']
    );
    msg.date = jsonData['date'];

    if (jsonData['senderID'] != null) {
      msg.sender = navigatorKey.currentContext!.read<UsersProvider>().GetUserByID(jsonData['senderID']);
    }

    return msg;
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'chatID': chatID == null ? null : chatID,
        'text': text,
        // server will set ID to msg
        'msgID': msgID == null ? null : msgID,
        // server's already now who sent the message
        'senderID': senderID,
        'isRead': isRead == true ? 1 : 0,
        'code': code
      };

  static String ConvertMsgCodeToText(int msgCode, Map<String, dynamic> jsonData) {
    switch (msgCode) {
      case 1:
        return 'group created';
      case 2:
        return '${jsonData['text']} has joined';
      case 3:
        return '${jsonData['text']} has kicked from the group';
      case 4:
        return '${jsonData['text']} has left';

      default:
        return 'something has happened but no one knows what';
    }
  }
}
