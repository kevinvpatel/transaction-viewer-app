import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bill_payment_screen/views/bills_and_emi_screen.dart';
import 'package:transaction_viewer_app/app/modules/bill_payment_screen/views/cash_money_screen_view.dart';
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
                        imagePath: ConstantsImage.cash_money_icon,
                        percentage: controller.cashMoneyPercentage,
                        onTap: () {
                          Get.to(CashMoneyScreenView());
                        }
                    ),
                    // Obx(() {
                    //   if(controller.cashMoneyPercentage.value.toStringAsFixed(0) != '100') {
                    //     return Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Container(
                    //           height: 8.sp,
                    //           width: width * 0.6,
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(12.sp),
                    //             child: LinearProgressIndicator(
                    //               minHeight: 6.sp,
                    //               value: controller.cashMoneyPercentage.value / 100,
                    //               color: ConstantsColor.purpleColor,
                    //               backgroundColor: Colors.white38,
                    //             ),
                    //           ),
                    //         ),
                    //
                    //         SizedBox(width: 20.sp),
                    //         Container(
                    //           width: width * 0.17,
                    //           child: Text('${controller.cashMoneyPercentage.value.toStringAsFixed(2)} %',
                    //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15.5.sp)),
                    //         ),
                    //       ],
                    //     );
                    //   } else {
                    //     return element(
                    //         title: 'Cash Money',
                    //         subTitle: 'Bills & Invoice',
                    //         imagePath: ConstantsImage.cash_money_icon,
                    //         percentage: controller.cashMoneyPercentage,
                    //         onTap: () {
                    //           Get.to(CashMoneyScreenView());
                    //         }
                    //     );
                    //   }
                    // }),
                    SizedBox(height: 20.sp),
                    element(
                        title: 'Bills & EMIs',
                        subTitle: 'Bills & Invoice',
                        imagePath: ConstantsImage.bills_emis_icon,
                        percentage: controller.billsEmiPercentage,
                        onTap: () {
                          Get.to(BillsAndEmiScreenView());
                        }
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

  Widget element({
    required String title,
    required String subTitle,
    required String imagePath,
    required RxDouble percentage,
    required Function() onTap
  }) {
    double width = 100.w;
    double height = 40.sp;
    double sideSpace = 19.sp;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.sp),
            gradient: ConstantsColor.buttonGradient,
            boxShadow: ConstantsWidgets.boxShadow,
        ),
        padding: EdgeInsets.only(left: sideSpace, right: sideSpace * 0.5),
        child: Obx(() => Row(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: ConstantsColor.pinkGradient,
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
                if(percentage.value.toStringAsFixed(0) != '100')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 8.sp,
                        width: width * 0.46,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.sp),
                          child: LinearProgressIndicator(
                            minHeight: 6.sp,
                            value: percentage.value / 100,
                            color: ConstantsColor.purpleColor,
                            backgroundColor: Colors.white38,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.sp),
                      Container(
                        width: width * 0.17,
                        child: Text('${percentage.value.toStringAsFixed(2)} %',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15.sp)),
                      ),
                    ],
                  )
                else
                  Text(subTitle, style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w300, fontSize: 15.2.sp),),
              ],
            ),
            Spacer(),
            if(percentage.value.toStringAsFixed(0) != '100') SizedBox.shrink() else Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 25.sp)
          ],
        )),
      ),
    );
  }

}
