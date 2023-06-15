import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/home_loan_calculator_screen/controllers/home_loan_calculator_screen_controller.dart';

class FDLoanCalculatorScreenView extends GetView<HomeLoanCalculatorScreenController> {
  const FDLoanCalculatorScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeLoanCalculatorScreenController controller = Get.put(HomeLoanCalculatorScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd();
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'FD Calculator', isShareButtonEnable: false, onTapBack: () {
          adService.checkBackCounterAd();
          Get.back();
        }),
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
                fieldName: 'Month',
                txtController: controller.txtPeriodInMonth,
              ),
              SizedBox(height: 17.sp),
              dropDownField(title: 'Period of Depositor', width: width),
              SizedBox(height: 20.sp),
              controller.bottomButtons(
                  onTapBtn2: () {
                    adService.checkCounterAd();
                    double depositAmount = double.parse(controller.txtDepositAmount.value.text);
                    int loanMonth = int.parse(controller.txtPeriodInMonth.value.text);
                    double interestRate = double.parse(controller.txtInterestRate.value.text) / 100;
                    int period;
                    if(controller.selectedPeriod.value == 'Monthly') {
                      period = 1;
                    } else if(controller.selectedPeriod.value == 'Quarterly') {
                      period = 3;
                    } else if(controller.selectedPeriod.value == 'Half-Yearly') {
                      period = 6;
                    } else {
                      period = 12;
                    }

                    final maturityAmount = depositAmount * pow(1 + interestRate / period, period * loanMonth);

                    final totalInvestmentValue = maturityAmount - depositAmount;


                    controller.mapFdLoan.updateAll((key, value) {
                      if(key == 'Total Investment Value') {
                        return totalInvestmentValue.toStringAsFixed(2);
                      } else {
                        return maturityAmount.toStringAsFixed(2);
                      }
                    });
                  }
              ),
              SizedBox(height: 20.sp),
              controller.homeLoanResult(loanMapData: controller.mapFdLoan),
              Spacer(),
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


  Widget dropDownField({required String title, required double width}) {
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
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(flex: 3,
                  child: Center(
                    child: Text('Compound Frequency',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.5.sp),),
                  )
                ),
                VerticalDivider(
                  indent: 12.sp,
                  endIndent: 12.sp,
                  color: Colors.white,
                  thickness: 0.7,
                ),
                Expanded(
                  flex: 2,
                  child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        controller.selectedPeriod.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.transparent,
                        ),
                      ),
                      items: controller.listPeriods.map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.5.sp),
                        ),
                      )).toList(),
                      value: controller.selectedPeriod.value,
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down_outlined),
                        iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white,
                      ),
                      onChanged: (value) {
                        controller.selectedPeriod.value = value as String;
                      },
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              gradient: ConstantsColor.buttonGradient,
                              boxShadow: [BoxShadow(
                                  color: Colors.white30,
                                  blurRadius: 4,
                                  spreadRadius: 1
                              )]
                          )
                      ),
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.only(left: 18.sp),
                        width: width * 0.1,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        // selectedMenuItemBuilder: (context, child) {
                        //   return Container(
                        //     child: child,
                        //   );
                        // },
                        height: 40,
                      ),
                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }


}