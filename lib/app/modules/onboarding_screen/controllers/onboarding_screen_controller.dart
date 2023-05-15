import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/screens.dart';

class OnboardingScreenController extends GetxController {
  //TODO: Implement OnboardingScreenController

  RxInt selectedPage = 0.obs;

  List<Widget> lstScreens = [Screens.subScreen1(), Screens.subScreen2(), Screens.subScreen3()];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
