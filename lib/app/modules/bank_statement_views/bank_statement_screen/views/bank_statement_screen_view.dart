import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/views/bank_detail_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/views/loading_screen.dart';
import '../controllers/bank_statement_screen_controller.dart';

class BankStatementScreenView extends GetView<BankStatementScreenController> {
  const BankStatementScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BankStatementScreenController controller = Get.put(BankStatementScreenController());
    double height = 100.h;
    double width = 100.w;

    // controller.saveSms();
    // controller.loadBankCategory();

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: 'Balance Check'),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15.sp),
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Obx(() {
          if(controller.percentage.value.toStringAsFixed(0) != '100') {
            return LoadingScreenView();
          } else {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 20.sp),
              itemCount: controller.bankStatementList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    AdService adService = AdService();
                    adService.checkCounterAd(
                        currentScreen: '/BankStatementScreenView',
                        context: context,
                        pageToNavigate: const BankDetailScreenView(),
                        argument: controller.bankStatementList[index]
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.sp),
                    height: 40.sp,
                    decoration: BoxDecoration(
                        gradient: ConstantsColor.buttonGradient,
                        borderRadius: BorderRadius.circular(12.sp)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15.sp),
                        convertBankAddressToBankIcon(bankName: controller.bankStatementList[index]['bank_name'], bankBundleData: controller.bankBundleData),
                        SizedBox(width: 15.sp),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.bankStatementList[index]['bank_name'], style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                            SizedBox(height: 10.sp),
                            Text.rich(
                                TextSpan(
                                    text: 'Your available balance : ',
                                    style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w300),
                                    children: [
                                      TextSpan(
                                        text: '₹ ${controller.bankStatementList[index]['total_balance']}',
                                        style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w500),
                                      )
                                    ]
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
