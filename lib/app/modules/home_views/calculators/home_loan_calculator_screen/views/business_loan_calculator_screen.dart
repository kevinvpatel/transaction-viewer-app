import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/home_loan_calculator_screen/controllers/home_loan_calculator_screen_controller.dart';


class BusinessLoanCalculatorScreenView extends GetView<HomeLoanCalculatorScreenController> {
  const BusinessLoanCalculatorScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeLoanCalculatorScreenController controller = Get.put(HomeLoanCalculatorScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/BusinessLoanCalculatorScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Business Loan Calculator', isShareButtonEnable: false, onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/BusinessLoanCalculatorScreenView', context: context);
          // Get.back();
        }),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 15.sp),
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
                    title: 'Loan Year',
                    fieldName: 'Year',
                    txtController: controller.txtLoanPeriod,
                ),
                SizedBox(height: 20.sp),
                controller.bottomButtons(
                    context: context,
                    onTapBtn2: () {
                      adService.checkCounterAd(currentScreen: '/BusinessLoanCalculatorScreenView', context: context);
                      double loanAmount = double.parse(controller.txtLoanAmount.value.text);
                      int loanMonth = int.parse(controller.txtLoanPeriod.value.text);
                      double interestRate = double.parse(controller.txtInterestAmount.value.text) / 12 / 100;
                      final emi = loanAmount * interestRate * pow((1+interestRate), loanMonth) / (pow((1+interestRate), loanMonth) - 1);


                      final totalAmount = emi * loanMonth;
                      final interestAmount = totalAmount - loanAmount;


                      controller.mapBusinessLoan.updateAll((key, value) {
                        if(key == 'EMI') {
                          return emi.toStringAsFixed(2);
                        } else if(key == 'Interest %') {
                          return interestAmount.toStringAsFixed(2);
                        } else if(key == 'Loan Amount') {
                          return loanAmount.toStringAsFixed(2);
                        } else {
                          return totalAmount.toStringAsFixed(2);
                        }
                      });

                    }
                ),
                SizedBox(height: 20.sp),
                controller.homeLoanResult(loanMapData: controller.mapBusinessLoan),
                SizedBox(height: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fields({required Rx<TextEditingController> txtController, required double width, String? fieldName, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.5.sp),),
        SizedBox(height: 12.sp),
        Container(
          height: 28.sp,
          width: width * 0.95,
          decoration: BoxDecoration(
              gradient: ConstantsColor.buttonGradient,
              borderRadius: BorderRadius.circular(15.sp),
              boxShadow: ConstantsWidgets.boxShadow
          ),
          padding: EdgeInsets.only(left: 15.sp),
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
      ],
    );
  }

}