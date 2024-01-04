import 'package:flutter/material.dart';
import 'package:kchat/models/new_group_data.dart';
import 'package:kchat/services/ws_manager.dart';
import 'package:kchat/utils/KSnackBar.dart';
import 'package:kchat/utils/validator.dart';
import 'package:kchat/widgets/KTextFormField.dart';
import 'package:provider/provider.dart';
import '../../../widgets/KButtons.dart';
import '../../../widgets/KUploadImage.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<CreateGroup> {
  TextEditingController _controller = TextEditingController();
  NewGroupData group = NewGroupData();
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
              onImagePicked: (img) => group.setAvatar(img),
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
              title: 'Create',
              hasError: _hasError,
              afterClick: () {
                group.setName(_controller.text);
                context.read<WS_Manager>().CreateNewGroup(group);
                ScaffoldMessenger.of(context).showSnackBar(KSnackBar(text: 'Group has created.'));
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 10),
            KBackBtn(title: 'Cancel',),
          ],
        ),
      ),
    );
  }
}
