import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/controllers/bank_statement_screen_controller.dart';
import '../controllers/bank_detail_screen_controller.dart';

extension UtilListExtension on List{
  groupBy(String key) {
    try {
      List<Map<String, dynamic>> result = [];
      List<String> keys = [];

      forEach((f) => keys.add(f[key]));

      [...keys.toSet()].forEach((k) {
        List data = [...where((e) => e[key] == k)];
        result.add({k: data});
      });

      return result;
    } catch (e, s) {
      // printCatchNReport(e, s);
      return this ;
    }
  }
}


class BankDetailScreenView extends GetView<BankStatementScreenController> {
  const BankDetailScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BankDetailScreenController bankDetailScreenController = Get.put(BankDetailScreenController());
    BankStatementScreenController controller = Get.put(BankStatementScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    // controller.loadRegExJson();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/BankDetailScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: Get.arguments['bank_address'], onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/BankDetailScreenView', context: context);
          // Get.back();
        }),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: Column(
            children: [
              Container(
                height: 48.sp,
                width: width,
                decoration: BoxDecoration(
                  gradient: ConstantsColor.buttonGradient,
                  borderRadius: BorderRadius.circular(15.sp),
                  boxShadow: ConstantsWidgets.boxShadow
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
                      adService.checkCounterAd(currentScreen: '/BankDetailScreenView', context: context);
                      controller.scrollController.animateTo(
                          controller.scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut
                      );
                      // controller.loadRegExJson();
                      controller.tabIndex.value = index;
                      controller.update();
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
                      adService.checkCounterAd(currentScreen: '/BankDetailScreenView', context: context);
                      filterDialoge(bankDetailScreenController: bankDetailScreenController, context: context);
                    },
                    child: Image.asset(ConstantsImage.select_month_icon, height: 23.sp, width: 23.sp)
                  )
                ],
              ),
              SizedBox(height: 15.sp),
              Expanded(
                child: GetBuilder(
                  init: BankStatementScreenController(),
                  builder: (controller) {
                    return controller.tabIndex.value == 0 ? allTransaction()
                            : controller.tabIndex.value == 1 ? creditTransaction()
                            : debitTransaction();
                  }
                ),
              )
            ],
          ),
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
      physics: const BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {

          List.generate(listCredits.length, (index) {
            sumList.add(0);
          });
          List.generate(listDebits.length, (index) {
            subtractionList.add(0);
          });

          print('listMessages.length -> $listMessages');
          print('listCredits.length -> $listCredits');

          if(listCredits.isNotEmpty) {
            listMessages[index].values.first.forEach((valCredit) {
              if(valCredit['transaction_type'] == 'credit' && valCredit['transaction_amount'] != null) {
                print('valCredit[transaction_amount] -> ${valCredit['transaction_amount']}');
                lstCreditSum.add(double.parse(valCredit['transaction_amount'].replaceAll(',','')));
              }
              listCredits.forEach((credit) {
                if(lstCreditSum.length == credit.values.first.length) {
                  sumList[index] = 0;
                  sumList[index] = lstCreditSum.reduce((value, element) => value + element);
                  lstCreditSum.clear();
                }
              });
            });
          }


          print('listDebits -> $listDebits');
          if(listDebits != []) {
            listMessages[index].values.first.forEach((valDebit) {
              if(valDebit['transaction_type'] == 'debit' && valDebit['transaction_amount'] != null) {
                lstDebitSubtraction.add(double.parse(valDebit['transaction_amount'].replaceAll(',','')));
              }
              listDebits.forEach((debit) {
                print('debit.values.first -> ${debit.values.first.length}');
                if(lstDebitSubtraction.length == debit.values.first.length) {
                  subtractionList[index] = lstDebitSubtraction.reduce((value, element) => value + element);
                  lstDebitSubtraction.clear();
                }
              });
            });
          }

          return Column(
            children: [
              Container(
                height: 34.sp,
                width: width,
                margin: EdgeInsets.only(right: 3.5.sp),
                decoration: BoxDecoration(
                    boxShadow: ConstantsWidgets.boxShadow,
                    gradient: ConstantsColor.buttonGradient,
                    borderRadius: BorderRadius.circular(18.sp)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 18.sp),
                    Text(listMessages[index].keys.first.toString().toUpperCase(),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('+ ₹ ${sumList.isEmpty ? '00' : sumList[index]}',
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.green)),
                        Text('- ₹ ${subtractionList.isEmpty ? '00' : subtractionList[index]}',
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.red)),
                      ],
                    ),
                    SizedBox(width: 18.sp),
                  ],
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
                      AdService adService = AdService();
                      adService.checkCounterAd(currentScreen: '/BankDetailScreenView', context: context);
                      detailDialoge(message: listGroupedMessages[groupedIndex], context: context);
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
    // List<Map<String, dynamic>> listMessages = controller.allMessageDetails.groupBy('group');
    //
    //
    // List<Map<String, dynamic>> listCredits = controller.allMessageDetails.groupBy('transaction_type');
    // print('listCredits -> ${listCredits}');
    // listCredits.removeWhere((element) => element.keys.first != 'credit');
    // print('listCredits22 -> ${listCredits}');
    //
    // listMessages.addAll(listCredits);
    // listMessages = listMessages.toSet().toList();
    // listMessages.forEach((element) {
    //   print('listMessages -> ${element}');
    //
    // });


    double width = 100.w;
    RxList<double> lstCreditSum = <double>[].obs;
    RxList<double> sumList = <double>[].obs;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {
          List.generate(listMessages.length, (index) => sumList.add(0));
          listMessages[index].values.first.forEach((val) {
            String transaction_amt = val['transaction_amount'].toString().replaceAll(',', '');
            lstCreditSum.add(double.parse(transaction_amt));
            if(lstCreditSum.length == listMessages[index].values.first.length) {
              sumList[index] = lstCreditSum.reduce((value, element) => value + element);
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
                      const Spacer(),
                      Text('+ ₹ ${sumList[index]}',
                          style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.green)),
                      // GetBuilder(
                      //     init: BankDetailScreenController(),
                      //     builder: (controller) {
                      //       return Text('+ ₹ ${sumList[index]}',
                      //           style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.green));
                      //     }
                      // ),
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
                  String transaction_amt = listGroupedMessages[groupedIndex]['transaction_amount'].toString().replaceAll(',', '');
                  print('transaction_amt -> ${transaction_amt}');
                  lstCreditSum.add(double.parse(transaction_amt));
                  return InkWell(
                    onTap: () {
                      detailDialoge(message: listGroupedMessages[groupedIndex], context: context);
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
      physics: const BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {
          List.generate(listMessages.length, (index) => subtractionList.add(0));
          listMessages[index].values.first.forEach((val) {
            String transaction_amt = val['transaction_amount'].toString().replaceAll(',', '');
            print('transaction_amt@# -> ${transaction_amt}');
            lstDebitSubtraction.add(double.tryParse(transaction_amt) == null ? 0.0 : double.parse(transaction_amt));
            if(lstDebitSubtraction.length == listMessages[index].values.first.length) {
              subtractionList[index] = lstDebitSubtraction.reduce((value, element) => value + element);
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
                      const Spacer(),
                      Text('- ₹ ${subtractionList[index]}',
                          style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.red)),
                      // GetBuilder(
                      //     init: BankDetailScreenController(),
                      //     builder: (controller) {
                      //       return Text('- ₹ ${subtractionList[index]}',
                      //           style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.red));
                      //     }
                      // ),
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
                      detailDialoge(message: listGroupedMessages[groupedIndex], context: context);
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


  detailDialoge({required Map<dynamic, dynamic> message, required BuildContext context}) {
    AdService adService = AdService();
    adService.checkCounterAd(currentScreen: '/BankDetailScreenView', context: context);
    Get.dialog(
      barrierDismissible: false,
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
                        adService.checkBackCounterAd(currentScreen: '/BankDetailScreenView', context: context);
                        // Get.back();
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

  filterDialoge({required BankDetailScreenController bankDetailScreenController, required BuildContext context}) {
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
                    AdService adService = AdService();
                    adService.checkBackCounterAd(currentScreen: '/BankDetailScreenView', context: context);
                    DateTime filtered = DateTime(
                        currentDate.year,
                        bankDetailScreenController.selectedFilter.value == 'Last Month' ? currentDate.month - 1
                            : bankDetailScreenController.selectedFilter.value == 'Last 2 Months' ? currentDate.month - 2
                            : bankDetailScreenController.selectedFilter.value == 'Last 3 Months' ? currentDate.month - 3
                            : currentDate.month - 6,
                        currentDate.day
                    );

                    List<Map<String, dynamic>> listMessages = controller.allMessageDetails.groupBy('group');
                    List<DateTime> days = [];
                    for (int i = 0; i <= currentDate.month - filtered.month; i++) {
                      days.add(DateTime(filtered.year, filtered.month + i));
                    }


                    days.forEach((date) {
                      listMessages.forEach((msg) {
                        String dateResult = DateFormat('MMM yyyy').format(date);
                        print('dateResult@@ -> $dateResult');
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
