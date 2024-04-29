import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:school/config/app_colors.dart';

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

ThemeData lightMode = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  // iconTheme: IconThemeData(color: Colors.white),
  textSelectionTheme: TextSelectionThemeData(
      // selectionColor: AppColor.secondnaryColor.withOpacity(0.6),
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 255, 255, 255),
    primary: Colors.black,
    secondary: Color.fromARGB(255, 209, 209, 209),
    tertiary: Color.fromARGB(255, 27, 27, 27),
    onPrimary: Color.fromARGB(255, 39, 39, 39),
    onSecondary: Color.fromARGB(255, 133, 133, 133),
    onTertiary: Color.fromARGB(255, 232, 232, 232),
  ),
  useMaterial3: false,
  brightness: Brightness.light,
  tabBarTheme: const TabBarTheme(
    splashFactory: InkSplash.splashFactory,
    labelColor: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Siemreap",
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontFamily: "Siemreap",
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: "Siemreap",
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontFamily: "Siemreap",
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontFamily: "Siemreap",
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 11,
      fontFamily: "Siemreap",
    ),
  ),
);

ThemeData darkMode = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
      // selectionColor: AppColor.secondnaryColor.withOpacity(0.6),
      ),
  tabBarTheme: const TabBarTheme(splashFactory: InkSplash.splashFactory),
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Color.fromARGB(255, 77, 77, 77),
    tertiary: Color.fromARGB(255, 207, 207, 207),
    onPrimary: Color.fromARGB(255, 198, 198, 198),
    onSecondary: Color.fromARGB(255, 111, 111, 111),
    onTertiary: Color.fromARGB(255, 24, 24, 24),
  ),
  useMaterial3: true,
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Siemreap",
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontFamily: "Siemreap",
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: "Siemreap",
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: "Siemreap",
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontFamily: "Siemreap",
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontFamily: "Siemreap",
    ),
  ),
);
