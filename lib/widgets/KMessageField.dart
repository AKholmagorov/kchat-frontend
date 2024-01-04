import 'package:flutter/material.dart';

class KMessageField extends StatelessWidget {
  const KMessageField({
    super.key,
    required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: 5,
        maxLength: 800,
        decoration: InputDecoration(
          counterText: '',
          fillColor: Color(0xFF13162C),
          hintText: 'Write a message...',
          hintStyle: TextStyle(
            color: Color(0xFF34354E),
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hoverColor: Color(0xFF13162C),
        ),
      ),
    );
  }
}

