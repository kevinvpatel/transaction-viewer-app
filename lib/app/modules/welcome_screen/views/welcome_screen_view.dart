import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bottom_navigation_screen/views/bottom_navigation_screen_view.dart';
import '../controllers/welcome_screen_controller.dart';

class WelcomeScreenView extends GetView<WelcomeScreenController> {
  const WelcomeScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    WelcomeScreenController controller = Get.put(WelcomeScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 4),
            Container(padding: EdgeInsets.symmetric(horizontal: 10.sp) ,child: Image.asset(ConstantsImage.welcome_image, width: width * 0.52)),
            SizedBox(height: 18.sp),
            Text('Welcome!', textAlign: TextAlign.center ,style: TextStyle(fontSize: 23.sp, color: Colors.white, fontWeight: FontWeight.w700),),
            SizedBox(height: 12.sp),
            Text('Bank Balance Checker will help you to give a \n'
                'miss call to the official number of your bank \n'
                'and in turn, the bank will reply via SMS with \n'
                'your account balance enquiry app.',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w400)
            ),
            SizedBox(height: 22.sp),
            ConstantsWidgets.gradientButton(
                title: 'GET STARTED',
                titleSize: 15.5.sp,
                height: 28.sp,
                width: width * 0.42,
                onTap: () {
                  Get.to(const BottomNavigationScreenView());
                  adService.checkCounterAd(currentScreen: '/BottomNavigationScreenView');
                }
            ),
            SizedBox(height: 28.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstantsWidgets.gradientButton(
                    title: 'Share',
                    suffixChild: Image.asset(ConstantsImage.share_icon, height: 22.sp),
                    height: 28.sp,
                    width: width * 0.22,
                    onTap: () {
                      adService.checkCounterAd(currentScreen: '/WelcomeScreenView');
                    }
                ),
                SizedBox(width: 25.sp),
                ConstantsWidgets.gradientButton(
                    title: 'Rate',
                    suffixChild: Image.asset(ConstantsImage.rate_icon, height: 22.sp),
                    height: 28.sp,
                    width: width * 0.22,
                    onTap: () {

                      adService.checkCounterAd(currentScreen: '/WelcomeScreenView');
                    }
                ),
              ],
            ),
            SizedBox(height: 18.sp),
            ConstantsWidgets.gradientButton(
                title: 'Privacy Policy',
                suffixChild: Image.asset(ConstantsImage.privacy_policy_icon, height: 22.sp),
                height: 28.sp,
                width: width * 0.34,
                onTap: () {

                  adService.checkCounterAd(currentScreen: '/WelcomeScreenView');
                }
            ),
            const Spacer(flex: 2),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                  text: 'Do not share Your Bank \n',
                  style: TextStyle(fontSize: 15.8.sp, color: Colors.white38, fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(
                        text: 'Account Number & ',
                        style: TextStyle(fontSize: 15.8.sp, color: Colors.white38, fontWeight: FontWeight.w400)
                    ),
                    TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(fontSize: 15.8.sp, color: Colors.white, fontWeight: FontWeight.w400)
                    ),
                  ]
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
