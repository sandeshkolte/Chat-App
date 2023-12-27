import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: darkBluishColor,
        cardColor: Colors.white,
        canvasColor: creamColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: darkBluishColor, foregroundColor: Colors.white),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(darkBluishColor))),
        appBarTheme: AppBarTheme(
          backgroundColor: darkBluishColor,
          foregroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      cardColor: const Color.fromRGBO(27, 28, 30, 1.0),
      canvasColor: const Color(0xff111111),
      primaryColor: lightBluishColor,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: lightBluishColor),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(lightBluishColor))),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 17, 16, 16),
        foregroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ));

//Colors
  static Color creamColor = const Color(0xfff5f5f5);
  // static Color darkcreamColor = Vx.gray900;
  static Color darkBluishColor = const Color.fromARGB(255, 94, 0, 94);
  static Color lightBluishColor = const Color.fromARGB(255, 141, 101, 196);
}
