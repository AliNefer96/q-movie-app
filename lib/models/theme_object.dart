import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF0E1324), 
  scaffoldBackgroundColor: const Color(0xFF0E1324),

  fontFamily: 'SF Pro Display', 
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 32.0, 
      fontWeight: FontWeight.bold, 
      color: Color(0xFFE4ECEF), 
    ),
    headline6: TextStyle(
      fontSize: 24.0, 
      fontWeight: FontWeight.bold,
      color: Color(0xFFE4ECEF), 
    ),
    bodyText2: TextStyle(
      fontSize: 14.0, 
      color: Color(0xFFE4ECEF), 
    ),
  ),
  buttonTheme:const ButtonThemeData(
    buttonColor: Color(0xFF0E1324), 
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0E1324), 
    titleTextStyle: TextStyle(
      color: Color(0xFFE4ECEF),
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFEC9B3E), 
  ),
  
);
