import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/models/sign_up_data.dart';
import 'package:kchat/screens/AuthScreens/sign_up_3.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KButtons.dart';
import 'package:kchat/widgets/KTextFormField.dart';

class SignUp_page_2 extends StatefulWidget {
  SignUp_page_2({super.key, required this.signUpData});

  final SignUpData signUpData;

  @override
  State<SignUp_page_2> createState() => _SignUp_0State();
}

class _SignUp_0State extends State<SignUp_page_2> {
  TextEditingController _controller = TextEditingController();
  bool _hasError = true;

  void _handleErrorChange(bool hasError) {
    setState(() {
      _hasError = hasError;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

            // text fields
            KTextFormField(
              labelText: 'Confirm password',
              validator: ValidatorType.CONFIRM,
              onErrorChanged: _handleErrorChange,
              obscureText: true, 
              controller: _controller,
              oldValue: widget.signUpData.password,
            ),
            const SizedBox(height: 10),

            // Btns
            // TODO: CHANGE NEXT PAGE
            KProcessBtn(
              hasError: _hasError, 
              nextPage: SignUp_page_3(signUpData: widget.signUpData),
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
