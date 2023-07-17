import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/controllers/bank_statement_screen_controller.dart';
import 'package:transaction_viewer_app/app/modules/bottom_navigation_screen/controllers/bottom_navigation_screen_controller.dart';
import '../controllers/bank_detail_screen_controller.dart';
import 'package:pdf/widgets.dart' as pw;

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
    BottomNavigationScreenController bottomNavigationScreenController = Get.put(BottomNavigationScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/BankDetailScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: Get.arguments['bank_name'], onTapBack: () {
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
                    Text('A/c No : ${Get.arguments['bank_account_number'] == 'N/A' ? '  N/A' : 'XXXXXX${Get.arguments['bank_account_number']}'}', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w400),),
                    Text('Total Balance', style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),),
                    Text(Get.arguments['bank_amount'], style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),),
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
                    initialIndex: controller.tabIndex.value,
                    containerHeight: 27.sp,
                    containerWight: width * 0.815,
                    containerGradient: ConstantsColor.buttonGradient,
                    onSelect: (int index) {
                      adService.checkCounterAd(currentScreen: '/BankDetailScreenView', context: context);
                      if(controller.scrollController.hasClients) {
                        controller.scrollController.animateTo(
                            controller.scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut
                        );
                      }
                      // controller.loadRegExJson();
                      controller.tabIndex.value = index;
                      // controller.update();
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
                      filterDialoge(bankDetailScreenController: bankDetailScreenController, bottomNavigationScreenController: bottomNavigationScreenController);
                    },
                    child: Image.asset(ConstantsImage.select_month_icon, height: 23.sp, width: 23.sp)
                  )
                ],
              ),
              SizedBox(height: 15.sp),
              Expanded(
                child: Obx(() => controller.tabIndex.value == 0 ? allTransaction(
                    allTransactions: bankDetailScreenController.listAllTransactions,
                    creditTransactions: bankDetailScreenController.listCreditTransactions,
                    debitTransactions: bankDetailScreenController.listDebitTransactions
                ) : controller.tabIndex.value == 1 ? creditTransaction(
                    creditTransactions:bankDetailScreenController.listCreditTransactions
                ) : debitTransaction(
                    debitTransactions: bankDetailScreenController.listDebitTransactions
                )),
                // child: GetBuilder(
                //   init: BankStatementScreenController(),
                //   builder: (controller) {
                //     return controller.tabIndex.value == 0 ? allTransaction(
                //       allTransactions: bankDetailScreenController.listAllTransactions,
                //       creditTransactions: bankDetailScreenController.listCreditTransactions,
                //       debitTransactions: bankDetailScreenController.listDebitTransactions
                //     ) : controller.tabIndex.value == 1 ? creditTransaction(
                //         creditTransactions:bankDetailScreenController.listCreditTransactions
                //     ) : debitTransaction(
                //         debitTransactions: bankDetailScreenController.listDebitTransactions
                //     );
                //   },
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget allTransaction({
    required List<Map<dynamic, dynamic>> allTransactions,
    required List<Map<dynamic, dynamic>> creditTransactions,
    required List<Map<dynamic, dynamic>> debitTransactions
  }) {
    List<Map<dynamic, dynamic>> listMessages = allTransactions.groupBy('group');
    List<Map<dynamic, dynamic>> listCredits = creditTransactions.groupBy('group');
    List<Map<dynamic, dynamic>> listDebits = debitTransactions.groupBy('group');

    double width = 100.w;
    RxList<double> lstCreditSum = <double>[].obs;
    RxList<double> sumList = <double>[].obs;
    RxList<double> lstDebitSubtraction = <double>[].obs;
    RxList<double> subtractionList = <double>[].obs;

    List.generate(listMessages.length, (index) {
      sumList.add(0.0);
    });
    List.generate(listMessages.length, (index) {
      subtractionList.add(0.0);
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: controller.scrollController,
      child: Column(
        children: List.generate(listMessages.length, (index) {

          List<Map<dynamic, dynamic>> listGroupedMessages = List<Map<dynamic, dynamic>>.from(listMessages[index].values.first.toList());

          RxList debitList = listGroupedMessages.where((element) => element['transaction_type'] == 'debit' && element['transaction_amount'] != null).toList().obs;
          RxList creditList = listGroupedMessages.where((element) => element['transaction_type'] == 'credit' && element['transaction_amount'] != null).toList().obs;

          for(int idx = 0; idx < listGroupedMessages.length; idx++) {
            ///Credit Total
            if(listGroupedMessages[idx]['transaction_type'] == 'credit' && listGroupedMessages[idx]['transaction_amount'] != null) {
              lstCreditSum.add(double.parse(listGroupedMessages[idx]['transaction_amount'].replaceAll(',','')));
            }

            if(lstCreditSum.isNotEmpty) {
              if(creditList.length == lstCreditSum.length) {
                sumList[index] = lstCreditSum.reduce((value, element) => value + element);
                lstCreditSum.clear();
              }
            }


            ///Debit Total
            if(listGroupedMessages[idx]['transaction_type'] == 'debit' && listGroupedMessages[idx]['transaction_amount'] != null) {
              lstDebitSubtraction.add(double.parse(listGroupedMessages[idx]['transaction_amount'].replaceAll(',','')));
            }
            if(lstDebitSubtraction.isNotEmpty) {
              if(debitList.length == lstDebitSubtraction.length) {
                subtractionList[index] = lstDebitSubtraction.reduce((value, element) => value + element);
                lstDebitSubtraction.clear();
              }
            }
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
                        Text('+ ₹ ${sumList.isEmpty ? '00' : sumList[index].toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.green)),
                        Text('- ₹ ${subtractionList.isEmpty ? '00' : subtractionList[index].toStringAsFixed(2)}',
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
                itemCount: listGroupedMessages.length,
                itemBuilder: (context, groupedIndex) {

                  double amount = listGroupedMessages[groupedIndex]['transaction_amount'] != null
                      ? double.parse(listGroupedMessages[groupedIndex]['transaction_amount'].toString().replaceAll(',', ''))
                      : 0.0;

                  return InkWell(
                    onTap: () {
                      detailDialoge(message: listGroupedMessages[groupedIndex], context: context);
                    },
                    child: amount == 0.0 ? SizedBox.shrink() : Container(
                      height: 33.sp,
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      child: Row(
                        children: [
                          Text(DateFormat('dd MMM').format(listGroupedMessages[groupedIndex]['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                          SizedBox(width: 15.sp),
                          SizedBox(
                              width: width * 0.45,
                              child: Text(listGroupedMessages[groupedIndex]['transaction_account'] ?? 'UNKNOWN',
                                  style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                          ),
                          const Spacer(),
                          Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'} '
                              ' ₹ ${amount.toStringAsFixed(2)}',
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

  Widget creditTransaction({required List<Map<dynamic, dynamic>> creditTransactions}) {
    List<Map<dynamic, dynamic>> tempMessages = creditTransactions.groupBy('group');
    List<Map<dynamic, dynamic>> listMessages = tempMessages.groupBy('group');


    double width = 100.w;
    RxList<double> lstCreditSum = <double>[].obs;
    RxList<double> sumList = <double>[].obs;
    return listMessages.length <= 0
        ? Center(
          child: Text('Transactions Not Available', style: TextStyle(color: Colors.white, fontSize: 16.5.sp),)
        )
        : SingleChildScrollView(
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
                          Text('+ ₹ ${sumList[index].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.green)),
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

                      double amount = listGroupedMessages[groupedIndex]['transaction_amount'] != null
                          ? double.parse(listGroupedMessages[groupedIndex]['transaction_amount'].toString().replaceAll(',', ''))
                          : 0.0;

                      return InkWell(
                        onTap: () {
                          detailDialoge(message: listGroupedMessages[groupedIndex], context: context);
                        },
                        child: amount == 0.0 ? SizedBox.shrink() : Container(
                          height: 33.sp,
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Row(
                            children: [
                              Text(DateFormat('dd MMM').format(listGroupedMessages[groupedIndex]['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                              SizedBox(width: 15.sp),
                              SizedBox(
                                  width: width * 0.45,
                                  child: Text(listGroupedMessages[groupedIndex]['transaction_account'] ?? 'UNKNOWN',
                                      style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                              ),
                              const Spacer(),
                              Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${amount.toStringAsFixed(2)}',
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

  Widget debitTransaction({required List<Map<dynamic, dynamic>> debitTransactions}) {
    List<Map<dynamic, dynamic>> listMessages = debitTransactions.groupBy('group');
    double width = 100.w;
    RxList<double> lstDebitSubtraction = <double>[].obs;
    RxList<double> subtractionList = <double>[].obs;
    print(' ');
    print('debitTransactions -> ${debitTransactions}');
    print('listMessages1212 -> ${listMessages}');
    return listMessages.length <= 0
        ? Center(
          child: Text('Transactions Not Available', style: TextStyle(color: Colors.white, fontSize: 16.5.sp),)
        )
        : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: controller.scrollController,
          child: Column(
            children: List.generate(listMessages.length, (index) {

              print('listMessages[index] -> ${listMessages[index]}');

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
                          Text('- ₹ ${subtractionList[index].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.red)),
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

                      double amount = listGroupedMessages[groupedIndex]['transaction_amount'] != null
                          ? double.parse(listGroupedMessages[groupedIndex]['transaction_amount'].toString().replaceAll(',', ''))
                          : 0.0;

                      return InkWell(
                        onTap: () {
                          detailDialoge(message: listGroupedMessages[groupedIndex], context: context);
                        },
                        child: amount == 0.0 ? SizedBox.shrink() : Container(
                          height: 33.sp,
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Row(
                            children: [
                              Text(DateFormat('dd MMM').format(listGroupedMessages[groupedIndex]['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                              SizedBox(width: 15.sp),
                              SizedBox(
                                  width: width * 0.45,
                                  child: Text(listGroupedMessages[groupedIndex]['transaction_account'] ?? 'UNKNOWN',
                                      style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                              ),
                              const Spacer(),
                              Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${amount.toStringAsFixed(2)}',
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

  filterDialoge({required BankDetailScreenController bankDetailScreenController, required BottomNavigationScreenController bottomNavigationScreenController}) {
    List<String> listFilter = ['Last Month', 'Last 2 Months', 'Last 3 Months', 'Last 6 Months'];
    DateTime currentDate = DateTime.now();
    Get.dialog(
        AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 00.sp),
          content: Container(
            width: 100.w,
            decoration: BoxDecoration(
                gradient: ConstantsColor.buttonGradient,
                borderRadius: BorderRadius.circular(18.sp),
                border: Border.all(color: Colors.white)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 17.sp),
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
                  onTap: () async {
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      await Permission.storage.request();
                    }
                    print('status -> $status');

                    Fluttertoast.showToast(msg: 'Please Wait Pdf Generating...');

                    DateTime currentDate = DateTime.now();

                    DateTime filtered = DateTime(
                        currentDate.year,
                        bankDetailScreenController.selectedFilter.value == 'Last Month' ? currentDate.month - 1
                            : bankDetailScreenController.selectedFilter.value == 'Last 2 Months' ? currentDate.month - 2
                            : bankDetailScreenController.selectedFilter.value == 'Last 3 Months' ? currentDate.month - 3
                            : currentDate.month - 6,
                        currentDate.day
                    );

                    List<Map<dynamic, dynamic>> finalDate = [];
                    for (int i = 0; i <= currentDate.month - filtered.month; i++) {
                      String date = DateFormat('MMM yyyy').format(DateTime(filtered.year, filtered.month + i, filtered.day));
                      List<Map<String, dynamic>> listMessages = bottomNavigationScreenController.allMessageDetails.groupBy('group');
                      listMessages.forEach((element) {
                        if(element.keys.contains(date)) {
                          List<Map<dynamic, dynamic>> list = List<Map<dynamic, dynamic>>.from(element.values.first.toSet());
                          list.sort((a, b) => a['date'].compareTo(b['date']));
                          finalDate.addAll(list);
                        }
                      });
                    }

                    if(finalDate.isNotEmpty) {
                      final document = pw.Document();
                      document.addPage(
                          pw.Page(
                              pageFormat: PdfPageFormat.undefined,
                              build: (context) {
                                double width = 100.w;
                                return pw.ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return pw.Container(
                                        width: 100.w,
                                        child: pw.Divider(thickness: 5.sp, color: PdfColors.black, height: 0)
                                    );
                                  },
                                  // 318154
                                  itemCount: finalDate.length + 1,
                                  itemBuilder: (context, index) {
                                    return pw.Container(
                                        height: 25.sp,
                                        child: pw.Row(
                                            children: [
                                              pw.Container(
                                                  width: width * 0.2,
                                                  alignment: pw.Alignment.center,
                                                  child: pw.Text(index == 0 ? 'Date' : DateFormat('dd MMM').format(finalDate[index - 1]['date']),
                                                      style: pw.TextStyle(fontSize: 15.sp)
                                                  )
                                              ),
                                              pw.Container(width: 1, color: PdfColors.black, height: double.infinity),
                                              pw.Container(
                                                  width: width * 0.5,
                                                  child: pw.Container(
                                                      padding: pw.EdgeInsets.only(left: 15.sp),
                                                      child: pw.Text(index == 0 ? 'Transaction Name' : finalDate[index - 1]['transaction_account'],
                                                          style: pw.TextStyle(fontSize: 15.sp),
                                                          overflow: pw.TextOverflow.clip
                                                      )
                                                  )
                                              ),
                                              pw.Container(width: 1, color: PdfColors.black, height: double.infinity),
                                              pw.Container(
                                                  width: width * 0.25,
                                                  alignment: pw.Alignment.center,
                                                  padding: pw.EdgeInsets.symmetric(horizontal: 12.sp),
                                                  child: pw.Text(index == 0 ? 'Amount' : finalDate[index - 1]['transaction_amount'],
                                                      style: pw.TextStyle(fontSize: 15.sp),
                                                      maxLines: 2)
                                              ),
                                            ]
                                        )
                                    );
                                  },
                                );
                              }
                          )
                      );

                      Future.delayed(const Duration(milliseconds: 2500), () async {
                        Directory dir = await getApplicationDocumentsDirectory();
                        // Directory dir = Directory("/storage/emulated/0/Download/");

                        bool dirDownloadExists = await Directory(dir.path).exists();
                        if(dirDownloadExists){
                          // dir = Directory("/storage/emulated/0/Download/transaction_viewer");
                          // Directory(dir.path).createSync();
                        }else{
                          // await Directory("/storage/emulated/0/Downloads/transaction_viewer").create();
                          // dir = await Directory("/storage/emulated/0/Downloads/transaction_viewer");
                          Directory(dir.path).createSync();
                        }
                        if(!dir.existsSync()) {
                          await dir.create();
                        }

                        String fileName = '/${bankDetailScreenController.selectedFilter.value}.pdf';
                        File file = File(dir.path + fileName);
                        if(!file.existsSync()) {
                          await file.create();
                        }

                        await file.writeAsBytes(await document.save()).whenComplete(() {
                          try {
                            Fluttertoast.showToast(msg: 'Pdf Save At : ${file.path}');
                            // OpenFilex.open(file.path, type: "application/pdf");
                            fileOpen(filePath: file.path);
                          } catch(err) {
                            print('open pdf err -> ${err}');
                          }
                        });
                      });
                    } else {
                      Fluttertoast.showToast(msg: 'No Transaction Available For ${bankDetailScreenController.selectedFilter.value}');
                    }

                    Get.back();
                  },
                  child: Container(
                    height: 5.h,
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
                ),
                SizedBox(height: 15.sp),
              ],
            ),
          ),
        )
    );
  }

  fileOpen({required String filePath}) {
    Get.dialog(
        AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 00.sp),
          content: Container(
            width: 70.w,
            decoration: BoxDecoration(
                gradient: ConstantsColor.buttonGradient,
                borderRadius: BorderRadius.circular(18.sp),
                border: Border.all(color: Colors.white)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 24.sp),
                Text('Do You Want To Open Pdf?', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w400),),
                SizedBox(height: 21.sp),
                Divider(color: Colors.white, height: 0),
                IntrinsicHeight(
                  child: Container(
                    height: 27.sp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                            OpenFilex.open(filePath, type: "application/pdf");
                          },
                          child: Expanded(
                              child: Text('YES', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w400),)
                          ),
                        ),
                        VerticalDivider(color: Colors.white),
                        InkWell(
                          onTap: () => Get.back(),
                          child: Expanded(
                              child: Text('NO', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w400),)
                          ),
                        ),
                      ],
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
