import 'package:get/get.dart';

import '../controllers/bottom_navigation_screen_controller.dart';

class BottomNavigationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationScreenController>(
      () => BottomNavigationScreenController(),
    );
  }
}
