import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'GroupsProvider.dart';

Selector UpdatableMembersCount({required int chatID}) {
  return Selector<GroupsProvider, int>(
    selector: (_, provider) => provider.GetMembersCount(chatID),
    builder: (_, membersCount, __) {
      return Text(
        '${membersCount} members',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF717171),
          fontSize: 14,
        ),
      );
    },
  );
}