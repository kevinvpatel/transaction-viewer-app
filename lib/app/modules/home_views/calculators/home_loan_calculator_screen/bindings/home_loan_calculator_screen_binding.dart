import 'package:get/get.dart';

import '../controllers/home_loan_calculator_screen_controller.dart';

class HomeLoanCalculatorScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeLoanCalculatorScreenController>(
      () => HomeLoanCalculatorScreenController(),
    );
  }
}
