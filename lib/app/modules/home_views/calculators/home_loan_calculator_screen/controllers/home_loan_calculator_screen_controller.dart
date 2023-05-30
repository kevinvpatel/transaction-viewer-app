import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';

class HomeLoanCalculatorScreenController extends GetxController {
  //TODO: Implement HomeLoanCalculatorScreenController

  ///HomeLoan
  Rx<TextEditingController> txtLoanAmount = TextEditingController().obs;
  Rx<TextEditingController> txtInterestAmount = TextEditingController().obs;
  Rx<TextEditingController> txtLoanYear = TextEditingController().obs;
  Rx<TextEditingController> txtLoanRepayYear = TextEditingController().obs;
  RxBool isYear = true.obs;

  RxInt loanAmount = 00.obs;
  RxInt interestAmount = 00.obs;
  RxInt loanYear = 00.obs;


  ///FD Calculator
  Rx<TextEditingController> txtDepositAmount = TextEditingController().obs;
  Rx<TextEditingController> txtInterestRate = TextEditingController().obs;
  Rx<TextEditingController> txtPeriodInMonth = TextEditingController().obs;


  Widget bottomButtons({required Function() onTapBtn2}) {
    double width = 100.w;
    return Row(
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            txtLoanAmount.value.clear();
            txtInterestAmount.value.clear();
            txtLoanYear.value.clear();
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: ConstantsColor.pinkGradient,
                borderRadius: BorderRadius.circular(40.sp)
            ),
            padding: EdgeInsets.all(5.sp),
            child: Container(
              width: width * 0.35,
              height: 28.5.sp,
              decoration: BoxDecoration(
                  gradient: ConstantsColor.buttonGradient,
                  borderRadius: BorderRadius.circular(40.sp)
              ),
              alignment: Alignment.center,
              child: Text('Reset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.sp),),
            ),
          ),
        ),
        SizedBox(width: 17.sp),
        InkWell(
          onTap: onTapBtn2,
          child: Container(
            decoration: BoxDecoration(
                gradient: ConstantsColor.pinkGradient,
                borderRadius: BorderRadius.circular(40.sp)
            ),
            padding: EdgeInsets.all(5.sp),
            child: Container(
              width: width * 0.5,
              height: 29.sp,
              decoration: BoxDecoration(
                  gradient: ConstantsColor.buttonGradient,
                  borderRadius: BorderRadius.circular(40.sp)
              ),
              alignment: Alignment.center,
              child: Text('Calculate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.sp),),
            ),
          ),
        ),
      ],
    );
  }

  RxMap<String, dynamic> mapHomeLoan = {
    'Loan Amount' : '00',
    'Interest %' : '00',
    'EMI' : '00',
    'Total Amount' : '00',
    'Total Interest' : '00',
    'Period (Months)' : '00',
  }.obs;

  RxMap<String, dynamic> mapBusinessLoan = {
    'Loan Amount' : '00',
    'EMI' : '00',
    'Interest %' : '00',
    'Total Amount' : '00',
  }.obs;

  RxMap<String, dynamic> mapFdLoan = {
    'Total Investment Value' : '00',
    'Maturity Amount' : '00',
  }.obs;

  RxMap<String, dynamic> mapRdLoan = {
    'Total Investment Value' : '00',
    'Maturity Amount' : '00',
  }.obs;

  Widget homeLoanResult({required RxMap<String, dynamic> loanMapData}) {
    return Container(
      decoration: BoxDecoration(
        gradient: ConstantsColor.buttonGradient,
        borderRadius: BorderRadius.circular(15.sp),
        boxShadow: ConstantsWidgets.boxShadow
      ),
      padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Results For Your Loan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17.sp),),
          SizedBox(height: 17.sp),
          Container(
            height: 100.h * 0.22,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(loanMapData.length, (index) {
                  List listKeys = loanMapData.keys.toList();
                  List listValues = loanMapData.values.toList();
                  return textRow(leftText: listKeys[index], rightText: listValues[index].toString());
                }),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget textRow({required String leftText, required String rightText}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(leftText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp),),
          Text(rightText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp),),
        ],
      ),
    );
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
