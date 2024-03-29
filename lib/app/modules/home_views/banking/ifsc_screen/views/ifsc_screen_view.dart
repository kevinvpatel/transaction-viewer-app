import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/ifsc_screen/views/ifsc_code_bank_result.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/ifsc_screen/views/select_bank_screen.dart';

import '../controllers/ifsc_screen_controller.dart';

  class IfscScreenView extends GetView<IfscScreenController> {
  const IfscScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    IfscScreenController controller = Get.put(IfscScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/IfscScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'IFSC Code Details', onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/IfscScreenView', context: context);
          // Get.back();
        }),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 15.sp),
          child: Column(
            children: [
              Container(
                height: height * 0.17,
                width: width,
                child: AdService.nativeAd(width: width, height: 52.sp, smallAd: true, radius: 15.sp, currentScreen: '/IfscScreenView'),
              ),
              SizedBox(height: 17.sp),
              fields(
                width: width,
                height: height,
                title: 'Bank Name',
                fieldName: controller.bankName,
                onTap: () {
                  adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context, pageToNavigate: SelectBankScreenView(), argument: 'Select Bank');
                }
              ),
              SizedBox(height: 17.sp),
              fields(
                width: width,
                height: height,
                title: 'State Name',
                fieldName: controller.stateName,
                onTap: () {
                  if(controller.bankName.value == 'Select Bank') {
                    dialog(title: 'Please Select Above Field...');
                    adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context);
                  } else {
                    adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context, pageToNavigate: SelectBankScreenView(), argument: 'Select State');
                  }
                }
              ),
              SizedBox(height: 17.sp),
              fields(
                width: width,
                height: height,
                title: 'District Name',
                fieldName: controller.districtName,
                onTap: () {
                  if(controller.bankName.value != 'Select Bank' && controller.stateName.value != 'Select State') {
                    adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context, pageToNavigate: SelectBankScreenView(), argument: 'Select District');
                  } else {
                    adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context);
                    dialog(title: 'Please Select Above Field...');
                  }
                }
              ),
              SizedBox(height: 17.sp),
              fields(
                width: width,
                height: height,
                title: 'Branch Name',
                fieldName: controller.branchName,
                onTap: () {
                  if(controller.bankName.value != 'Select Bank' && controller.stateName.value != 'Select State' && controller.districtName.value != 'Select District') {
                    adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context, pageToNavigate: SelectBankScreenView(), argument: 'Select Branch');
                  } else {
                    adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context);
                    dialog(title: 'Please Select Above Field...');
                  }
                }
              ),

              Spacer(),
              ConstantsWidgets.gradientButton(
                  title: 'DONE',
                  titleSize: 15.5.sp,
                  height: 28.sp,
                  width: width * 0.95,
                  borderRadius: 15.0,
                  onTap: () {
                    if(controller.bankName.value != 'Select Bank' && controller.stateName.value != 'Select State'
                        && controller.districtName.value != 'Select District' && controller.branchName.value != 'Select Branch') {
                      adService.checkCounterAd(
                          currentScreen: '/IfscScreenView',
                          context: context,
                          pageToNavigate: IfscCodeBankResultView(),
                          argument: {
                            'bank_name' : controller.bankName.value,
                            'state_name' : controller.stateName.value,
                            'district_name' : controller.districtName.value,
                            'branch_name' : controller.branchName.value,
                            'details' : controller.detailMap,
                          }
                      );
                    } else {
                      adService.checkCounterAd(currentScreen: '/IfscScreenView', context: context);
                      dialog(title: 'Please Select Above Fields...');
                    }

                    // print('bankName -> ${controller.bankName.value}');
                    // print('stateName -> ${controller.stateName.value}');
                    // print('districtName -> ${controller.districtName.value}');
                    // print('branchName -> ${controller.branchName.value}');
                    // print('detailMap -> ${controller.detailMap}');
                  }
              ),
              SizedBox(height: 12.sp),

            ]
          ),
        ),
      ),
    );
  }




  Widget fields({required double height, required double width, required String title, required RxString fieldName, required Function() onTap}) {
    return Container(
      width: width - 17.sp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500, fontSize: 16.5.sp),),
          SizedBox(height: 13.sp),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.all(0.0),
                elevation: 1,
                shadowColor: Colors.white
            ),
            child: Ink(
              decoration: const BoxDecoration(
                gradient: ConstantsColor.buttonGradient,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 18.sp),
                  Container(
                    height: height * 0.068,
                    alignment: Alignment.center,
                    child: Obx(() => Text(
                      fieldName.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    )),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Image.asset(ConstantsImage.arrow_right_icon, height: 22.sp),
                    onPressed: null,
                  ),
                  SizedBox(width: 10.sp)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  dialog({required String title}) {
    Get.dialog(
        AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            // height: 13.h,
            width: 80.w,
            decoration: BoxDecoration(
                gradient: ConstantsColor.buttonGradient,
                borderRadius: BorderRadius.circular(18.sp),
                border: Border.all(color: Colors.white)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 22.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.sp),
                  child: Text(title, style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                ),
                SizedBox(height: 25.sp),
                const Divider(color: Colors.white, height: 0, thickness: 1),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 80.w,
                    height: 26.sp,
                    alignment: Alignment.center,
                    child: Text('OK', style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w400),),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


}
