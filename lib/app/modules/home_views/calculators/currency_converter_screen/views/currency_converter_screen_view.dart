import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/currency_converter_screen/views/select_currency_screen.dart';

import '../controllers/currency_converter_screen_controller.dart';

class CurrencyConverterScreenView extends GetView<CurrencyConverterScreenController> {
  const CurrencyConverterScreenView({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    CurrencyConverterScreenController controller = Get.put(CurrencyConverterScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/CurrencyConverterScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Currency Converter', isShareButtonEnable: false, onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/CurrencyConverterScreenView', context: context);
          // Get.back();
        }),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 25.sp),
          child: Column(
            children: [
              boxButton(
                  width: width,
                  title: 'From',
                  fieldName: controller.txtCurrency1,
                  onTap: () {
                    adService.checkCounterAd(currentScreen: '/CurrencyConverterScreenView', context: context, pageToNavigate: SelectCurrencyScreen(), argument: 'From');
                  }
              ),
              SizedBox(height: 17.sp),
              boxButton(
                  width: width,
                  title: 'To',
                  fieldName: controller.txtCurrency2,
                  onTap: () {
                    adService.checkCounterAd(currentScreen: '/CurrencyConverterScreenView', context: context, pageToNavigate: SelectCurrencyScreen(), argument: 'To');
                  }
              ),
              SizedBox(height: 17.sp),
              Obx(() => fields(
                width: width,
                title: controller.txtCurrency1.isNotEmpty ? controller.txtCurrency1['symbol'] : 'Amount',
                fieldName: 'Enter Amount',
                txtController: controller.enteredAmount,
              )),
              SizedBox(height: 17.sp),
              resultAmountBox(
                width: width,
                title: controller.txtCurrency2.isNotEmpty ? controller.txtCurrency2['symbol'] : 'Result Amount',
                data: controller.convertedAmount
              ),
              SizedBox(height: 25.sp),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  adService.checkCounterAd(currentScreen: '/CurrencyConverterScreenView', context: context);
                  if(controller.txtCurrency1.isNotEmpty && controller.txtCurrency2.isNotEmpty && controller.enteredAmount.value.text.length > 0) {
                    print('controller.txtCurrency1.value -> ${controller.txtCurrency1}');
                    print('controller.txtCurrency2.value -> ${controller.txtCurrency2}');
                    print('controller.amount.value.text -> ${controller.enteredAmount.value.text}');

                    controller.convertCurrency(
                        currency1: controller.txtCurrency1['symbol'],
                        currency2: controller.txtCurrency2['symbol'],
                        amount: controller.enteredAmount.value.text
                    );
                  } else {
                    Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.transparent,
                          actions: [
                            Column(
                              children: [
                                Container(
                                  width: 97.w,
                                  height: 95.w / 3,
                                  decoration: BoxDecoration(
                                      gradient: ConstantsColor.buttonGradient,
                                      borderRadius: BorderRadius.circular(18.sp),
                                      border: Border.all(color: Colors.white)
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Please Select First Three Fields.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.8.sp),),
                                ),
                                TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text('CLOSE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.8.sp),)
                                )
                              ],
                            )
                          ],
                        )
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: ConstantsColor.pinkGradient,
                      borderRadius: BorderRadius.circular(40.sp)
                  ),
                  padding: EdgeInsets.all(5.sp),
                  child: Container(
                    width: width * 0.35,
                    height: 28.sp,
                    decoration: BoxDecoration(
                        gradient: ConstantsColor.buttonGradient,
                        borderRadius: BorderRadius.circular(40.sp)
                    ),
                    alignment: Alignment.center,
                    child: Text('Convert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.sp),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget fields({required Rx<TextEditingController> txtController, required double width, String? fieldName, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17.sp),),
        SizedBox(height: 12.sp),
        Container(
          height: 30.sp,
          width: width * 0.95,
          decoration: BoxDecoration(
              gradient: ConstantsColor.buttonGradient,
              borderRadius: BorderRadius.circular(15.sp),
              boxShadow: ConstantsWidgets.boxShadow
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 15.sp),
              Expanded(
                child: TextField(
                  controller: txtController.value,
                  cursorColor: Colors.white,
                  style: TextStyle(fontSize: 16.5.sp, color: Colors.white, fontWeight: FontWeight.w400),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: fieldName,
                    hintStyle: TextStyle(fontSize: 16.5.sp, color: Colors.white60, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget boxButton({required double width, required RxMap<String, dynamic> fieldName, required String title, Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17.sp),),
        SizedBox(height: 12.sp),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 30.sp,
            width: width * 0.95,
            decoration: BoxDecoration(
                gradient: ConstantsColor.buttonGradient,
                borderRadius: BorderRadius.circular(15.sp),
                boxShadow: ConstantsWidgets.boxShadow
            ),
            padding: EdgeInsets.only(left: 15.sp),
            alignment: Alignment.centerLeft,
            child: Obx(() => Text(fieldName.value.isNotEmpty ? fieldName.value['name'] : 'Select Currency',
              style: TextStyle(fontSize: 16.5.sp, color:fieldName.value.isNotEmpty ? Colors.white : Colors.white60, fontWeight: FontWeight.w400),)),
          ),
        ),
      ],
    );
  }


  Widget resultAmountBox({required double width, required RxString data, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17.sp),),
        SizedBox(height: 12.sp),
        Container(
          height: 30.sp,
          width: width * 0.95,
          decoration: BoxDecoration(
              gradient: ConstantsColor.buttonGradient,
              borderRadius: BorderRadius.circular(15.sp),
              boxShadow: ConstantsWidgets.boxShadow
          ),
          padding: EdgeInsets.only(left: 15.sp),
          alignment: Alignment.centerLeft,
          child: Obx(() => Text(data.value, style: TextStyle(fontSize: 16.5.sp, color: data.value != '00' ? Colors.white : Colors.white60, fontWeight: FontWeight.w400),)),
        ),
      ],
    );
  }

}
