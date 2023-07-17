import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/views/loading_screen.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/controllers/bank_statement_screen_controller.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/views/bank_statement_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/bill_payment_screen/views/bill_payment_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/home_views/home_screen/views/home_screen_view.dart';

import '../controllers/bottom_navigation_screen_controller.dart';

class BottomNavigationScreenView
    extends GetView<BottomNavigationScreenController> {
  const BottomNavigationScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BottomNavigationScreenController controller = Get.put(BottomNavigationScreenController());
    double height = 100.h;
    double width = 100.w;

    return WillPopScope(

      onWillPop: () {
        if(Get.currentRoute == '/BottomNavigationScreenView') {
          Get.bottomSheet(
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp)),
                  boxShadow: [BoxShadow(offset: Offset(0, -1), color: Colors.white70, spreadRadius: 0, blurRadius: 1)],
                  gradient: ConstantsColor.buttonGradient
                ),
                width: width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 38),
                    Text('THANK YOU', style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor),),
                    const SizedBox(height: 15),
                    Text('VISIT AGAIN !', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300, color: ConstantsColor.purpleColor),),
                    const SizedBox(height: 15),
                    Text('Are you sure, You Want to Exit ?', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300, color: ConstantsColor.purpleColor),),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => SystemNavigator.pop(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ConstantsColor.purpleColor,
                                borderRadius: BorderRadius.circular(25.sp)
                              ),
                              width: width * 0.38,
                              alignment: Alignment.center,
                              child: Text('Exit', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 22.sp),
                          InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.sp)
                              ),
                              width: width * 0.38,
                              alignment: Alignment.center,
                              child: Text('Cancel', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.deepPurple.shade900),),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              )
          );
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        body: Column(
          children: [
            GetBuilder(
              init: BottomNavigationScreenController(),
              builder: (bottomNavigationScreenController) {
                return Expanded(
                  child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(  ),
                      itemCount: controller.lstScreens.length,
                      controller: controller.pageController,
                      onPageChanged: (page) {
                        controller.bottomNavigationTabIndex.value = page;
                        bottomNavigationScreenController.update();
                      },
                      itemBuilder: (context, index) {
                        if(index == 0) {
                          if(bottomNavigationScreenController.percentage.value.toStringAsFixed(0) != '100') {
                            return LoadingScreenView();
                          } else {
                            return BankStatementScreenView();
                          }
                        } else if(index == 2) {
                          if(bottomNavigationScreenController.percentage.value.toStringAsFixed(0) != '100') {
                            return LoadingScreenView();
                          } else {
                            return BillPaymentScreenView();
                          }
                        } else {
                          return HomeScreenView();
                        }
                      }
                  ),
                );
              }
            ),
            _bottomNavigationBar(width: width)
          ],
        ),
        // bottomNavigationBar: _bottomNavigationBar(width: width),
      ),
    );
  }

  ///bottomnavigation bar
  _bottomNavigationBar({required double width}) {
    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleNavBar(
          activeIndex: controller.bottomNavigationTabIndex.value,
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
          circlPadding: EdgeInsets.all(controller.bottomNavigationTabIndex.value == 0 ? 15.sp : 14.sp),
          circlBorderColor: Colors.green,
          circlBorderWidth: 2,
          circleGradient: ConstantsColor.pinkGradient,
          height: 32.sp,
          circleWidth: 31.sp,
          color: ConstantsColor.backgroundDarkColor,
          padding: EdgeInsets.only(left: 12.sp, right: 12.sp, bottom: 12.sp),
          cornerRadius: BorderRadius.circular(24.sp),
          onTap: (index) {
            controller.bottomNavigationTabIndex.value = index;
            controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 10), curve: Curves.linearToEaseOut);

            print('controller.tabIndex.value -> ${controller.bottomNavigationTabIndex.value}');
          },

        ),
        AdService.bannerAd(width: width, currentScreen: '/BottomNavigationScreenView'),
      ],
    ));
  }

}
