import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/views/bank_detail_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/bill_payment_screen/controllers/bill_payment_screen_controller.dart';

class BillsAndEmiScreenView extends GetView<BillPaymentScreenController> {
  const BillsAndEmiScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BillPaymentScreenController controller = Get.put(BillPaymentScreenController());
    double height = 100.h;
    double width = 100.w;

    List<String> listTab = ['Loan EMIs', 'Prepaid Bill', 'Phone Bill', 'Credit Card Bill',
      'Generic Bill', 'Electricity Bill', 'Insurance Bill', 'Gas Bill'];

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Bills & EMIs', isShareButtonEnable: true , onTapBack: () {

          Get.back();
        }),
        body: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              ButtonsTabBar(
                radius: 50.sp,
                onTap: (index) {},
                decoration: const BoxDecoration(
                  gradient: ConstantsColor.pinkGradient
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 4.8.sp),
                height: 29.sp,
                unselectedBackgroundColor: Colors.transparent,
                tabs: List.generate(listTab.length, (index) {
                  return Tab(
                    child: Container(
                      padding: EdgeInsets.only(left: 13.sp, right: 13.sp, top: 13.5.sp, bottom: 13.5.sp),
                      decoration: BoxDecoration(
                        color: ConstantsColor.backgroundDarkColor,
                        borderRadius: BorderRadius.circular(50.sp)
                      ),
                      child: Text(' ${listTab[index]} ',
                          style: TextStyle(fontSize: 16.2.sp, color: Colors.white, fontWeight: FontWeight.w400)),
                    ),
                  );
                })
              ),
              Expanded(
                child: TabBarView(
                    children: List.generate(listTab.length, (index) =>
                        transactionList(title: listTab[index], width: width, controller: controller))
                ),
              )
            ],
          ),
        )
    )
    );
  }

  Widget transactionList({required String title, required double width, required BillPaymentScreenController controller}) {
    List<Map<String, dynamic>> listTransactions = controller.billsEmiList.groupBy('group');
    // controller.getBillsTransactionType().then((listPattern) {
    //   controller.getData(listPattern: listPattern, percentage: controller.billsEmiPercentage, listData: controller.billsEmiList);
    // });

    return listTransactions.length > 0 ? SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
        child: Column(
          children: List.generate(listTransactions.length, (index) {
            return Column(
              children: [
                Container(
                  height: 34.sp,
                  width: width,
                  padding: EdgeInsets.only(left: 12.5.sp),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      boxShadow: ConstantsWidgets.boxShadow,
                      gradient: ConstantsColor.buttonGradient,
                      borderRadius: BorderRadius.circular(18.sp)
                  ),
                  child: Text(listTransactions[index].keys.first.toString().toUpperCase(),
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: listTransactions[index].values.first.length,
                  itemBuilder: (context, groupedIndex) {
                    List listGroupedMessages = listTransactions[index].values.first.toList();
                    return Container(
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
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(color: Colors.white, height: 0, thickness: 0.2),
                )
              ],
            );
          }),
        ),
      ),
    ) : Center(child: Text('$title list is empty',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.sp),)
    );
  }

}