import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final isShowMore = false.obs;
  final isPlaying = false.obs;
  final scrollPixel = 0.0.obs;
  AnimationController? animatedController;
  ScrollController? scrollController;
  void handleOnPressed() {
    isPlaying.value = !isPlaying.value;
    isPlaying.value
        ? animatedController!.forward()
        : animatedController!.reverse();
  }
}
