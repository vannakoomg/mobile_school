import 'package:flutter/material.dart';

class ContextUtility {
  static final GlobalKey<NavigatorState> _navigetorkey =
      GlobalKey<NavigatorState>(debugLabel: "contextUtiliyNavigatorKey");
  static GlobalKey<NavigatorState> get navigatorKey => _navigetorkey;

  static bool get hasNavigator => navigatorKey.currentContext != null;
  static NavigatorState? get navigator => navigatorKey.currentState;

  static bool get hasContext => navigator?.overlay?.context != null;
  static BuildContext? get context => navigator?.overlay?.context;
}
