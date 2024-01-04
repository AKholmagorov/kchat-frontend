import 'package:flutter/material.dart';
import 'package:kchat/Providers/UpdatableUserStatus.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/UserProfile.dart';
import '../models/user.dart';

class UserCardMini extends StatelessWidget {
  const UserCardMini(
      {super.key,
      this.statusIcon,
      this.action,
      this.avatarRadius = 25,
      required this.user,
      this.isChatReopen = false});

  final IconData? statusIcon;
  final Widget? action;
  final double avatarRadius;
  final User user;
  final bool isChatReopen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UserProfile(user: user, isChatReopen: isChatReopen))),
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 8, 20, 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: user.avatar.image,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    statusIcon != null
                        ? Row(
                            children: [
                              Text(
                                '${user.username}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                statusIcon!,
                                size: 16,
                                color: Color(0xFF0C4AA6),
                              ),
                            ],
                          )
                        : Text(
                            '${user.username}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 5),
                UpdatableUserStatus(user: user),
              ],
            ),
            Spacer(),
            action != null ? action! : Text(''),
          ],
        ),
      ),
    );
  }
}
