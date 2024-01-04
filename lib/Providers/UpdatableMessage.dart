import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:provider/provider.dart';

Selector<ChatsProvider, bool> UpdatableMessageStatus(
    {required int chatID, required int msgID}) {

  return Selector<ChatsProvider, bool>(
    selector: (_, provider) => provider.GetMsgStatus(chatID, msgID),
    builder: (_, isMsgRead, ___) {
      if (isMsgRead)
        return Icon(Icons.done_all, color: Color(0xFF20DE10));
      else
        return Icon(Icons.done_all, color: Color(0xFF34354E));
    },
  );
}
