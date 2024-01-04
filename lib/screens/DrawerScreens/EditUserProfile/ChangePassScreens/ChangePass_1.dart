import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/ChangePassScreens/ChangePass_2.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KTextFormField.dart';
import '../../../../widgets/KButtons.dart';

class ChangePass_1 extends StatefulWidget {
  const ChangePass_1({super.key});

  @override
  State<ChangePass_1> createState() => _ChangePass_1State();
}

class _ChangePass_1State extends State<ChangePass_1> {
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
              labelText: 'New password',
              validator: ValidatorType.PASSWORD,
              onErrorChanged: _handleErrorChange,
              controller: _controller,
            ),
            KProcessBtn(
                hasError: _hasError,
                nextPage: ChangePass_2(password: _controller.text,),
                afterClick: (){}
            ),
            const SizedBox(height: 10),
            KBackBtn(),
          ],
        ),
      ),
    );
  }
}
