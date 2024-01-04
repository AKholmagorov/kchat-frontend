import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/EditUserProfile.dart';
import 'package:kchat/utils/KDataTypes.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KTextFormField.dart';
import 'package:provider/provider.dart';
import '../../../../services/ws_manager.dart';
import '../../../../utils/KSnackBar.dart';
import '../../../../widgets/KButtons.dart';


class ChangePass_2 extends StatefulWidget {
  const ChangePass_2({super.key, required this.password});

  final String password;

  @override
  State<ChangePass_2> createState() => _ChangePass_2State();
}

class _ChangePass_2State extends State<ChangePass_2> {
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
              obscureText: true,
              labelText: 'Confirm password',
              validator: ValidatorType.CONFIRM,
              onErrorChanged: _handleErrorChange,
              controller: _controller,
              oldValue: widget.password,
            ),
            KProcessBtn(
              hasError: _hasError,
              nextPage: EditUserProfile(),
              afterClick: (){
                context.read<WS_Manager>().ChangeProfileData(_controller.text, KDataTypes.password);
                ScaffoldMessenger.of(context).showSnackBar(KSnackBar(text: 'Password has changed.'));
                Navigator.popUntil(context, (route) => route.settings.name == '/edit_user_profile');
              }
            ),
            const SizedBox(height: 10),
            KBackBtn(),
          ],
        ),
      ),
    );
  }
}
