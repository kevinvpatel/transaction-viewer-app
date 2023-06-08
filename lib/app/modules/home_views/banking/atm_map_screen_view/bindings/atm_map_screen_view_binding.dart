import 'package:get/get.dart';

import '../controllers/atm_map_screen_view_controller.dart';

class AtmMapScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AtmMapScreenViewController>(
      () => AtmMapScreenViewController(),
    );
  }
}
