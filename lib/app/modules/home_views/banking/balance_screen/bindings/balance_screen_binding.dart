import 'package:get/get.dart';

import '../controllers/balance_screen_controller.dart';

class BalanceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BalanceScreenController>(
      () => BalanceScreenController(),
    );
  }
}
