import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KUploadImage extends StatefulWidget {
  const KUploadImage({super.key, required this.onImagePicked, this.initCurrentAvatar, required this.onErrorChanged});

  final Function(String?) onImagePicked;
  final Function(bool) onErrorChanged;
  final Image? initCurrentAvatar;

  @override
  State<KUploadImage> createState() => _KUploadImageState();
}

class _KUploadImageState extends State<KUploadImage> {
  XFile? _selectedImagePath;
  bool isFirstInit = true;
  bool useInitAvatar = true;

  @override
  void initState() {
    super.initState();
    if (isFirstInit) {
      useInitAvatar = widget.initCurrentAvatar == null ? false : true;
      isFirstInit = false;
    }
  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      setState(() {
        _selectedImagePath = returnedImage;

        // if user has uploaded new avatar it can be applied
        widget.onErrorChanged(false);
      });

      widget.onImagePicked(base64Encode(await _selectedImagePath!.readAsBytes()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        useInitAvatar
            ? HasImageCircle(currentAvatar: widget.initCurrentAvatar)
            : _selectedImagePath == null
                ? NoImageCircle()
                : HasImageCircle(),
        SizedBox(height: 24),
        Text(
          'Profile image (optional)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF5C5C78),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Stack NoImageCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        DottedBorder(
          strokeWidth: 2.5,
          borderType: BorderType.Circle,
          dashPattern: const [50, 40],
          color: Color(0xFF5C5C78),
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(1, 0, 0, 0),
            radius: 100,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: Color(0xFF5C5C78),
              size: 56,
            ),
            // SizedBox(height: 5),
            TextButton(
              onPressed: () {
                _pickImageFromGallery();
              },
              child: Text(
                'Upload image',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5C5C78),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Stack HasImageCircle({Image? currentAvatar}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              backgroundImage: currentAvatar == null
                  ? FileImage(File(_selectedImagePath!.path))
                  : currentAvatar.image,
              backgroundColor: Color.fromARGB(1, 0, 0, 0),
              radius: 100,
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: SizedBox(
                width: 36,
                height: 36,
                child: FloatingActionButton(
                  backgroundColor: Color(0xFFBC1919),
                  child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white),
                  onPressed: () {
                    setState(() {
                      // if user has deleted his avatar it can be applied
                      if (widget.initCurrentAvatar != null)
                        widget.onErrorChanged(false);
                      // if user had no avatar before it can't be applied
                      else
                        widget.onErrorChanged(true);

                      useInitAvatar = false;
                      _selectedImagePath = null;
                      widget.onImagePicked(null);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
