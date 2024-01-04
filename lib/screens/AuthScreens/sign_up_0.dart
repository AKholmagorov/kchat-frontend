import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/models/sign_up_data.dart';
import 'package:kchat/screens/AuthScreens/sign_up_1.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KButtons.dart';
import 'package:kchat/widgets/KTextFormField.dart';

class SignUp_page_0 extends StatefulWidget {
  SignUp_page_0({super.key});

  final SignUpData signUpData = SignUpData();

  @override
  State<SignUp_page_0> createState() => _SignUp_page_0State();
}

class _SignUp_page_0State extends State<SignUp_page_0> {
  TextEditingController _controller = TextEditingController();
  bool _hasError = true; // error status of KTextFormField

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
              labelText: 'Username',
              validator: ValidatorType.USERNAME,
              onErrorChanged: _handleErrorChange, 
              controller: _controller
            ),
            const SizedBox(height: 10),

            // Buttons
            KProcessBtn(
              hasError: _hasError,
              nextPage: SignUp_1.SignUp_page_1(sighUpData: widget.signUpData),
              afterClick: () => widget.signUpData.setUsername(_controller.text),
            ),
            const SizedBox(height: 10),
            KBackBtn(),
          ],
        ),
      ),
    );
  }
}
