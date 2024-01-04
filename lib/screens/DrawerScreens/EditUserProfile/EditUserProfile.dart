import 'package:flutter/material.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/ChangePassScreens/ChangePass_1.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/ChangeUserAvatar.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/ChangeUserBio.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/ChangeUsername.dart';
import 'package:kchat/widgets/KButtons.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';

class EditUserProfile extends StatelessWidget {
  const EditUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final User currentUser = context.read<CurrentUserProvider>().currentUser!;

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Center(
        child: Consumer<CurrentUserProvider>(builder: (_, value, __) {
         if (value.currentUser == null)
           return Center(child: CircularProgressIndicator());

         return SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Center(
                 child: Text(
                   'What need to change?',
                   style: TextStyle(
                     fontSize: 20,
                   ),
                 )),
               SizedBox(height: 50),
               KProcessBtn(
                 title: 'Avatar',
                 hasError: false,
                 nextPage: ChangeUserAvatar(currentUser: currentUser),
                 afterClick: () {}),
               SizedBox(height: 10),
               KProcessBtn(
                   title: 'Bio',
                   hasError: false,
                   nextPage: ChangeUserBio(currentUser: currentUser),
                   afterClick: () {}),
               SizedBox(height: 10),
               KProcessBtn(
                 title: 'Username',
                 hasError: false,
                 nextPage: ChangeUsername(currentUser: currentUser),
                 afterClick: () {}),
               SizedBox(height: 10),
               KProcessBtn(
                 title: 'Password',
                 hasError: false,
                 nextPage: ChangePass_1(),
                 afterClick: () {}),
             ],
           ),
         );
        })
      ),
    );
  }
}
