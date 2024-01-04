import 'package:flutter/material.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:provider/provider.dart';
import '../../../Providers/UsersProvider.dart';
import '../../../models/user.dart';
import '../../../widgets/UserCardMini.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: 'Contacts'.kNameStyle(fontSize: 20),
        ),
        body: Consumer<UsersProvider>(
          builder: (_, value, __) {
            List<User>? users = value.users;

            if (users == null)
              return Center(child: CircularProgressIndicator());
            else if (users.length-1 == 0) // -1 current user
              return Center(child: Text(
                  "The developer hasn't invested in marketing.\n So you are the only user of this chat.",
                  textAlign: TextAlign.center,
                )
              );

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                // don't show current user in the contacts list
                if (users[index].id != context.read<CurrentUserProvider>().currentUser!.id)
                  return UserCardMini(user: users[index]);
                else
                  return SizedBox.shrink();
              },
            );
          },
        )
    );
  }
}
