import 'package:get/get.dart';

import '../controllers/car_loan_screen_controller.dart';

class CarLoanScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarLoanScreenController>(
      () => CarLoanScreenController(),
    );
  }
}
