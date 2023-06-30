import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/holiday_screen/controllers/holiday_screen_controller.dart';

class HolidayListScreenView extends GetView<HolidayScreenController> {
  const HolidayListScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HolidayScreenController controller = Get.put(HolidayScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/HolidayListScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: ConstantsColor.backgroundDarkColor,
          appBar: ConstantsWidgets.appBar(title: Get.arguments.toString(), onTapBack: () {
            adService.checkBackCounterAd(currentScreen: '/HolidayListScreenView', context: context);
            // Get.back();
          }),
          body: Container(
            child: ListView.separated(
                padding: EdgeInsets.only(left: 12.sp, right: 12.sp, top: 15.sp, bottom: 15.sp),
                physics: BouncingScrollPhysics(),
                itemCount: controller.listHolidays.length,
                itemBuilder: (context, index) {
                  String title = controller.listHolidays[index]['HoliDayName'];
                  String subtitle = controller.listHolidays[index]['FulltDate'];
                  return item(title: title, subtitle: subtitle, width: width);
                },
                separatorBuilder: (context, index) => SizedBox(height: 14.sp),
            ),
          )
      ),
    );
  }

  Widget item({required double width, required String title, required String subtitle}) {
    double itemHeight = 24.sp;
    return Container(
      // height: itemHeight.sp,
      width: width,
      decoration: BoxDecoration(
          gradient: ConstantsColor.buttonGradient,
          borderRadius: BorderRadius.circular(14.sp),
          boxShadow: ConstantsWidgets.boxShadow
      ),
      padding: EdgeInsets.only(left: 15.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15.sp),
          Container(
              width: width * 0.68,
              child: Text(title,
                style: TextStyle(fontSize: 17.5.sp, fontWeight: FontWeight.w400, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          SizedBox(height: 10.sp),
          Container(
              width: width * 0.68,
              child: Text(subtitle,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300, color: Colors.white60),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          SizedBox(height: 15.sp),
        ],
      ),
    );
  }

}