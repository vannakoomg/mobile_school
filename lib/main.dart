import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/translations/codegen_loader.g.dart';
import './app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  // String foo = dotenv.get('base_ulr');
  // debugPrint("base url :$foo");
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // systemNavigationBarColor: Colors.red,
      // statusBarColor: Colors.red,
      // statusBarBrightness: Brightness.dark,
      // statusBarIconBrightness: Brightness.light,
      ));
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [
        Locale('ca'),
        Locale('en'),
      ],
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: MyApp(),
    ),
  );
}
