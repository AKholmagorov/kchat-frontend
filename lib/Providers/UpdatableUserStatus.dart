import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../widgets/UserActivityStatus.dart';
import 'UserStatusProvider.dart';

Selector UpdatableUserStatus(
    {required User user, double fontSize = 12, bool isChatCardMini = false}) {
  return Selector<UserStatusProvider, bool>(
    selector: (_, __) => user.isOnline,
    builder: (_, isOnline, __) {
      if (isOnline)
        return !isChatCardMini
            ? OnlineTextStatus(fontSize: fontSize)
            : OnlineStatusForChatMiniCard();
      else
        return !isChatCardMini 
            ? OfflineTextStatus(fontSize: fontSize, lastSeen: user.lastSeen)
            : SizedBox.shrink();
    },
  );
}
