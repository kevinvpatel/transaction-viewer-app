import 'package:get/get.dart';
import 'package:transaction_viewer_app/app/modules/permission_screen/views/permission_screen_view.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController


  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 2000), () {
      Get.to(PermissionScreenView());
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
