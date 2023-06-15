import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/onboarding_screen/views/screens.dart';
import 'package:transaction_viewer_app/app/modules/welcome_screen/views/welcome_screen_view.dart';

import '../controllers/onboarding_screen_controller.dart';

class OnboardingScreenView extends GetView<OnboardingScreenController> {
  const OnboardingScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OnboardingScreenController controller = Get.put(OnboardingScreenController());
    double height = 100.h;
    double width = 100.w;

    return WillPopScope(
      onWillPop: () {
        controller.selectedPage.value--;
        Screens.pageController.animateToPage(controller.selectedPage.value, duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 3),
            onBoardingScreens(),
            SizedBox(height: 10.sp),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                      controller: Screens.pageController,  // PageController
                      count: controller.lstScreens.length,
                      effect: ExpandingDotsEffect(
                          activeDotColor: ConstantsColor.purpleColor,
                          dotHeight: 12.5.sp,
                          expansionFactor: 5,
                          dotWidth: 12.5.sp
                      ),  // your preferred effect
                      onDotClicked: (index){
                      }
                  ),
                  ConstantsWidgets.gradientButton(
                    title: 'NEXT',
                    suffixChild: Image.asset(ConstantsImage.next_icon, height: 20.sp),
                    height: 28.sp,
                    width: 19.w,
                    onTap: () {
                      AdService adService = AdService();
                      adService.checkCounterAd();
                      if(controller.selectedPage.value == controller.lstScreens.length - 1) {
                        Get.to(WelcomeScreenView());
                      } else {
                        Screens.pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                      }
                    }
                  ),
                ],
              ),
            ),
            SizedBox(height: 34.sp),
          ],
        ),
      ),
    );
  }

  onBoardingScreens() {
    return Container(
      height: 75.h,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: Screens.pageController,
            scrollDirection: Axis.horizontal,
            itemCount: controller.lstScreens.length,
            onPageChanged: (page) {
              controller.selectedPage.value = page;
            },
            itemBuilder: (context, index) => controller.lstScreens[index]
        )
      ),
    );
  }

}
