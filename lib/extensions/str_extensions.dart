import 'package:flutter/material.dart';

extension CustomTextExtension on String {
  RichText kNameStyle({double fontSize = 32}) {
    if (isEmpty) return RichText(text: const TextSpan(text: ''));

    final String firstLetter = this[0];
    final String remainingText = substring(1);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstLetter,
            style: TextStyle(
                color: const Color(0xFF0C4AA6),
                fontSize: fontSize,
                fontWeight: FontWeight.w700
            ),
          ),
          TextSpan(
            text: remainingText,
            style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    );
  }
}
