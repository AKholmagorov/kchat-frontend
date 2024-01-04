import 'package:flutter/material.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KTextFormField.dart';
import '../../../widgets/KButtons.dart';
import '../../../widgets/KUploadImage.dart';

class EditGroup extends StatefulWidget {
  const EditGroup({super.key});

  @override
  State<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  TextEditingController _controller = TextEditingController();
  bool _hasError = true;

  // error status of KTextFormField
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
              onImagePicked: (value) {},
              onErrorChanged: (bool) {},
            ),
            SizedBox(height: 40),
            KTextFormField(
              labelText: 'Group Name',
              validator: ValidatorType.GROUP_NAME,
              onErrorChanged: _handleErrorChange,
              controller: _controller
            ),
            KProcessBtn(
              title: 'Apply',
              hasError: false,
              afterClick: () {},
            ),
            SizedBox(height: 10),
            KBackBtn(title: 'Cancel',),
          ],
        ),
      ),
    );
  }
}
