import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';

import '../controllers/bottom_navigation_screen_controller.dart';

class BottomNavigationScreenView
    extends GetView<BottomNavigationScreenController> {
  const BottomNavigationScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BottomNavigationScreenController controller = Get.put(BottomNavigationScreenController());
    double height = 100.h;
    double width = 100.w;

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                physics: NeverScrollableScrollPhysics(  ),
                itemCount: controller.lstScreens.length,
                controller: controller.pageController,
                onPageChanged: (page) {
                  controller.tabIndex.value = page;
                },
                itemBuilder: (context, index) {
                  return controller.lstScreens[index];
                }
            ),
          ),
          _bottomNavigationBar(width: width)
        ],
      ),
      // bottomNavigationBar: _bottomNavigationBar(width: width),
    );
  }

  ///bottomnavigation bar
  _bottomNavigationBar({required double width}) {
    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleNavBar(
          activeIndex: controller.tabIndex.value,
          activeIcons: [
            Image.asset(ConstantsImage.bank_statement_icon, height: 22.sp, color: Colors.white),
            Image.asset(ConstantsImage.home_icon, width: 22.sp, color: Colors.white),
            Image.asset(ConstantsImage.bills_icon_icon, height: 22.sp, color: Colors.white)
          ],
          inactiveIcons: [
            Image.asset(ConstantsImage.bank_statement_icon, height: 22.sp),
            Image.asset(ConstantsImage.home_icon, height: 22.sp, color: const Color.fromRGBO(82, 74, 87, 1),),
            Image.asset(ConstantsImage.bills_icon_icon, height: 22.sp)
          ],
          circlPadding: EdgeInsets.all(controller.tabIndex.value == 0 ? 15.sp : 14.sp),
          circlBorderColor: Colors.green,
          circlBorderWidth: 2,
          circleGradient: ConstantsColor.pinkGradient,
          height: 32.sp,
          circleWidth: 31.sp,
          color: ConstantsColor.backgroundDarkColor,
          padding: EdgeInsets.only(left: 12.sp, right: 12.sp, bottom: 12.sp),
          cornerRadius: BorderRadius.circular(24.sp),
          onTap: (index) {
            controller.tabIndex.value = index;
            controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);

            print('controller.tabIndex.value -> ${controller.tabIndex.value}');
          },

        ),
        AdService.isBannerAdLoaded.value == true ? AdService.bannerAd(width: width) : SizedBox.shrink(),
      ],
    ));
  }

}
