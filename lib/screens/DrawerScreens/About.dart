import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 12,
            left: 12,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "KChat".kNameStyle(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

