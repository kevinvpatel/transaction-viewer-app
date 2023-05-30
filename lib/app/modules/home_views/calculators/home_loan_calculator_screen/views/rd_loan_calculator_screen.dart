import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/home_loan_calculator_screen/controllers/home_loan_calculator_screen_controller.dart';

class RDLoanCalculatorScreenView extends GetView<HomeLoanCalculatorScreenController> {
  const RDLoanCalculatorScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeLoanCalculatorScreenController controller = Get.put(HomeLoanCalculatorScreenController());
    double height = 100.h;
    double width = 100.w;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: 'FD Calculator', isShareButtonEnable: false, onTapBack: () => Get.back()),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 15.sp),
        child: Column(
          children: [
            fields(
                width: width,
                title: 'Deposit Amount',
                fieldName: '00',
                txtController: controller.txtDepositAmount
            ),
            SizedBox(height: 17.sp),
            fields(
                width: width,
                title: 'Interest Rate% (p.a)',
                fieldName: '00',
                txtController: controller.txtInterestRate
            ),
            SizedBox(height: 17.sp),
            fields(
              width: width,
              title: 'Period In Month',
              fieldName: 'Year',
              txtController: controller.txtPeriodInMonth,
            ),
            // SizedBox(height: 17.sp),
            // fields(
            //     width: width,
            //     title: 'Loan Repay Year',
            //     fieldName: 'Year',
            //     txtController: controller.txtLoanRepayYear,
            // ),
            SizedBox(height: 20.sp),
            controller.bottomButtons(
                onTapBtn2: () {
                  double depositAmount = double.parse(controller.txtDepositAmount.value.text);
                  int loanMonth = int.parse(controller.txtPeriodInMonth.value.text);

                  double interestRate = double.parse(controller.txtInterestRate.value.text) / 100;
                  final maturityAmount = depositAmount * pow(1 + interestRate / 4, (4 * loanMonth / 12));
                  print('maturityAmount -> ${maturityAmount}');

                  final totalInvestmentValue = maturityAmount + depositAmount;
                  print('totalInvestmentValue -> ${totalInvestmentValue}');


                  controller.mapRdLoan.updateAll((key, value) {
                    if(key == 'Total Investment Value') {
                      return totalInvestmentValue.toStringAsFixed(2);
                    } else {
                      return maturityAmount.toStringAsFixed(2);
                    }
                  });
                }
            ),
            SizedBox(height: 20.sp),
            controller.homeLoanResult(loanMapData: controller.mapRdLoan),
            Spacer(),
          ],
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