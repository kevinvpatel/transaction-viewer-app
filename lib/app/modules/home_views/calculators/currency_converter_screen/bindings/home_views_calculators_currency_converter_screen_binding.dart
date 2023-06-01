import 'package:get/get.dart';

import '../controllers/home_views_calculators_currency_converter_screen_controller.dart';

class HomeViewsCalculatorsCurrencyConverterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewsCalculatorsCurrencyConverterScreenController>(
      () => HomeViewsCalculatorsCurrencyConverterScreenController(),
    );
  }
}
