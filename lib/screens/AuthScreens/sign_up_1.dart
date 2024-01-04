import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/models/sign_up_data.dart';
import 'package:kchat/screens/AuthScreens/sign_up_2.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KButtons.dart';
import 'package:kchat/widgets/KTextFormField.dart';

class SignUp_1 extends StatefulWidget {
  SignUp_1.SignUp_page_1({super.key, required this.sighUpData});

  final SignUpData sighUpData;

  @override
  State<SignUp_1> createState() => _SignUp_0State();
}

class _SignUp_0State extends State<SignUp_1> {
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
              labelText: 'Password',
              validator: ValidatorType.PASSWORD,
              onErrorChanged: _handleErrorChange,
              obscureText: true, 
              controller: _controller,
            ),
            const SizedBox(height: 10),

            // Btns
            KProcessBtn(
              hasError: _hasError,
              nextPage: SignUp_page_2(signUpData: widget.sighUpData), 
              afterClick: () => widget.sighUpData.setPassword(_controller.text)
            ),
            const SizedBox(height: 10),
            KBackBtn(),
          ],
        ),
      ),
    );
  }
}
