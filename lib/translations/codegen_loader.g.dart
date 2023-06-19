// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en = {
    "bot_nav_home": "Home",
    "bot_nav_contact_us": "Contact Us",
    "bot_nav_about_us": "About Us",
    "bot_nav_personal": "Profile"
  };
  static const Map<String, dynamic> ca = {
    "bot_nav_home": "ទំព័រមុខ",
    "bot_nav_contact_us": "ទំនាក់ទំនង",
    "bot_nav_about_us": "អំពីយើង",
    "bot_nav_personal": "ផ្ទាល់ខ្លួន"
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "ca": ca
  };
}
