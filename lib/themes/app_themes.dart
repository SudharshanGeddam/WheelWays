import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes{
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
    primaryColor: const Color.fromARGB(255, 126, 18, 146),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme:  AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.purple,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.grey[100],
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple,
    brightness: Brightness.light,),
     inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[500],
    hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  cardColor: Color.fromRGBO(210, 239, 255, 1),
  useMaterial3: true,
  fontFamily: GoogleFonts.montserrat().fontFamily,
);

}