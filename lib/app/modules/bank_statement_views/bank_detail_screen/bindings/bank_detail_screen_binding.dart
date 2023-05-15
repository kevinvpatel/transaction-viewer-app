import 'package:get/get.dart';

import '../controllers/bank_detail_screen_controller.dart';

class BankDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankDetailScreenController>(
      () => BankDetailScreenController(),
    );
  }
}
