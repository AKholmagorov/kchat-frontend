import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/screens/AuthScreens/sign_up_0.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/KChats.dart';
import 'package:kchat/services/http_requests.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _nameCntr = TextEditingController();
  final TextEditingController _passCntr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "KChat".kNameStyle(),
            const SizedBox(height: 35),

            _KLocalTextFormField(labelText: 'Username', controller: _nameCntr),
            const SizedBox(height: 10),
            _KLocalTextFormField(
                labelText: 'Password',
                controller: _passCntr,
                obscureText: true),
            const SizedBox(height: 30),

            // Log In btn
            SizedBox(
                width: 270,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    auth(context, _nameCntr.text, _passCntr.text);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Color(0xFF0C4AA6)),
                  ),
                  child: const Text(
                    'Log In',
                  ),
                )),
            const SizedBox(height: 20),

            // ..or sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('..or '),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp_page_0())),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF0C4AA6),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void auth(BuildContext context, String username, String password) {
  authUser(username, password).then((value) {
    if (value.error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(value.errorText),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => KChats()), (Route<dynamic> route) => false);
    }
  });
}

class _KLocalTextFormField extends StatelessWidget {
  const _KLocalTextFormField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  });

  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 45,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle: TextStyle(
            color: Color(0xFF1468c5),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
