import 'package:flutter/material.dart';
import 'package:kchat/services/ws_manager.dart';
import 'package:kchat/utils/KDataTypes.dart';
import 'package:kchat/utils/KSnackBar.dart';
import 'package:kchat/widgets/KButtons.dart';
import 'package:kchat/widgets/KUploadImage.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';

class ChangeUserAvatar extends StatefulWidget {
  const ChangeUserAvatar({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<ChangeUserAvatar> createState() => _ChangeUserAvatarState();
}

class _ChangeUserAvatarState extends State<ChangeUserAvatar> {
  String? newAvatarBase64;
  bool _hasError = true;

  void _handleErrorChange(bool hasError) {
    setState(() {
      _hasError = hasError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KUploadImage(
              onImagePicked: (img) {
                newAvatarBase64 = img;
              },
              initCurrentAvatar: widget.currentUser.isStandardAvatar ? null : widget.currentUser.avatar,
              onErrorChanged: _handleErrorChange,
            ),
            SizedBox(height: 30),
            KProcessBtn(
                title: 'Apply',
                hasError: _hasError,
                afterClick: () {
                  widget.currentUser.SetAvatar(newAvatarBase64);

                  context.read<WS_Manager>().ChangeProfileData(newAvatarBase64, KDataTypes.user_avatar);
                  ScaffoldMessenger.of(context).showSnackBar(KSnackBar(text: 'Avatar has changed.'));
                  Navigator.pop(context);
                }
            ),
            SizedBox(height: 10),
            KBackBtn(title: 'Cancel'),
          ],
        ),
      ),
    );
  }
}
