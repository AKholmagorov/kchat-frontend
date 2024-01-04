import 'package:flutter/material.dart';

SnackBar KSnackBar({required String text, int duration = 2000}) {
  return SnackBar(
    duration: Duration(milliseconds: duration),
    content: Text(text, style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.black45,
  );
}
