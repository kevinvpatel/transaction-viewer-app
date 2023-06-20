import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/services.dart';
import 'package:transaction_viewer_app/app/modules/onboarding_screen/views/onboarding_screen_view.dart';
import '../controllers/permission_screen_controller.dart';


class PermissionScreenView extends GetView<PermissionScreenController> {
  const PermissionScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PermissionScreenController controller = Get.put(PermissionScreenController());
    double height = 100.h;
    double width = 100.w;

    return Scaffold(
      body: Container(
        color: ConstantsColor.backgroundDarkColor,
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 4,),
            Image.asset(ConstantsImage.get_permission_image),
            const Spacer(flex: 2,),
            Text('Get Permission', style: TextStyle(fontSize: 23.sp, color: ConstantsColor.purpleColor, fontWeight: FontWeight.w700),),
            SizedBox(height: 15.sp),
            Text('Account Balance Check All Bank app need to view SMS messages?',
                style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
            const Spacer(),
            InkWell(
              onTap: () async {
                await Permission.sms.request().then((permission) async {
                  print('val per -> ${permission.isGranted}');
                  if(permission.isGranted) {
                    Get.to(const OnboardingScreenView());
                  }
                });
              },
              child: Container(
                height: 30.sp,
                width: 70.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.sp),
                    gradient: ConstantsColor.buttonGradient,
                    boxShadow: const [BoxShadow(color: Colors.white12, offset: Offset(0, 0), blurRadius: 4, spreadRadius: 2)]
                ),
                child: Text('ENABLE SMS SERVICE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16.5.sp),),
              ),
            ),
            SizedBox(height: 20.sp),
            Text('Do not allow',
                style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
