import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:kchat/main.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';

Selector UpdatableLastMessage({required int chatID}) {
  return Selector<ChatsProvider, Message?>(
    selector: (_, provider) => provider.GetLastMsg(chatID),
    builder: (_, lastMsg, __) {
      double screenWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;

      return Container(
        width: screenWidth * 0.5,
        child: Text(
          lastMsg != null ? lastMsg.text : '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF707070),
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    },
  );
}
