import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/controllers/bank_statement_screen_controller.dart';

class LoadingScreenView extends GetView<BankStatementScreenController> {
  const LoadingScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BankStatementScreenController controller = Get.put(BankStatementScreenController());
    double height = 100.h;
    double width = 100.w;



    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: 'Balance Check'),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15.sp),
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 7.sp,
                width: width * 0.7,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.sp),
                  child: LinearProgressIndicator(
                    minHeight: 5.sp,
                    value: controller.percentage.value / 100,
                    color: ConstantsColor.purpleColor,
                    backgroundColor: Colors.white38,
                  ),
                ),
              ),

              SizedBox(height: 12.sp),
              Text('Loading Messsages',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp)),
              Text('Please Wait...',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp)),
              SizedBox(height: 12.sp),
              Text('(${controller.percentage.value.toStringAsFixed(2)} %)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp)),
            ],
          );
        }),
      ),
    );
  }
}