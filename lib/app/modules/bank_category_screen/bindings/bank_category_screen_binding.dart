import 'package:get/get.dart';

import '../controllers/bank_category_screen_controller.dart';

class BankCategoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankCategoryScreenController>(
      () => BankCategoryScreenController(),
    );
  }
}
