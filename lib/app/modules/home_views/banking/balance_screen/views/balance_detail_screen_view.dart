import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/balance_screen/controllers/balance_screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class BalanceDetailScreenView extends GetView<BalanceScreenController> {
  const BalanceDetailScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BalanceScreenController controller = Get.put(BalanceScreenController());
    double height = 100.h;
    double width = 100.w;

    print('Get.argument -> ${Get.arguments}');
    final detail = Get.arguments;
    
    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/BalanceDetailScreenView');
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: detail['bank_name'], onTapBack: () => Get.back()),
        body: Container(
          margin: EdgeInsets.only(top: 15.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 38.sp,
                  width: 38.sp,
                  decoration: BoxDecoration(
                      gradient: ConstantsColor.pinkGradient,
                      borderRadius: BorderRadius.circular(100.sp)
                  ),
                  padding: EdgeInsets.all(5.sp),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: ConstantsColor.buttonGradient,
                      borderRadius: BorderRadius.circular(100.sp)
                    ),
                    padding: EdgeInsets.all(12.sp),
                    child: detail['icon'] != ""
                        ? ClipOval(
                        child: Image.asset('assets/bank icons/${detail['icon']}.png', width: 25.sp)
                    ) : Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Image.asset(ConstantsImage.bank_holiday_icon, width: 25.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.sp),
              fields(
                  width: width,
                  height: height,
                  title: 'Bank Balance',
                  data: detail['balance_check'],
                  onTap: () async {
                    adService.checkCounterAd(currentScreen: '/BalanceDetailScreenView');
                    Uri phoneno = Uri.parse('tel:${detail['balance_check']}');
                    if(await launchUrl(phoneno)) {
                      //dialer opened
                    }else{
                      //dailer is not opened
                      Fluttertoast.showToast(msg: 'Invalid Number ${detail['balance_check']}');
                    }
                  }
              ),
              SizedBox(height: 18.sp),
              fields(
                  width: width,
                  height: height,
                  title: 'Mini Statement',
                  data: detail['mini_statement'],
                  onTap: () async {
                    adService.checkCounterAd(currentScreen: '/BalanceDetailScreenView');
                    Uri phoneno = Uri.parse('tel:${detail['mini_statement']}');
                    if(await launchUrl(phoneno)) {
                    //dialer opened
                    }else{
                    //dailer is not opened
                      Fluttertoast.showToast(msg: 'Invalid Number ${detail['mini_statement']}');
                    }
                  }
              ),
              SizedBox(height: 18.sp),
              fields(
                  width: width,
                  height: height,
                  title: 'Customer Care Number',
                  data: detail['customer_care'],
                  onTap: () async {
                    adService.checkCounterAd(currentScreen: '/BalanceDetailScreenView');
                    Uri phoneno = Uri.parse('tel:${detail['customer_care']}');
                    if(await launchUrl(phoneno)) {
                    //dialer opened
                    }else{
                    //dailer is not opened
                      Fluttertoast.showToast(msg: 'Invalid Number ${detail['customer_care']}');
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bankItems({required double width, required String title, String? image}) {
    return Container(
      height: 33.sp,
      width: width,
      decoration: BoxDecoration(
          gradient: ConstantsColor.buttonGradient,
          borderRadius: BorderRadius.circular(14.sp),
          boxShadow: ConstantsWidgets.boxShadow
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 13.sp),
      child: Row(
        children: [
          Container(
            width: 28.sp,
            child: image != ""
                ? ClipOval(
                child: Image.asset('assets/bank icons/$image.png')
            ) : Padding(
              padding: EdgeInsets.all(8.sp),
              child: Image.asset(ConstantsImage.bank_holiday_icon, width: 25.sp),
            ),
          ),
          SizedBox(width: 15.sp),
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),)
        ],
      ),
    );
  }

  Widget fields({
    required double height,
    required double width,
    required String title,
    required String data,
    required Function() onTap
  }) {
    return Container(
      width: width - 17.sp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500, fontSize: 16.5.sp),),
          SizedBox(height: 13.sp),
          Container(
            width: width,
            height: 35.sp,
            decoration: BoxDecoration(
              gradient: ConstantsColor.buttonGradient,
              borderRadius: BorderRadius.circular(15.sp),
              boxShadow: ConstantsWidgets.boxShadow
            ),
            padding: EdgeInsets.only(left: 18.sp, right: 14.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(data,
                    style: TextStyle(color: Colors.white, fontSize: 16.5.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    width: 27.sp,
                    height: 27.sp,
                    decoration: BoxDecoration(
                      gradient: ConstantsColor.pinkGradient,
                      borderRadius: BorderRadius.circular(13.sp)
                    ),
                    padding: EdgeInsets.all(3.sp),
                    child: Container(
                      decoration: BoxDecoration(
                          color: ConstantsColor.backgroundDarkColor,
                          borderRadius: BorderRadius.circular(13.sp)
                      ),
                      padding: EdgeInsets.all(12.sp),
                      child: Image.asset(ConstantsImage.call_icon),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


}