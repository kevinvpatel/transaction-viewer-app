import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import '../controllers/bill_payment_screen_controller.dart';


class BillPaymentScreenView extends GetView<BillPaymentScreenController> {
  const BillPaymentScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BillPaymentScreenController controller = Get.put(BillPaymentScreenController());
    double height = 100.h;
    double width = 100.w;

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: 'Bill Payment', isShareButtonEnable: true),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 18.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bills', style: TextStyle(fontSize: 18.5.sp, fontWeight: FontWeight.w600, color: Colors.white),),
                    SizedBox(height: 18.sp),
                    element(
                      title: 'Cash Money',
                      subTitle: 'Bills & Invoice',
                      imagePath: ConstantsImage.cash_money_icon
                    ),
                    SizedBox(height: 20.sp),
                    element(
                      title: 'Bills & EMIs',
                      subTitle: 'Bills & Invoice',
                      imagePath: ConstantsImage.bills_emis_icon
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }

  Widget element({required String title, required String subTitle, required String imagePath}) {
    double width = 100.w;
    double height = 40.sp;
    double sideSpace = 19.sp;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.sp),
          gradient: ConstantsColor.buttonGradient,
          boxShadow: ConstantsWidgets.boxShadow,
      ),
      padding: EdgeInsets.only(left: sideSpace, right: sideSpace * 0.5),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(128, 34, 208, 1),
                    Color.fromRGBO(200, 32, 203, 0.82),
                    Color.fromRGBO(242, 142, 206, 1),
                    Color.fromRGBO(241, 130, 144, 1),
                  ]
              ),
              borderRadius: BorderRadius.circular(15.5.sp),
            ),
            padding: EdgeInsets.all(3.sp),
            child: Container(
              height: height * 0.55,
              width: height * 0.55,
              decoration: BoxDecoration(
                color: ConstantsColor.backgroundDarkColor,
                borderRadius: BorderRadius.circular(15.5.sp),
              ),
              padding: EdgeInsets.all(15.sp),
              child: Image.asset(imagePath),
            ),
          ),
          SizedBox(width: sideSpace),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18.2.sp),),
              SizedBox(height: 8.sp),
              Text(subTitle, style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w300, fontSize: 15.2.sp),),
            ],
          ),
          Spacer(),
          Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 25.sp)
        ],
      ),
    );
  }

}
