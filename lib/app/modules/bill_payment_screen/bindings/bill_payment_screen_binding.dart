import 'package:get/get.dart';

import '../controllers/bill_payment_screen_controller.dart';

class BillPaymentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillPaymentScreenController>(
      () => BillPaymentScreenController(),
    );
  }
}
