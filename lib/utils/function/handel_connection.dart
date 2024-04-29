import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_snackbar.dart';
import 'context_unity.dart';

bool isShow = false;
void handelConnection() {
  Connectivity()
      .onConnectivityChanged
      .listen((List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      CustomSnackBar.info(
        title: "No internet connection",
        context: ContextUtility.context!,
      );
    } else {
      ScaffoldMessenger.of(ContextUtility.context!).removeCurrentSnackBar();
    }
  });
}
