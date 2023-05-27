import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transaction_viewer_app/app/modules/bottom_navigation_screen/views/bottom_navigation_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/permission_screen/views/permission_screen_view.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController


  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 2000), () async {
      var status = await Permission.sms.status;
      if(status.isGranted) {
        Get.to(const BottomNavigationScreenView());
      } else {
        Get.to(const PermissionScreenView());
      }
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
