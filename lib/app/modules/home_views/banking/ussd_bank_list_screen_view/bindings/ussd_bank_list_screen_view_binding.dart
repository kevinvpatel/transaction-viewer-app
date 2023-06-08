import 'package:get/get.dart';

import '../controllers/ussd_bank_list_screen_view_controller.dart';

class UssdBankListScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UssdBankListScreenViewController>(
      () => UssdBankListScreenViewController(),
    );
  }
}
