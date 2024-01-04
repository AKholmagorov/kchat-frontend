import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/screens/DrawerScreens/About.dart';
import 'package:kchat/screens/DrawerScreens/CreateGroup.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/EditUserProfile.dart';
import 'package:kchat/screens/DrawerScreens/Options.dart';
import 'package:kchat/services/k_jwt.dart';
import 'package:provider/provider.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          CurrentUserProfile(),
          KListTile(
              title: 'New Group',
              icon: Icon(Icons.groups_sharp),
              onTap: CreateGroup()),
          KListTile(
              title: 'Options', icon: Icon(Icons.settings), onTap: Options()),
          KListTile(title: 'About', icon: Icon(Icons.info), onTap: About()),
          ListTile(
            title: Text('Log Out',
                style: TextStyle(
                    color: Color(0xFF0D52323), fontWeight: FontWeight.w600)),
            leading: Icon(Icons.logout_outlined, color: Color(0xFF0D52323)),
            onTap: () async {
              await deleteToken();
              exit(0);
            },
          ),
        ],
      ),
    );
  }
}

class KListTile extends StatelessWidget {
  const KListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.color,
      this.fontWeight = FontWeight.w400});

  final String title;
  final Icon icon;
  final Widget onTap;
  final Color? color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => onTap));
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}

class CurrentUserProfile extends StatelessWidget {
  const CurrentUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUserProvider>(builder: (_, value, __) {
      if (value.currentUser == null) return CircularProgressIndicator();

      return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/edit_user_profile');
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: value.currentUser!.avatar.image,
                    ),
                    SizedBox(width: 15),
                    Text(
                      value.currentUser!.username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                heightFactor: 0,
                child: Container(
                  height: 0.5,
                  color: const Color(0xFF717171),
                ),
              ),
              SizedBox(height: 12)
            ],
          ));
    });
  }
}
