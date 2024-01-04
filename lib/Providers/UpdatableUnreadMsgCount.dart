import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:provider/provider.dart';

Selector<ChatsProvider, int> UpdatableUnreadMsgCount({required int chatID}) {
  return Selector<ChatsProvider, int>(
    selector: (_, provider) => provider.chats.firstWhere((e) => e.chatID == chatID).unreadMsgCount,
    builder: (_, unreadMsgCount, __) {
      return Container(
          alignment: Alignment.center,
          height: 24,
          width: 24,
          decoration: ShapeDecoration(
            color: Color(0xFF0C4AA6),
            shape: OvalBorder(),
          ),
          child: Text('$unreadMsgCount')
      );
    },
  );
}
