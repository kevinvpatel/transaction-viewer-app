
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
          child: allTransaction(),
        )
    );
  }

  Widget allTransaction() {
    List<Map<String, dynamic>> listMessages = controller.cashMoneyList.groupBy('group');
    double width = 100.w;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {
          print('listMessages.length -> ${listMessages}');

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 18.sp),
                      Text(listMessages[index].keys.first.toString().toUpperCase(),
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                    ],
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: listMessages[index].values.first.length,
                itemBuilder: (context, groupedIndex) {
                  List listGroupedMessages = listMessages[index].values.first.toList();
                  return InkWell(
                    onTap: () {
                      // detailDialoge(message: listGroupedMessages[groupedIndex]);
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

}