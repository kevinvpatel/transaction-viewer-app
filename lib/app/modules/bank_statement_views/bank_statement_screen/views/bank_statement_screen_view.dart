import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/views/bank_detail_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/bottom_navigation_screen/controllers/bottom_navigation_screen_controller.dart';
import '../controllers/bank_statement_screen_controller.dart';

class BankStatementScreenView extends GetView<BankStatementScreenController> {
  const BankStatementScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BankStatementScreenController bankStatementScreenController = Get.put(BankStatementScreenController());
    BottomNavigationScreenController bottomNavigationScreenController = Get.put(BottomNavigationScreenController());
    double height = 100.h;
    double width = 100.w;


    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      body: Container(
        margin: EdgeInsets.only(top: 15.sp),
        height: height,
        width: width,
        // alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: GetBuilder(
            init: BankStatementScreenController(),
            builder: (controller) {
                print('listBanks33 -> ${controller.listBanks}');
                print('wallet -> ${controller.listWallets}');
              return Column(
                children: [
                  ///Bank List
                  Container(
                    height: 25.sp,
                    width: width,
                    margin: EdgeInsets.only(left: 17.sp, top: 20.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Balance Check', style: TextStyle(color: Colors.white, fontSize: 20.5.sp, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 20.sp),
                    // itemCount: controller.bankStatementList.length,
                    itemCount: controller.listBanks.length,
                    itemBuilder: (context, index) {

                      var bankName = bottomNavigationScreenController.bankStatementList.where((val) {
                        print('val -> ${val}');
                        print('listBanks[index].keys -> ${controller.listBanks[index]}');
                        print(' ');

                        return val['account_number'] == controller.listBanks[index].keys.first;
                      }).toList();
                      bankName = bankName.toList();

                      print('bankName11 -> ${bankName}');
                      print('bankName.first[bank_name] -> ${bankName.first['bank_name']}');

                      return InkWell(
                        onTap: () {
                          List<Map<dynamic, dynamic>> tempList = List<Map<dynamic, dynamic>>.from(controller.listBanks[index].values.first);
                          List<Map<dynamic, dynamic>> transactionList = tempList.groupBy('transaction_type');
                          List<Map<dynamic, dynamic>> creditList = [];
                          List<Map<dynamic, dynamic>> debitList = [];
                          transactionList.forEach((element) {
                            print('## -> ${element.keys}');

                            if(element.keys.first == 'debit') {
                              List<Map<dynamic, dynamic>> tempDebitList = List<Map<dynamic, dynamic>>.from(element.values.first);
                              debitList.addAll(tempDebitList);
                            }

                            if(element.keys.first == 'credit') {
                              List<Map<dynamic, dynamic>> tempCreditList = List<Map<dynamic, dynamic>>.from(element.values.first);
                              creditList.addAll(tempCreditList);
                            }
                          });

                          AdService adService = AdService();
                          adService.checkCounterAd(
                              currentScreen: '/BankStatementScreenView',
                              context: context,
                              pageToNavigate: const BankDetailScreenView(),
                              argument: {
                                'bank_name' : bankName.first['bank_name'],
                                'bank_amount' : bankName.first['total_balance'],
                                'bank_account_number' : bankName.first['account_number'],
                                'bank_data_all_messages' : controller.listBanks[index].values.first,
                                'bank_data_credit_messages' : creditList,
                                'bank_data_debit_messages' : debitList
                              }
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
                              // convertBankAddressToBankIcon(bankName: controller.bankStatementList[index]['bank_name'], bankBundleData: controller.bankBundleData),
                              convertBankAddressToBankIcon(bankName: bankName.first['bank_name'], bankBundleData: controller.bankBundleData),
                              SizedBox(width: 15.sp),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(controller.bankStatementList[index]['bank_name'], style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                                  Text(bankName.first['bank_name'], style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10.sp),
                                  Text.rich(
                                      TextSpan(
                                          text: 'Your available balance : ',
                                          style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w300),
                                          children: [
                                            TextSpan(
                                              // text: '₹ ${controller.bankStatementList[index]['total_balance']}',
                                              text: '₹ ${bankName.first['total_balance']}',
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
                  ),

                  ///Debit Card List
                  controller.listDebitCards.length > 0 ? Container(
                    // color: Colors.blue,
                    height: 25.sp,
                    width: width,
                    margin: EdgeInsets.only(left: 17.sp, top: 20.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Debit Cards', style: TextStyle(color: Colors.white, fontSize: 20.5.sp, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ) : SizedBox.shrink(),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 20.sp),
                    // itemCount: controller.bankStatementList.length,
                    itemCount: controller.listDebitCards.length,
                    itemBuilder: (context, index) {

                      var bankName = bottomNavigationScreenController.bankStatementList.where((val) {
                        return val['account_number'] == controller.listDebitCards[index].keys.first;
                      }).toList();
                      bankName = bankName.toList();

                      print('bankName11 -> ${bankName}');
                      print('bankName.first[bank_name] -> ${bankName.first['bank_name']}');

                      return InkWell(
                        onTap: () {
                          List<Map<dynamic, dynamic>> tempList = List<Map<dynamic, dynamic>>.from(controller.listDebitCards[index].values.first);
                          List<Map<dynamic, dynamic>> transactionList = tempList.groupBy('transaction_type');
                          List<Map<dynamic, dynamic>> creditList = [];
                          List<Map<dynamic, dynamic>> debitList = [];
                          transactionList.forEach((element) {
                            print('## -> ${element.keys}');

                            if(element.keys.first == 'debit') {
                              List<Map<dynamic, dynamic>> tempDebitList = List<Map<dynamic, dynamic>>.from(element.values.first);
                              debitList.addAll(tempDebitList);
                            }

                            if(element.keys.first == 'credit') {
                              List<Map<dynamic, dynamic>> tempCreditList = List<Map<dynamic, dynamic>>.from(element.values.first);
                              creditList.addAll(tempCreditList);
                            }
                          });

                          AdService adService = AdService();
                          adService.checkCounterAd(
                              currentScreen: '/BankStatementScreenView',
                              context: context,
                              pageToNavigate: const BankDetailScreenView(),
                              argument: {
                                'bank_name' : bankName.first['bank_name'],
                                'bank_amount' : bankName.first['total_balance'],
                                'bank_account_number' : bankName.first['account_number'],
                                'bank_data_all_messages' : controller.listDebitCards[index].values.first,
                                'bank_data_credit_messages' : creditList,
                                'bank_data_debit_messages' : debitList
                              }
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
                              // convertBankAddressToBankIcon(bankName: controller.bankStatementList[index]['bank_name'], bankBundleData: controller.bankBundleData),
                              convertBankAddressToBankIcon(bankName: bankName.first['bank_name'], bankBundleData: controller.bankBundleData),
                              SizedBox(width: 15.sp),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(controller.bankStatementList[index]['bank_name'], style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                                  Text(bankName.first['bank_name'], style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10.sp),
                                  Text.rich(
                                      TextSpan(
                                          text: 'Your available balance : ',
                                          style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w300),
                                          children: [
                                            TextSpan(
                                              // text: '₹ ${controller.bankStatementList[index]['total_balance']}',
                                              text: '₹ ${bankName.first['total_balance']}',
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
                  ),

                  ///Wallet List
                  controller.listWallets.length > 0 ? Container(
                    // color: Colors.blue,
                    height: 25.sp,
                    width: width,
                    margin: EdgeInsets.only(left: 17.sp, top: 21.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Wallets', style: TextStyle(color: Colors.white, fontSize: 20.5.sp, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ) : SizedBox.shrink(),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 20.sp),
                    // itemCount: controller.bankStatementList.length,
                    itemCount: controller.listWallets.length,
                    itemBuilder: (context, index) {

                      var bankName = bottomNavigationScreenController.bankStatementList.where((val) {
                        return val['account_number'] == controller.listWallets[index].keys.first;
                      }).toList();
                      bankName = bankName.toList();

                      print('bankName22 -> ${bankName}');
                      print('bankName.first[bank_name] -> ${bankName.first['bank_name']}');

                      return InkWell(
                        onTap: () {
                          List<Map<dynamic, dynamic>> tempList = List<Map<dynamic, dynamic>>.from(controller.listWallets[index].values.first);
                          List<Map<dynamic, dynamic>> transactionList = tempList.groupBy('transaction_type');
                          List<Map<dynamic, dynamic>> creditList = [];
                          List<Map<dynamic, dynamic>> debitList = [];
                          transactionList.forEach((element) {
                            print('## -> ${element.keys}');

                            if(element.keys.first == 'debit') {
                              List<Map<dynamic, dynamic>> tempDebitList = List<Map<dynamic, dynamic>>.from(element.values.first);
                              debitList.addAll(tempDebitList);
                            }

                            if(element.keys.first == 'credit') {
                              List<Map<dynamic, dynamic>> tempCreditList = List<Map<dynamic, dynamic>>.from(element.values.first);
                              creditList.addAll(tempCreditList);
                            }

                          });

                          AdService adService = AdService();
                          adService.checkCounterAd(
                              currentScreen: '/BankStatementScreenView',
                              context: context,
                              pageToNavigate: const BankDetailScreenView(),
                              argument: {
                                'bank_name' : bankName.first['bank_name'],
                                'bank_amount' : bankName.first['total_balance'],
                                'bank_account_number' : 'N/A',
                                'bank_data_all_messages' : controller.listWallets[index].values.first,
                                'bank_data_credit_messages' : creditList,
                                'bank_data_debit_messages' : debitList
                              }
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
                              // convertBankAddressToBankIcon(bankName: controller.bankStatementList[index]['bank_name'], bankBundleData: controller.bankBundleData),
                              convertBankAddressToBankIcon(bankName: bankName.first['bank_name'], bankBundleData: controller.bankBundleData),
                              SizedBox(width: 15.sp),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(controller.bankStatementList[index]['bank_name'], style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                                  Text(bankName.first['bank_name'], style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10.sp),
                                  Text.rich(
                                      TextSpan(
                                          text: 'Your available balance : ',
                                          style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w300),
                                          children: [
                                            TextSpan(
                                              // text: '₹ ${controller.bankStatementList[index]['total_balance']}',
                                              text: '₹ ${bankName.first['total_balance']}',
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
                  ),

                  SizedBox(height: 20.sp)
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
