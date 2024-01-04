import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/Providers/UpdatableUserStatus.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/KChat.dart';
import 'package:provider/provider.dart';
import '../../../models/chat.dart';
import '../../../models/user.dart';
import 'package:collection/collection.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user, this.isChatReopen = false});

  final User user;
  final bool isChatReopen;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final User curUser = context.read<CurrentUserProvider>().currentUser!;
    final bool isCurrentUser = curUser.id == widget.user.id;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: widget.user.avatar.image, fit: BoxFit.cover))
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
                          widget.user.username,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 3),
                        UpdatableUserStatus(user: widget.user, fontSize: 14),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.user.bio != null ? widget.user.bio! : '',
                        style: TextStyle(
                          color: Color(0xFF666783),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          !isCurrentUser
            ? Positioned(
              right: 20,
              top: 275,
              child: FloatingActionButton(
                onPressed: () {
                  if (widget.isChatReopen) {
                    Navigator.pop(context);
                  } else {
                    Chat? initChat = context
                        .read<ChatsProvider>()
                        .chats
                        .firstWhereOrNull((e) => e.receiverID == widget.user.id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KChat(
                                chat: initChat, receiverProfile: widget.user)));
                  }
                },
                child: Icon(Icons.chat, color: Colors.white),
              ),
            )
           : SizedBox.shrink(),
          Positioned(
            top: 12,
            left: 12,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ],
    ));
  }
}
