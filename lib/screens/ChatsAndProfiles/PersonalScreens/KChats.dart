import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/services/ws_manager.dart';
import 'package:kchat/widgets/KDrawer.dart';
import 'package:kchat/widgets/ChatCardMini.dart';
import 'package:provider/provider.dart';
import '../../../Providers/UsersProvider.dart';
import '../../../models/user.dart';
import 'Contacts.dart';

class KChats extends StatelessWidget {
  const KChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'KChat'.kNameStyle(fontSize: 20),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: KDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Contacts()));
        },
      ),
      body: Consumer<ChatsProvider>(
        builder: (_, value, __) {
          // *** Call WS connect() on KChats screen to load chats ***
          context.read<WS_Manager>();

          if (!value.isLoaded)
            return Center(child: CircularProgressIndicator());
          else if (value.chats.isEmpty)
            return Center(child: Text('You have no chats yet.'));

          // sort chats by their activity
          value.chats.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
          return ListView.builder(
            itemCount: value.chats.length,
            itemBuilder: (context, index) {
              if (value.chats[index].isPersonal) {
                int receiverID = value.chats[index].receiverID!;
                User receiverInstance = context.read<UsersProvider>().users!.firstWhere((e) => e.id == receiverID);
                return ChatCardMini(chat: value.chats[index], user: receiverInstance);
              } else {
                return ChatCardMini(chat: value.chats[index]);
              }
            }
          );
        }
      ),
    );
  }
}
