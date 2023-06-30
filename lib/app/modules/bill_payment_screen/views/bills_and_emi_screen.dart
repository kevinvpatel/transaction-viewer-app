import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
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

    AdService adService = AdService();

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
                onTap: (index) {
                  adService.checkCounterAd(currentScreen: '/BillsAndEmiScreenView', context: context);
                },
                decoration: const BoxDecoration(
                  gradient: ConstantsColor.pinkGradient
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 4.8.sp),
                height: 29.sp,
                unselectedBackgroundColor: Colors.transparent,
                tabs: List.generate(listTab.length, (index) {
                  return Tab(
                    child: Container(
                      padding: EdgeInsets.only(left: 13.sp, right: 13.sp, top: 13.sp, bottom: 13.sp),
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
                        transactionList(title: listTab, width: width, controller: controller, tabIndex: index))
                ),
              )
            ],
          ),
        )
    )
    );
  }

  Widget transactionList({required List<String> title, required double width, required BillPaymentScreenController controller, required int tabIndex}) {

    List<Map<String, dynamic>> temp = controller.cashMoneyList.groupBy('category');
    print('temp -> ${temp}');
    temp.removeWhere((element) => element.keys.first == 'ATM Withdrawal');
    List<Map<dynamic, dynamic>> templistMessages = List<Map<dynamic, dynamic>>.from(temp.first.values.first);
    List<Map<dynamic, dynamic>> listTransactions = templistMessages.groupBy('group');
    // print('listTransactions ->> ${listTransactions.toSet().toList()}');
    List<int> listCategoriesLength = [];
    listTransactions.forEach((transaction) {
      Map<dynamic, dynamic> map = transaction;
      List<Map<dynamic, dynamic>> listMap = List<Map<dynamic, dynamic>>.from(map.values.first.toSet().toList());
      List<Map<dynamic, dynamic>> listMapCategory = listMap.groupBy('category');
      print('listMapCategory ->> ${listMapCategory.first.keys.first}');
      print('title[tabIndex] ->> ${title[tabIndex]}');
      if(listMapCategory.first.keys.first == title[tabIndex]) {
        listCategoriesLength.add(listTransactions.length);
      } else {
        listCategoriesLength.add(1);
      }
    });

    return Obx(() {
      print('listCategoriesLength ->> ${listCategoriesLength}');

      return controller.isLoading.value == false
          ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: controller.scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(listCategoriesLength[tabIndex], (index) {
                  Map<dynamic, dynamic> map = listTransactions[index];
                  List<Map<dynamic, dynamic>> listMap = List<Map<dynamic, dynamic>>.from(map.values.first.toSet().toList());
                  List<Map<dynamic, dynamic>> listMapCategory = listMap.groupBy('category');

                  print('listMap ->> ${map}');
                  print(' ');
                  if(listMapCategory.first.keys.first == title[tabIndex]) {
                    return Column(
                      children: [
                        Container(
                          height: 34.sp,
                          width: width,
                          padding: EdgeInsets.only(left: 14.5.sp),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              boxShadow: ConstantsWidgets.boxShadow,
                              gradient: ConstantsColor.buttonGradient,
                              borderRadius: BorderRadius.circular(18.sp)
                          ),
                          child: Text(map.keys.first.toString().toUpperCase(),
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: map.values.first.toSet().length,
                          itemBuilder: (context, groupedIndex) {
                            List listGroupedMessages = map.values.first.toSet().toList();
                            // print('listGroupedMessages ->> ${listGroupedMessages[groupedIndex]['category']}');
                            return InkWell(
                              onTap: () {
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
                  } else {
                    return Container(
                      height: 75.h,
                      alignment: Alignment.center,
                      child: Text('${title[tabIndex]} list is empty', style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500),),
                    );
                  }
                }),
              ),
            ),
          )
          : const Center(
            child: CircularProgressIndicator(color: Colors.white),
            // child: Text('${title[tabIndex]} list is empty',
            //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.sp),
            // )
          );
    });
  }


  detailDialoge({required Map<dynamic, dynamic> message}) {
    // AdService adService = AdService();
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