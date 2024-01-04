import 'package:flutter/material.dart';
import 'package:kchat/Providers/GroupsProvider.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/models/group.dart';
import 'package:provider/provider.dart';
import '../../../Providers/UsersProvider.dart';
import '../../../models/user.dart';
import '../../../services/ws_manager.dart';
import '../../../widgets/UserCardMini.dart';

class AddMembersToGroup extends StatelessWidget {
  const AddMembersToGroup({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add members'.kNameStyle(fontSize: 20),
        elevation: 0,
      ),
      // TODO: subscribe on user list updates
      body: Selector<GroupsProvider, int>(
        selector: (_, provider) => provider.GetMembersCount(group.chatID),
        builder: (_, usersCount, __) {
          List<User>? users = context.read<UsersProvider>().users;
          List<User> notGroupMembers = [];
          notGroupMembers.addAll(users!.where((e) => !group.members.contains(e)));

          if (notGroupMembers.isNotEmpty) {
            return ListView.builder(
                itemCount: notGroupMembers.length,
                itemBuilder: (context, index) {
                  return UserCardMini(
                      user: notGroupMembers[index],
                      action: IconButton(
                          icon: Icon(Icons.group_add_sharp),
                          onPressed: () {
                            context.read<WS_Manager>().AddUserToGroup(group.chatID, notGroupMembers[index].id);
                          }));
                });
          }
          else {
            return Center(child: Text('There are no users to invite.', textAlign: TextAlign.center));
          }
        }),
    );
  }
}
