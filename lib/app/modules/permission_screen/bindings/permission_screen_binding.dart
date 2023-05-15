import 'package:get/get.dart';

import '../controllers/permission_screen_controller.dart';

class PermissionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionScreenController>(
      () => PermissionScreenController(),
    );
  }
}
