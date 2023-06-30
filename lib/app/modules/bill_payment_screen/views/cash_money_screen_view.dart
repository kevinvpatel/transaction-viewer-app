import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/views/bank_detail_screen_view.dart';
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
        appBar: ConstantsWidgets.appBar(title: 'ATM Withdrawal', isShareButtonEnable: true , onTapBack: () {
          Get.back();
        }),
        body: Container(
          height: height,
          width: width,
          child: atmTransaction(),
        )
    );
  }

  Widget atmTransaction() {
    List<Map<dynamic, dynamic>> temp = controller.cashMoneyList.groupBy('category');
    double width = 100.w;
    temp.removeWhere((element) => element.keys.first != 'ATM Withdrawal');

    List<Map<dynamic, dynamic>> templistMessages = List<Map<dynamic, dynamic>>.from(temp.first.values.first);
    List<Map<dynamic, dynamic>> listMessages = templistMessages.groupBy('group');
    print('listMsg -> ${listMessages}');

    AdService adService = AdService();

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: List.generate(listMessages.length, (index) {
          Map<dynamic, dynamic> sms = listMessages[index];

          return Column(
            children: [
              Material(
                elevation: 2,
                shadowColor: Colors.white54,
                borderRadius: BorderRadius.circular(18.sp),
                child: Container(
                  height: 34.sp,
                  width: width,
                  margin: EdgeInsets.only(right: 1.5.sp),
                  decoration: BoxDecoration(
                      gradient: ConstantsColor.buttonGradient,
                      borderRadius: BorderRadius.circular(18.sp)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 18.sp),
                      Text(sms.keys.first,
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                    ],
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: sms.values.first.length,
                itemBuilder: (context, groupedIndex) {
                  List listGroupedMessages = sms.values.first.toList();
                  print('sms -> ${listGroupedMessages[groupedIndex]}');
                  print(' ');
                  return InkWell(
                    onTap: () {
                      adService.checkCounterAd(currentScreen: '/BillPaymentScreenView', context: context);
                      detailDialoge(message: listGroupedMessages[groupedIndex]);
                    },
                    child: Container(
                      height: 33.sp,
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      child: Row(
                        children: [
                          Text(DateFormat('dd MMM').format(listGroupedMessages[groupedIndex]['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                          SizedBox(width: 15.sp),
                          SizedBox(
                              width: width * 0.5,
                              child: Text(listGroupedMessages[groupedIndex]['transaction_account'] ?? 'UNKNOWN',
                                  style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(color: Colors.white, height: 0, thickness: 0.2),
              )
            ],
          );
        }),
      ),
    );
  }


  detailDialoge({required Map<dynamic, dynamic> message}) {
    // adService.checkCounterAd(currentScreen: '/BankDetailScreenView');
    Get.dialog(
        AlertDialog(
          backgroundColor: Colors.transparent,
          actions: [
            Container(
              width: 95.w,
              decoration: BoxDecoration(
                  gradient: ConstantsColor.buttonGradient,
                  borderRadius: BorderRadius.circular(18.sp),
                  border: Border.all(color: Colors.white)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            // adService.checkBackCounterAd(currentScreen: '/BankDetailScreenView');
                            Get.back();
                          },
                          icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
                      )
                    ],
                  ),
                  Text('Transaction Details', style: TextStyle(fontSize: 18.5.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                  SizedBox(height: 20.sp),
                  Text('Account no - XXXXX${message['account_number']}', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                  SizedBox(height: 15.sp),
                  Padding(
                    padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
                    child: Text(message['body'],
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }


}