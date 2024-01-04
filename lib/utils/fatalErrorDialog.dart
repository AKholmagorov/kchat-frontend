import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kchat/main.dart';

void showFatalDialog(String title, String content) {
  showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(onPressed: () => exit(0), child: Text('Exit'))
          ],
        );
      });
}
