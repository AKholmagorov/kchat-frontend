import 'package:flutter/material.dart';
import 'package:kchat/Providers/UpdatableMembersCount.dart';
import 'package:kchat/models/group.dart';
import 'package:kchat/screens/ChatsAndProfiles/GroupScreens/GroupProfile.dart';

class GroupCardMini extends StatelessWidget {
  const GroupCardMini({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(group: group))),
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 8, 20, 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: group.avatar.image,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                UpdatableMembersCount(chatID: group.chatID),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
