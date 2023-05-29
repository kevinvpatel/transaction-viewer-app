import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import '../controllers/bank_detail_screen_controller.dart';

extension UtilListExtension on List{
  groupBy(String key) {
    try {
      List<Map<String, dynamic>> result = [];
      List<String> keys = [];

      this.forEach((f) => keys.add(f[key]));

      [...keys.toSet()].forEach((k) {
        List data = [...this.where((e) => e[key] == k)];
        result.add({k: data});
      });

      return result;
    } catch (e, s) {
      // printCatchNReport(e, s);
      return this ;
    }
  }
}


class BankDetailScreenView extends GetView<BankDetailScreenController> {
  const BankDetailScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BankDetailScreenController controller = Get.put(BankDetailScreenController());
    double height = 100.h;
    double width = 100.w;
    controller.loadRegExJson(transactionType: 'ALL');

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: Get.arguments['bank_address'], onTapBack: () {}),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Column(
          children: [
            Material(
              borderRadius: BorderRadius.circular(15.sp),
              elevation: 1,
              shadowColor: Colors.white70,
              child: Container(
                height: 48.sp,
                width: width,
                decoration: BoxDecoration(
                  gradient: ConstantsColor.buttonGradient,
                  borderRadius: BorderRadius.circular(15.sp)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('A/c No : XXXXXX${Get.arguments['account_number']}', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w400),),
                    Text('Total Balance', style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),),
                    Text(Get.arguments['total_balance'], style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideSwitcher(
                  slidersHeight: 27.sp,
                  slidersWidth: width * 0.27,
                  sliderContainer: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 28.sp,
                    width: width * 0.27,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.sp),
                      gradient: ConstantsColor.pinkGradient
                    ),
                    padding: EdgeInsets.all(5.sp),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.sp),
                        color: ConstantsColor.backgroundDarkColor,
                      ),
                    ),
                  ),
                  initialIndex: 0,
                  containerHeight: 27.sp,
                  containerWight: width * 0.815,
                  containerGradient: ConstantsColor.buttonGradient,
                  onSelect: (int index) {
                    controller.scrollController.animateTo(
                        controller.scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut
                    );
                    controller.loadRegExJson(transactionType: index != 0 ? index == 1 ? 'CREDITED' : 'DEBITED' : 'ALL');
                    controller.tabIndex.value = index;
                  },
                  children: [
                    Text('ALL', style: TextStyle(fontSize: 15.2.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                    Text('CREDITED', style: TextStyle(fontSize: 15.2.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                    Text('DEBITED', style: TextStyle(fontSize: 15.2.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                  // s
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    filterDialoge();
                  },
                  child: Image.asset(ConstantsImage.select_month_icon, height: 23.sp, width: 23.sp)
                )
              ],
            ),
            SizedBox(height: 15.sp),
            Expanded(
              child: GetBuilder(
                init: BankDetailScreenController(),
                builder: (controller) {
                  return controller.tabIndex.value == 0 ? allTransaction()
                          : controller.tabIndex.value == 1 ? creditTransaction()
                          : debitTransaction();

                  return GroupedListView(
                    elements: controller.allMessageDetails,
                    groupBy: (message) => message['group'],
                    floatingHeader: false,
                    physics: BouncingScrollPhysics(),
                    groupSeparatorBuilder: (group) {
                      return Material(
                        elevation: 2,
                        shadowColor: Colors.white54,
                        borderRadius: BorderRadius.circular(18.sp),
                        child: Container(
                          height: 34.sp,
                          width: width,
                          decoration: BoxDecoration(
                            gradient: ConstantsColor.buttonGradient,
                            borderRadius: BorderRadius.circular(18.sp)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 18.sp),
                              Text(group.toString().toUpperCase(), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                              Spacer(),
                              Text(group, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                              SizedBox(width: 18.sp),
                            ],
                          ),
                        ),
                      );
                    },
                    separator: const Divider(color: Colors.white, height: 0, thickness: 0.2),
                    itemBuilder: (context, message) {
                      return InkWell(
                        onTap: () {
                          detailDialoge(message: message);
                        },
                        child: Container(
                          height: 33.sp,
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Row(
                            children: [
                              Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                              SizedBox(width: 15.sp),
                              SizedBox(
                                  width: width * 0.5,
                                  child: Text(message['transaction_account'] ?? 'UNKNOWN',
                                      style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                              ),
                              const Spacer(),
                              Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                            ],
                          ),
                        ),
                      );
                    },
                    itemComparator: (item1, item2) => item1['date'].compareTo(item2['date']),
                    // elementIdentifier: (element) => element.name,
                    order: GroupedListOrder.DESC,
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget allTransaction() {
    List<Map<String, dynamic>> listMessages = controller.allMessageDetails.groupBy('group');
    List<Map<String, dynamic>> listCredits = controller.creditMessageDetails.groupBy('group');
    List<Map<String, dynamic>> listDebits = controller.debitMessageDetails.groupBy('group');
    double width = 100.w;
    RxList<double> lstCreditSum = <double>[].obs;
    RxList<double> sumList = <double>[].obs;
    RxList<double> lstDebitSubtraction = <double>[].obs;
    RxList<double> subtractionList = <double>[].obs;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {

          List.generate(listCredits.length, (index) {
            sumList.add(0);
          });
          List.generate(listDebits.length, (index) {
            subtractionList.add(0);
          });

          print('listMessages.length -> ${listMessages}');
          print('listCredits.length -> ${listCredits}');

          if(listCredits.isNotEmpty) {
            listMessages[index].values.first.forEach((valCredit) {
              if(valCredit['transaction_type'] == 'credit' && valCredit['transaction_amount'] != null) {
                print('valCredit[transaction_amount] -> ${valCredit['transaction_amount']}');
                lstCreditSum.add(double.parse(valCredit['transaction_amount'].replaceAll(',','')));
              }
              listCredits.forEach((credit) {
                if(lstCreditSum.length == credit.values.first.length) {
                  sumList.value[index] = 0;
                  sumList.value[index] = lstCreditSum.reduce((value, element) => value + element);
                  lstCreditSum.clear();
                }
              });
            });
          }


          if(listDebits != []) {
            listMessages[index].values.first.forEach((valDebit) {
              if(valDebit['transaction_type'] == 'debit' && valDebit['transaction_amount'] != null) {
                lstDebitSubtraction.add(double.parse(valDebit['transaction_amount'].replaceAll(',','')));
              }
              listDebits.forEach((debit) {
                if(lstDebitSubtraction.length == debit.values.first.length) {
                  subtractionList.value[index] = lstDebitSubtraction.reduce((value, element) => value + element);
                  lstDebitSubtraction.clear();
                }
              });
            });
          }


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
                      Spacer(),
                      GetBuilder(
                          init: BankDetailScreenController(),
                          builder: (controller) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('+ ₹ ${sumList.value[index]}',
                                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.green)),
                                Text('- ₹ ${subtractionList.value[index]}',
                                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.red)),
                              ],
                            );
                          }
                      ),
                      SizedBox(width: 18.sp),
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
                          const Spacer(),
                          Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${listGroupedMessages[groupedIndex]['transaction_amount']}',
                              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(color: Colors.white, height: 0, thickness: 0.2),
              )
              // Column(
              //   children: List.generate(listMessages[index].values.first.length, (groupedIndex) {
              //     List listGroupedMessages = listMessages[index].values.first.toList();
              //     return InkWell(
              //       onTap: () {
              //         detailDialoge(message: listGroupedMessages[groupedIndex]['body']);
              //       },
              //       child: Container(
              //         height: 33.sp,
              //         padding: EdgeInsets.symmetric(horizontal: 15.sp),
              //         child: Row(
              //           children: [
              //             Text(DateFormat('dd MMM').format(listGroupedMessages[groupedIndex]['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
              //             SizedBox(width: 15.sp),
              //             SizedBox(
              //                 width: width * 0.5,
              //                 child: Text(listGroupedMessages[groupedIndex]['transaction_account'] ?? 'UNKNOWN',
              //                     style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
              //             ),
              //             const Spacer(),
              //             Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${listGroupedMessages[groupedIndex]['transaction_amount']}',
              //                 style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
              //           ],
              //         ),
              //       ),
              //     );
              //   }),
              // )
            ],
          );
        }),
      ),
    );
  }

  Widget creditTransaction() {
    List<Map<String, dynamic>> listMessages = controller.creditMessageDetails.groupBy('group');
    double width = 100.w;
    RxList<double> lstCreditSum = <double>[].obs;
    RxList<double> sumList = <double>[].obs;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {
          List.generate(listMessages.length, (index) => sumList.add(0));
          listMessages[index].values.first.forEach((val) {
            lstCreditSum.add(double.parse(val['transaction_amount']));
            if(lstCreditSum.length == listMessages[index].values.first.length) {
              sumList.value[index] = lstCreditSum.reduce((value, element) => value + element);
              lstCreditSum.clear();
            }
          });
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
                      Spacer(),
                      GetBuilder(
                          init: BankDetailScreenController(),
                          builder: (controller) {
                            return Text('+ ₹ ${sumList.value[index]}',
                                style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.green));
                          }
                      ),
                      SizedBox(width: 18.sp),
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
                  lstCreditSum.add(double.parse(listGroupedMessages[groupedIndex]['transaction_amount']));
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
                          const Spacer(),
                          Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${listGroupedMessages[groupedIndex]['transaction_amount']}',
                              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
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

  Widget debitTransaction() {
    List<Map<String, dynamic>> listMessages = controller.debitMessageDetails.groupBy('group');
    double width = 100.w;
    RxList<double> lstDebitSubtraction = <double>[].obs;
    RxList<double> subtractionList = <double>[].obs;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {
          List.generate(listMessages.length, (index) => subtractionList.add(0));
          listMessages[index].values.first.forEach((val) {
            lstDebitSubtraction.add(double.parse(val['transaction_amount']));
            if(lstDebitSubtraction.length == listMessages[index].values.first.length) {
              subtractionList.value[index] = lstDebitSubtraction.reduce((value, element) => value + element);
              lstDebitSubtraction.clear();
            }
          });
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
                      Spacer(),

                      GetBuilder(
                          init: BankDetailScreenController(),
                          builder: (controller) {
                            return Text('- ₹ ${subtractionList.value[index]}',
                                style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.red));
                          }
                      ),
                      SizedBox(width: 18.sp),
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
                          const Spacer(),
                          Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${listGroupedMessages[groupedIndex]['transaction_amount']}',
                              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
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



  detailDialoge({required Map<String, dynamic> message}) {
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
                      onPressed: () => Get.back(),
                      icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
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

  filterDialoge() {
    List<String> listFilter = ['Last Month', 'Last 2 Months', 'Last 3 Months', 'Last 6 Months'];
    DateTime currentDate = DateTime.now();
    Get.dialog(
        AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 00.sp),
          content: Container(
            height: 34.h,
            width: 100.w,
            decoration: BoxDecoration(
                gradient: ConstantsColor.buttonGradient,
                borderRadius: BorderRadius.circular(18.sp),
                border: Border.all(color: Colors.white)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Save your transaction as PDF', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),),
                SizedBox(height: 10.sp),
                Text('For which period do you need a statement?', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w300),),
                SizedBox(height: 20.sp),
                Wrap(
                  spacing: 22.sp,
                  children: List.generate(listFilter.length, (index) {
                    return GetBuilder(
                        init: BankDetailScreenController(),
                        builder: (controller) {
                          return InkWell(
                            onTap: () {
                              controller.onClickRadio(listFilter[index]);
                            },
                            child: SizedBox(
                              width: 39.w,
                              child: Row(
                                children: [
                                  Theme(
                                    data: ThemeData(unselectedWidgetColor: Colors.white),
                                    child: Radio<String>(
                                      activeColor: ConstantsColor.purpleColor,
                                      value: listFilter[index],
                                      groupValue: controller.selectedFilter.value,
                                      onChanged: (String? value) {
                                        controller.onClickRadio(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 5.sp),
                                  Text(listFilter[index], style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }),
                ),
                SizedBox(height: 20.sp),
                InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  onTap: () {
                    DateTime filtered = DateTime(
                        currentDate.year,
                        controller.selectedFilter.value == 'Last Month' ? currentDate.month - 1
                            : controller.selectedFilter.value == 'Last 2 Months' ? currentDate.month - 2
                            : controller.selectedFilter.value == 'Last 3 Months' ? currentDate.month - 3
                            : currentDate.month - 6,
                        currentDate.day
                    );
                    // print('currentDate.month -> ${currentDate}');
                    // print('filtered.month -> ${filtered}');

                    List<Map<String, dynamic>> listMessages = controller.allMessageDetails.groupBy('group');
                    List<DateTime> days = [];
                    for (int i = 0; i <= currentDate.month - filtered.month; i++) {
                      days.add(DateTime(filtered.year, filtered.month + i));
                    }


                    days.forEach((date) {
                      listMessages.forEach((msg) {
                        String dateResult = DateFormat('MMM yyyy').format(date);
                        print('dateResult@@ -> ${dateResult}');
                        print('msg@@ -> ${msg[dateResult]}');
                      });
                    });

                    // Get.back();
                  },
                  child: Container(
                    height: 29.sp,
                    width: 35.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.sp),
                        gradient: ConstantsColor.pinkGradient
                    ),
                    padding: EdgeInsets.all(5.sp),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.sp),
                          gradient: ConstantsColor.buttonGradient
                      ),
                      alignment: Alignment.center,
                      child: Text('Proceed', style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

}
