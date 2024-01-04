import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/utils/KDataTypes.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KButtons.dart';
import 'package:kchat/widgets/KTextFormField.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../services/ws_manager.dart';
import '../../../utils/KSnackBar.dart';

class ChangeUserBio extends StatefulWidget {
  const ChangeUserBio({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<ChangeUserBio> createState() => _ChangeUserBioState();
}

class _ChangeUserBioState extends State<ChangeUserBio> {
  TextEditingController _controller = TextEditingController();
  bool _hasError = true; // error status of KTextFormField

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
            "KChat".kNameStyle(),
            const SizedBox(height: 35),
            KTextFormField(
              labelText: 'Bio',
              initialValue: widget.currentUser.isStandardBio ? null : widget.currentUser.bio,
              height: 140,
              maxLines: 5,
              maxSymbols: 70,
              showCounterText: true,
              validator: ValidatorType.BIO,
              onErrorChanged: _handleErrorChange,
              controller: _controller
            ),
            SizedBox(height: 30),
            KProcessBtn(
                title: 'Apply',
                hasError: _hasError,
                afterClick: () {
                  widget.currentUser.SetBio(_controller.text);
                  context.read<WS_Manager>().ChangeProfileData(_controller.text, KDataTypes.user_bio);
                  ScaffoldMessenger.of(context).showSnackBar(KSnackBar(text: 'Bio has changed.'));
                  Navigator.pop(context);
                }),
            SizedBox(height: 10),
            KBackBtn(title: 'Cancel'),
          ],
        ),
      ),
    );
  }
}
