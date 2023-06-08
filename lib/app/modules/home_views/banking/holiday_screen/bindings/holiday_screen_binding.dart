import 'package:get/get.dart';

import '../controllers/holiday_screen_controller.dart';

class HolidayScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HolidayScreenController>(
      () => HolidayScreenController(),
    );
  }
}
