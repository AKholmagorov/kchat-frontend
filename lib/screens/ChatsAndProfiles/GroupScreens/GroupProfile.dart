import 'package:flutter/material.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/Providers/GroupsProvider.dart';
import 'package:kchat/Providers/UpdatableMembersCount.dart';
import 'package:kchat/main.dart';
import 'package:kchat/models/group.dart';
import 'package:kchat/screens/ChatsAndProfiles/GroupScreens/AddMembersToGroup.dart';
import 'package:kchat/services/ws_manager.dart';
import 'package:kchat/widgets/UserCardMini.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';

class GroupProfile extends StatelessWidget {
  const GroupProfile({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    bool isAdmin = navigatorKey.currentContext!
            .read<CurrentUserProvider>()
            .currentUser!
            .id ==
        group.adminID;

    return Scaffold(
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMembersToGroup(group: group)));
              },
              child: Icon(Icons.person_add_alt_1, color: Colors.white))
          : SizedBox.shrink(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: group.avatar.image, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
                  width: double.infinity,
                  height: 75,
                  color: Color.fromARGB(170, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 3),
                      UpdatableMembersCount(chatID: group.chatID),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_vert_sharp, color: Colors.white),
                    color: Color(0xFF13162C),
                    onSelected: (value) {
                      User curUser = context.read<CurrentUserProvider>().currentUser!;
                      switch (value) {
                        case 'leave_group':
                          context.read<WS_Manager>().RemoveUserFromGroup(group.chatID, curUser.id, false);
                        case 'delete_group':
                          context.read<WS_Manager>().RemoveGroup(group.chatID);
                      }
                    },
                    itemBuilder: (context) {
                      if (isAdmin) {
                        return [
                          PopupMenuItem(
                            value: 'edit_group',
                            child: Text('Edit group'),
                            enabled: false,
                          ),
                          PopupMenuItem(
                            value: 'delete_group',
                            child: Text('Delete group', style: TextStyle(color: Colors.red))
                          ),
                        ];
                      }
                      else {
                        return [
                          PopupMenuItem(
                              value: 'leave_group',
                              child: Text('Leave group', style: TextStyle(color: Colors.red))
                          ),
                        ];
                      }
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.groups, size: 20, color: Color(0xFF717171)),
                  SizedBox(width: 5),
                  Text(
                    'Members',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 0.5,
              color: Color(0xFF717171),
            ),
            Consumer<GroupsProvider>(
              builder: (_, value, __) {
                return Column(
                  children: List.generate(group.members.length, (index) {
                    if (group.members[index].id == group.adminID) {
                      return UserCardMini(
                        user: group.members[index],
                        statusIcon: Icons.stars,
                      );
                    } else {
                      if (isAdmin) {
                        return UserCardMini(
                          user: group.members[index],
                          action: IconButton(
                            icon: Icon(Icons.group_remove, color: Color(0xFF0D52323)),
                            onPressed: () {
                              context.read<WS_Manager>().RemoveUserFromGroup(group.chatID, group.members[index].id, true);
                            },
                          ),
                        );
                      } else {
                        return UserCardMini(user: group.members[index]);
                      }
                    }
                  }),
                );
              },
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
