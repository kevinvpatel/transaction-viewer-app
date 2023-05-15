import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SplashScreenController controller = Get.put(SplashScreenController());
    double height = 100.h;
    double width = 100.w;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
            child: Image.asset(ConstantsImage.first_screen, fit: BoxFit.fitWidth, width: width)
        ),
      ),
    );
  }

}
