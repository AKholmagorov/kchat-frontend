import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';
import 'package:kchat/services/http_requests.dart';
import 'package:kchat/widgets/KButtons.dart';
import 'package:kchat/widgets/KUploadImage.dart';
import '../../models/sign_up_data.dart';
import 'login_screen.dart';

class SignUp_page_3 extends StatefulWidget {
  const SignUp_page_3({super.key, required this.signUpData});

  final SignUpData signUpData;

  @override
  State<SignUp_page_3> createState() => _SignUp_page_3State();
}

class _SignUp_page_3State extends State<SignUp_page_3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "KChat".kNameStyle(),
            SizedBox(height: 35),
            KUploadImage(
              onImagePicked: (String? userAvatar) {
                widget.signUpData.setUserAvatar(userAvatar);
              },
              onErrorChanged: (bool) {},
            ),
            SizedBox(height: 40),
            KProcessBtn(
              hasError: false,
              nextPage: LoginScreen(),
              afterClick: () async {
                String status = 'NULL';
                if(await signUpUser(widget.signUpData))
                  status = 'User added.';
                else
                  status = 'Error: user not added.';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Info"),
                      content: Text(status),
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
              },
            ),
            SizedBox(height: 10),
            KBackBtn(),
          ],
        ),
      ),
    );
  }
}
