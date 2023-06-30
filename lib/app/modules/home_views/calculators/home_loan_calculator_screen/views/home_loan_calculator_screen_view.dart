import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import '../controllers/home_loan_calculator_screen_controller.dart';


class HomeLoanCalculatorScreenView extends GetView<HomeLoanCalculatorScreenController> {
  const HomeLoanCalculatorScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeLoanCalculatorScreenController controller = Get.put(HomeLoanCalculatorScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/HomeLoanCalculatorScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Home Loan Calculator', isShareButtonEnable: false, onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/HomeLoanCalculatorScreenView', context: context);
          // Get.back();
        }),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 25.sp),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                fields(
                    width: width,
                    title: 'Loan Amount',
                    fieldName: '00',
                    txtController: controller.txtLoanAmount
                ),
                SizedBox(height: 17.sp),
                fields(
                    width: width,
                    title: 'Interest %',
                    fieldName: '00',
                    txtController: controller.txtInterestAmount
                ),
                SizedBox(height: 17.sp),
                fields(
                    width: width,
                    title: 'Loan Time',
                    txtController: controller.txtLoanPeriod,
                    onTap: () {
                      controller.isYear.value =! controller.isYear.value;
                      controller.update();
                    }
                ),
                SizedBox(height: 20.sp),
                controller.bottomButtons(
                  context: context,
                  onTapBtn2: () {
                    adService.checkCounterAd(currentScreen: '/HomeLoanCalculatorScreenView', context: context);
                    double loanAmount = double.parse(controller.txtLoanAmount.value.text);
                    int loanMonth;
                    if(controller.isYear.value == true) {
                      loanMonth = int.parse(controller.txtLoanPeriod.value.text) * 12;
                    } else {
                      loanMonth = int.parse(controller.txtLoanPeriod.value.text);
                    }
                    print('loanYear -> $loanMonth');
                    // print('loanMonth -> $loanMonth');
                    double interestRate = double.parse(controller.txtInterestAmount.value.text) / 100 / 12;
                    print('interestRate -> $interestRate');
                    ///ama badhe loan year ni jgya pr month levanu
                    final emi = (loanAmount * interestRate * pow((1+interestRate), loanMonth) / (pow((1+interestRate), loanMonth) - 1));
                    print('emi -> $emi');

                    final totalAmount = emi * loanMonth;
                    print('totalAmount -> $totalAmount');
                    final interestAmount = totalAmount - loanAmount;
                    print('interestAmount -> $interestAmount');

                    controller.mapHomeLoan.updateAll((key, value) {
                      if(key == 'Loan Amount') {
                        return loanAmount.toStringAsFixed(2);
                      } else if(key == 'Interest %') {
                        return interestAmount.toStringAsFixed(2);
                      } else if(key == 'EMI') {
                        return emi.toStringAsFixed(2);
                      } else if(key == 'Total Amount') {
                        return totalAmount.toStringAsFixed(2);
                      } else if(key == 'Total Interest') {
                        return controller.txtInterestAmount.value.text;
                      } else {
                        return controller.isYear.value ? loanMonth.toString().split('.').first.toString() : loanMonth.toString();
                      }
                    });
                    // print('controller.mapHomeLoan -> ${controller.mapHomeLoan}');
                  }
                ),
                SizedBox(height: 20.sp),
                controller.homeLoanResult(loanMapData: controller.mapHomeLoan),
                SizedBox(height: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fields({required Rx<TextEditingController> txtController, required double width, String? fieldName, required String title, Function()? onTap}) {
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
              onTap != null ? Container(
                width: width * 0.52,
                child: Obx(() => TextField(
                  controller: txtController.value,
                  cursorColor: Colors.white,
                  style: TextStyle(fontSize: 16.5.sp, color: Colors.white, fontWeight: FontWeight.w400),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: controller.isYear.value ? 'Year' : 'Month',
                      hintStyle: TextStyle(fontSize: 16.5.sp, color: Colors.white60, fontWeight: FontWeight.w400),
                      border: InputBorder.none
                  ),
                  onChanged: (str) {

                  },
                )),
              ) : Expanded(
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
                  onChanged: (str) {

                  },
                ),
              ),
              SizedBox(width: 15.sp),
              onTap != null ? InkWell(
                onTap: onTap,
                child: Row(
                  children: [
                    Obx(() => Text('Year', style: TextStyle(fontSize: 16.sp, color: controller.isYear.value ? const Color.fromRGBO(223, 62, 62, 1) : Colors.white, fontWeight: FontWeight.w400)),),
                    SizedBox(width: 12.sp),
                    Image.asset(ConstantsImage.two_arrows_icon, height: 18.sp),
                    SizedBox(width: 12.sp),
                    Obx(() => Text('Month', style: TextStyle(fontSize: 16.sp, color: !controller.isYear.value ? const Color.fromRGBO(223, 62, 62, 1) : Colors.white, fontWeight: FontWeight.w400)),),
                  ],
                )
              ) : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

}
