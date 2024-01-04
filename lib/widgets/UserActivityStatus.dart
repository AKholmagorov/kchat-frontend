import 'package:flutter/material.dart';
import 'package:kchat/main.dart';

Text OnlineTextStatus(
    {Color? color = const Color(0xFF11C501), double fontSize = 14}) {
  return Text('online', style: TextStyle(color: color, fontSize: fontSize));
}

Text OfflineTextStatus(
    {Color? color = const Color(0xFF707070),
      double fontSize = 14,
      required String lastSeen}) {
  return Text('last seen $lastSeen', style: TextStyle(color: color, fontSize: fontSize));
}

ClipOval OnlineStatusForChatMiniCard({Color? color = Colors.green}) {
  return ClipOval(
    child: Container(
      height: 16.0,
      width: 16.0,
      color: Theme.of(navigatorKey.currentContext!).scaffoldBackgroundColor,
      child: Center(
        child: Container(
          height: 11.0,
          width: 11.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
  );
}
