import 'package:flutter/material.dart';

ThemeData kDarkTheme = ThemeData(
  // General
  fontFamily: 'Inter',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF13162C),

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF13162C),
  ),

  drawerTheme: DrawerThemeData(
    backgroundColor: Color(0xFF13162C),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF666783),
  ),

  scrollbarTheme: ScrollbarThemeData(
    thickness: MaterialStatePropertyAll(0),
  ),

  // Input
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF34354E),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Color(0xFFAAAAAA))),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1.5, color: Color(0xFF0C4AA6))),

    labelStyle: const TextStyle(
      color: Color(0xFF898686),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: const TextStyle(
      color: Color(0xFF898686),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  ),
);
