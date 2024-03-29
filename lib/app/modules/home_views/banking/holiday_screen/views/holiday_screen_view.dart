import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/holiday_screen/views/holiday_list_screen_view.dart';
import '../controllers/holiday_screen_controller.dart';

class HolidayScreenView extends GetView<HolidayScreenController> {
  const HolidayScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HolidayScreenController controller = Get.put(HolidayScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/HolidayScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Holidays', onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/HolidayScreenView', context: context);
          // Get.back();
        }),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(left: 12.sp, right: 12.sp, top: 10.sp),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  height: height * 0.15,
                  child: AdService.nativeAd(
                      width: width, height: 52.sp, smallAd: true, radius: 15.sp, currentScreen: '/HolidayScreenView'
                  ),
                ),
                SizedBox(height: 18.sp),
                Text('Holidays Option', style: TextStyle(fontSize: 17.5.sp, fontWeight: FontWeight.w600, color: Colors.white),),
                SizedBox(height: 18.sp),
                item(
                  width: width,
                  imagePath: ConstantsImage.bank_holiday_icon,
                  title: 'Bank Holidays',
                  subtitle: 'Check 2023 bank holidays in india.',
                  onTap: () {
                    adService.checkCounterAd(currentScreen: '/HolidayScreenView', context: context, pageToNavigate: HolidayListScreenView(), argument: 'Bank Holidays');
                  }
                ),
                SizedBox(height: 17.sp),
                item(
                  width: width,
                  imagePath: ConstantsImage.stock_exchange_icon,
                  title: 'Stock Exchange Holidays',
                  subtitle: 'Stock Market holiday calendar.',
                  onTap: () {
                    adService.checkCounterAd(currentScreen: '/HolidayScreenView', pageToNavigate: HolidayListScreenView(), argument: 'Stock Exchange Holidays', context: context);
                    // Get.to(HolidayListScreenView(), arguments: 'Stock Exchange Holidays');
                  }
                ),
                SizedBox(height: 17.sp),
                item(
                  width: width,
                  imagePath: ConstantsImage.international_holiday_icon,
                  title: 'International Holidays',
                  subtitle: 'Best deals on International holidays.',
                  onTap: () {
                    adService.checkCounterAd(currentScreen: '/HolidayScreenView', context: context, pageToNavigate: HolidayListScreenView(), argument: 'International Holidays');
                  }
                ),
                SizedBox(height: 17.sp),
                item(
                  width: width,
                  imagePath: ConstantsImage.public_holiday_icon,
                  title: 'Public Holiday',
                  subtitle: 'List of Public and Government Holidays.',
                  onTap: () {
                    adService.checkCounterAd(currentScreen: '/HolidayScreenView', context: context, pageToNavigate: HolidayListScreenView(), argument: 'Public Holiday');
                  }
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget item({
    required double width,
    required String imagePath,
    required String title,
    required String subtitle,
    required Function() onTap
  }) {
    double itemHeight = 22.sp;
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: itemHeight.sp,
        width: width,
        decoration: BoxDecoration(
          gradient: ConstantsColor.buttonGradient,
          borderRadius: BorderRadius.circular(15.sp),
          boxShadow: ConstantsWidgets.boxShadow
        ),
        padding: EdgeInsets.symmetric(vertical: 17.sp),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.2.sp),
                  gradient: ConstantsColor.pinkGradient
              ),
              margin: EdgeInsets.symmetric(horizontal: 18.sp),
              padding: EdgeInsets.all(4.sp),
              child: Container(
                padding: EdgeInsets.all(14.5.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  color: ConstantsColor.backgroundDarkColor
                ),
                child: Image.asset(imagePath,
                  height: itemHeight.sp * 0.5,
                  width: itemHeight.sp * 0.5)
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.67,
                  child: Text(title,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                SizedBox(height: 10.sp),
                Container(
                    width: width * 0.67,
                    child: Text(subtitle,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

}
