import 'package:get/get.dart';

import '../controllers/credit_card_screen_controller.dart';

class CreditCardScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCardScreenController>(
      () => CreditCardScreenController(),
    );
  }
}
