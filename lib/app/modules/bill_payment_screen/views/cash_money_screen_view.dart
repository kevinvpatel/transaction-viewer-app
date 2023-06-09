
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bill_payment_screen/controllers/bill_payment_screen_controller.dart';

class CashMoneyScreenView extends GetView<BillPaymentScreenController> {
  const CashMoneyScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BillPaymentScreenController controller = Get.put(BillPaymentScreenController());
    double height = 100.h;
    double width = 100.w;

    return Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'ATM Withdrawal', isShareButtonEnable: true),
        body: Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.sp),
              Container(
                height: height * 0.18,
                width: width,
                color: Colors.white,
              ),
            ],
          ),
        )
    );
  }


}