import 'package:get/get.dart';

import '../controllers/currency_converter_screen_controller.dart';

class CurrencyConverterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrencyConverterScreenController>(
      () => CurrencyConverterScreenController(),
    );
  }
}
