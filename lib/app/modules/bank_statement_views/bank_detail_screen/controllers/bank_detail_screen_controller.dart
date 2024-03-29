import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:transaction_viewer_app/app/data/Reg_Model.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/controllers/bank_statement_screen_controller.dart';

class BankDetailScreenController extends GetxController with GetSingleTickerProviderStateMixin  {
  //TODO: Implement BankStatementViewsBankDetailScreenController

  // RxInt tabIndex = 0.obs;
  // ScrollController scrollController = ScrollController();
  RxString selectedFilter = ''.obs;

  RxList<SmsMessage> messages = <SmsMessage>[].obs;
  // RxList<Map<String, dynamic>> allMessageDetails = <Map<String, dynamic>>[].obs;
  // RxList<Map<String, dynamic>> creditMessageDetails = <Map<String, dynamic>>[].obs;
  // RxList<Map<String, dynamic>> debitMessageDetails = <Map<String, dynamic>>[].obs;

  Rules? rulesData;
  final SmsQuery query = SmsQuery();


  // loadRegExJson() async {
  //   Box messageBox = await Hive.openBox('messageBox');
  //
  //   allMessageDetails.clear();
  //   creditMessageDetails.clear();
  //   debitMessageDetails.clear();
  //   rulesData = Rules();
  //   String passedBankName = Get.arguments['bank_address'];
  //
  //   String jsonData = await rootBundle.loadString('assets/reg.json');
  //   Map<String, dynamic> result = json.decode(jsonData);
  //
  //   List lstPatterns = result['rules'];
  //   print('passedBankName -> ${passedBankName}');
  //   lstPatterns.removeWhere((element) {
  //     return !element['senders'].contains(passedBankName.toUpperCase());
  //   });
  //
  //   try {
  //     rulesData = Rules.fromJson(lstPatterns.first);
  //     messageList.value = messageList.toSet().toList();
  //
  //     messageList.forEach((sms) {
  //       if(sms?.address?.split('-').last == passedBankName) {
  //         for(int i = 0; i < rulesData!.patterns!.length; i++) {
  //           final pattern = rulesData!.patterns![i];
  //           String? expression = pattern.regex;
  //           expression = expression!.replaceAll(
  //               '(?i)',
  //               ''
  //           );
  //           final tryRegEx = RegExp(expression, caseSensitive: false);
  //           RegExpMatch? result = tryRegEx.firstMatch(sms!.body!);
  //           if(result != null) {
  //             // print('sms @@ -> ${sms.body}');
  //             // print('expression @@ -> ${expression}');
  //
  //             int? amountGroupId = pattern.dataFields?.amount?.groupId;
  //             final transaction_amount = amountGroupId == null ? null : result.group(amountGroupId);
  //             // print('amount -> $transaction_amount');
  //
  //             int? accountNumberGroupId = pattern.dataFields?.pan?.groupId;
  //             final account_number = accountNumberGroupId == null ? pattern.dataFields?.pan?.value : result.group(accountNumberGroupId);
  //             // print('account_number -> $account_number');
  //
  //             int? accountBalanceGroupId = pattern.dataFields?.accountBalance?.groupId;
  //             final account_balance = accountBalanceGroupId == null ? null : result.group(accountBalanceGroupId);
  //             // print('account_balance -> $account_balance');
  //
  //             int? transactionGroupId;
  //             if(pattern.dataFields?.pos?.groupId != null) {
  //               transactionGroupId = pattern.dataFields?.pos?.groupId;
  //             } else if(pattern.dataFields?.transactionTypeRule?.groupId != null) {
  //               transactionGroupId = pattern.dataFields?.transactionTypeRule?.groupId;
  //             } else if(pattern.dataFields?.note?.groupId != null) {
  //               transactionGroupId = pattern.dataFields?.note?.groupId;
  //             } else {
  //               transactionGroupId = pattern.dataFields?.posTypeRules?.groupId;
  //             }
  //             final transaction_account = transactionGroupId == null ? null : result.group(transactionGroupId);
  //
  //             Duration duration = DateTime.now().difference(sms.date!);
  //             allMessageDetails.value.add({
  //               'date' : sms.date!,
  //               'duration' : duration,
  //               'body' : sms.body!,
  //               'group' : DateFormat('MMM yyyy').format(sms.date!),
  //               'transaction_amount' : transaction_amount,
  //               'account_balance' : account_balance,
  //               'account_number' : account_number,
  //               'transaction_account' : transaction_account,
  //               'transaction_type' : pattern.dataFields?.transactionType == 'credit' ? 'credit' : 'debit',
  //               'isDuplicate' : pattern.dataFields?.posTypeRules?.rules?.last.incomeFlagOverride == false ? true : false
  //             });
  //
  //             if(pattern.dataFields?.transactionType == 'credit') {
  //               creditMessageDetails.value.add({
  //                 'date' : sms.date!,
  //                 'duration' : duration,
  //                 'body' : sms.body!,
  //                 'group' : DateFormat('MMM yyyy').format(sms.date!),
  //                 'transaction_amount' : transaction_amount,
  //                 'account_balance' : account_balance,
  //                 'account_number' : account_number,
  //                 'transaction_account' : transaction_account,
  //                 'transaction_type' : 'credit',
  //                 'isDuplicate' : pattern.dataFields?.posTypeRules?.rules?.last.incomeFlagOverride == false ? true : false
  //               });
  //             } else {
  //               debitMessageDetails.value.add({
  //                 'date' : sms.date!,
  //                 'duration' : duration,
  //                 'body' : sms.body!,
  //                 'group' : DateFormat('MMM yyyy').format(sms.date!),
  //                 'transaction_amount' : transaction_amount,
  //                 'account_balance' : account_balance,
  //                 'account_number' : account_number,
  //                 'transaction_account' : transaction_account,
  //                 'transaction_type' : 'debit',
  //                 'isDuplicate' : pattern.dataFields?.posTypeRules?.rules?.last.incomeFlagOverride == false ? true : false
  //               });
  //             }
  //             update();
  //             break;
  //           }
  //         }
  //       }
  //     });
  //
  //   } catch(err) {
  //     print('reg json err -> $err');
  //   }
  // }

  onClickRadio(value) async {
    selectedFilter.value = value!;
    update();
  }

  // Map<String, dynamic> listTransactions = <String, dynamic>{};
  List<Map<dynamic, dynamic>> listAllTransactions = <Map<String, dynamic>>[];
  List<Map<dynamic, dynamic>> listCreditTransactions = <Map<String, dynamic>>[];
  List<Map<dynamic, dynamic>> listDebitTransactions = <Map<String, dynamic>>[];

  @override
  void onInit() {
    super.onInit();
    listAllTransactions = List<Map<dynamic, dynamic>>.from(Get.arguments['bank_data_all_messages']);
    listCreditTransactions = List<Map<dynamic, dynamic>>.from(Get.arguments['bank_data_credit_messages']);
    listDebitTransactions = List<Map<dynamic, dynamic>>.from(Get.arguments['bank_data_debit_messages']);
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
