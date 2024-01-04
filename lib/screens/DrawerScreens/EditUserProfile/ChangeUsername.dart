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

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
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
              initialValue: widget.currentUser.username,
              labelText: 'Username',
              validator: ValidatorType.USERNAME,
              onErrorChanged: _handleErrorChange,
              controller: _controller
            ),
            KProcessBtn(
                title: 'Apply',
                hasError: _hasError,
                afterClick: () {
                  widget.currentUser.SetUsername(_controller.text);
                  context.read<WS_Manager>().ChangeProfileData(_controller.text, KDataTypes.username);
                  ScaffoldMessenger.of(context).showSnackBar(KSnackBar(text: 'Username has changed.'));
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
