import 'package:get/get.dart';

import '../controllers/bank_statement_screen_controller.dart';

class BankStatementScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankStatementScreenController>(
      () => BankStatementScreenController(),
    );
  }
}
