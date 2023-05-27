import 'package:get/get.dart';

import '../controllers/ifsc_screen_controller.dart';

class IfscScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IfscScreenController>(
      () => IfscScreenController(),
    );
  }
}
