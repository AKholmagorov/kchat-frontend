import 'package:flutter/material.dart';
import 'package:kchat/extensions/str_extensions.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  List<bool> _isSelectedLanguage = [true, false];
  List<String> _languages = ['EN', 'RU'];

  List<bool> _isSelectedTheme = [false, true];
  List<String> _themes = ['Light', 'Dark'];

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
                "KOptions".kNameStyle(),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Language',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF5C5C78),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 45),
                        Text(
                          'Theme',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF5C5C78),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _showToggleBtns(_isSelectedLanguage, _languages),
                        SizedBox(height: 20),
                        _showToggleBtns(_isSelectedTheme, _themes),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  ToggleButtons _showToggleBtns(List<bool> btsState, List<String> btsName) {
    return ToggleButtons(
      renderBorder: false,
      borderColor: Color(0xFF5C5C78),
      selectedBorderColor: Color(0xFF0C4AA6),
      selectedColor: Colors.white,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      fillColor: Colors.transparent,
      children: List.generate(
          btsState.length,
          (index) => _buildToggleButton(btsName[index], btsState[index])),
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < btsState.length; i++) {
            if (i != index)
              btsState[i] = false;
            else
              btsState[i] = true;
          }
        });
      },
      isSelected: _isSelectedLanguage,
    );
  }

  Widget _buildToggleButton(String title, bool isSelected) {
    return Padding(
      // space between buttons
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xFF0C4AA6) : Color(0xFF5C5C78),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Color(0xFF0C4AA6) : Color(0xFF5C5C78),
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}
