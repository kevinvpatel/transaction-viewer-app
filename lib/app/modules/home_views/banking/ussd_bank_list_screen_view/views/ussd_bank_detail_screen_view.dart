import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/ussd_bank_list_screen_view/controllers/ussd_bank_list_screen_view_controller.dart';

class UssdBankDetailScreenViewView extends GetView<UssdBankListScreenViewController> {
  const UssdBankDetailScreenViewView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UssdBankListScreenViewController controller = Get.put(UssdBankListScreenViewController());
    double height = 100.h;
    double width = 100.w;

    print('Get.argu -> ${Get.arguments}');
    Map<String, dynamic> mapData = Get.arguments;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/UssdBankDetailScreenViewView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: mapData['vName'], onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/UssdBankDetailScreenViewView', context: context);
          // Get.back();
        }),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(top: 8.sp),
          child: GetBuilder(
            init: UssdBankListScreenViewController(),
            builder: (controller) {
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: 12.sp, right: 12.sp, top: 10.sp, bottom: 17.sp),
                itemCount: mapData.length,
                itemBuilder: (context, index) {
                  List bankKeyDetail = mapData.keys.toList();
                  List bankValueDetail = mapData.values.toList();
                  print('bankKeyDetail -> ${bankKeyDetail}');
                  print('bankValueDetail -> ${bankValueDetail}');
                  if(bankKeyDetail[index] == 'vName' || bankKeyDetail[index] == 'vBalance' || bankKeyDetail[index] == 'vStatement'
                      || bankKeyDetail[index] == 'vCustomerCare' || bankKeyDetail[index] == 'NetBanking') {
                    return Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 12.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.sp),
                          gradient: ConstantsColor.buttonGradient,
                          boxShadow: ConstantsWidgets.boxShadow
                      ),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bankKeyDetail[index], style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500),),
                          SizedBox(height: 10.sp),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: ConstantsColor.backgroundDarkColor,
                              borderRadius: BorderRadius.circular(15.sp),
                            ),
                            padding: EdgeInsets.only(left: 15.sp, top: 12.sp, bottom: 12.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: width * 0.75,
                                    child: Text(bankValueDetail[index].toString(), style: TextStyle(color: Colors.white70, fontSize: 16.sp, fontWeight: FontWeight.w400),)
                                ),
                                bankKeyDetail[index] != 'vName' ? InkWell(
                                  onTap: () {
                                    adService.checkCounterAd(currentScreen: '/UssdBankDetailScreenViewView', context: context);
                                    Fluttertoast.showToast(msg: "${bankValueDetail[index].toString()}  Copied Successfully");
                                    Clipboard.setData(ClipboardData(text: bankValueDetail[index].toString()));
                                  },
                                  child: SizedBox(
                                    height: width * 0.08,
                                    width: width * 0.09,
                                    child: Icon(Icons.copy, size: 18.sp, color: Colors.white70),
                                  ),
                                ) : const SizedBox()
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
                separatorBuilder: (context, index) {
                  List bankKeyDetail = mapData.keys.toList();
                  if(bankKeyDetail[index] == 'vName' || bankKeyDetail[index] == 'vBalance' || bankKeyDetail[index] == 'vStatement'
                      || bankKeyDetail[index] == 'vCustomerCare' || bankKeyDetail[index] == 'NetBanking') {
                    return SizedBox(height: 15.sp,);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}