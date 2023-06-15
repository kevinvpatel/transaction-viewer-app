import 'dart:convert';
import 'dart:developer';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transaction_viewer_app/app/data/Reg_Model.dart';
import 'package:transaction_viewer_app/app/data/services.dart';

class BillPaymentScreenController extends GetxController {
  //TODO: Implement BillPaymentScreenController

  // RxList<Patterns> cashMoneyList = <Patterns>[].obs;
  RxList<Map<String, dynamic>> cashMoneyList = <Map<String, dynamic>>[].obs;
  ///ana through data show karavvana bill & emi screen ma
  RxList<Map<String, dynamic>> billsEmiList = <Map<String, dynamic>>[].obs;
  ScrollController scrollController = ScrollController();

  RxDouble cashMoneyPercentage = 0.0.obs;
  RxDouble billsEmiPercentage = 0.0.obs;

  Future getData({
    required RxList<Patterns> listPattern,
    required RxDouble percentage,
    required RxList<Map<String, dynamic>> listData
  }) async {
    try {
      await SMSServices.getSmsData().then((messages) async {
        for(int i = 0; i < messages.length; i++) {

          for(int j = 0; j < listPattern.length; j++) {

            if(j == 0) {
              await Future.delayed(const Duration(milliseconds: 100));
              percentage.value = i / messages.length * 100;
            }
            print('listPattern[j].patternUID ->> ${listPattern[j].patternUID}');
            print('listPattern[j].regex111 ->> ${listPattern[j].regex}');

            String? expression = listPattern[j].regex;
            expression = expression!.replaceAll(
                '(?i)',
                ''
            );
            final tryRegEx = RegExp(expression, caseSensitive: false);
            RegExpMatch? result = tryRegEx.firstMatch(messages[i].body!);

            if(result != null) {
              print('expression ->> ${expression}');
              print('listPattern[j].regex222 ->> ${listPattern[j].regex}');
              print('messages[i].body ->> ${messages[i].body}');
              print('result == null ->> ${result == null}');
              int? accountNumberGroupId = listPattern[j].dataFields?.pan?.groupId;
              final account_number = accountNumberGroupId == null ? listPattern[j].dataFields?.pan?.value : result.group(accountNumberGroupId);

              int? transactionGroupId;
              if(listPattern[j].dataFields?.pos?.groupId != null) {
                transactionGroupId = listPattern[j].dataFields?.pos?.groupId;
              } else if(listPattern[j].dataFields?.transactionTypeRule?.groupId != null) {
                transactionGroupId = listPattern[j].dataFields?.transactionTypeRule?.groupId;
              } else if(listPattern[j].dataFields?.note?.groupId != null) {
                transactionGroupId = listPattern[j].dataFields?.note?.groupId;
              } else {
                transactionGroupId = listPattern[j].dataFields?.posTypeRules?.groupId;
              }
              final transaction_account = transactionGroupId == null ? null : result.group(transactionGroupId);

              Duration duration = DateTime.now().difference(messages[i].date!);
              listData.add({
                'date' : messages[i].date!,
                'duration' : duration,
                'body' : messages[i].body!,
                'group' : DateFormat('MMM yyyy').format(messages[i].date!),
                'account_number' : account_number,
                'transaction_account' : transaction_account,
                'category' : listPattern[j].dataFields?.statementType == 'loan_emi' ? 'Loan EMIs'
                    : listPattern[j].dataFields?.transactionType == 'debit_atm' ? 'ATM Withdrawal'
                    : listPattern[j].dataFields?.statementType == 'debit_prepaid' ? 'Prepaid Bill'
                    : listPattern[j].dataFields?.statementType == 'mobile_bill' ? 'Phone Bill'
                    : listPattern[j].dataFields?.statementType == 'credit_card_bill' ? 'Credit Card Bill'
                    : listPattern[j].dataFields?.statementType == 'gas_bill' ? 'Gas Bill'
                    : listPattern[j].dataFields?.statementType == 'electricity_bill' ? 'Electricity Bill'
                    : listPattern[j].dataFields?.statementType == 'insurance_premium' ? 'Insurance Bill'
                    : 'Generic Bill'
              });
              log('listData ->> $listData');
              print(' ');
            }
          }
        }
      });
    } catch(err) {
      print('err bill payment ->> $err');
    }
  }


  Future<RxList<Patterns>> getCashTransactionType() async {
    RxList<Patterns> lstPattern = <Patterns>[].obs;
    String jsonData = await rootBundle.loadString('assets/reg.json');
    Map<String, dynamic> result = json.decode(jsonData);
    Reg regData = Reg.fromJson(result);

    for(int i = 0; i < regData.rules!.length; i++) {
      regData.rules![i].patterns?.forEach((pattern) {
        if(pattern.dataFields?.transactionType == 'debit_atm') {
          lstPattern.add(pattern);
        }
      });
    }
    return lstPattern;
  }


  Future<RxList<Patterns>> getBillsTransactionType() async {
    RxList<Patterns> lstPattern = <Patterns>[].obs;
    String jsonData = await rootBundle.loadString('assets/reg.json');
    Map<String, dynamic> result = json.decode(jsonData);
    Reg regData = Reg.fromJson(result);

    for(int i = 0; i < regData.rules!.length; i++) {
      regData.rules![i].patterns?.forEach((pattern) {
        if(pattern.dataFields?.transactionType == 'loan_emi'
            || pattern.dataFields?.transactionType == 'debit_prepaid'
            || pattern.dataFields?.transactionType == 'electricity_bill'
            || pattern.dataFields?.transactionType == 'insurance_premium'
            || pattern.dataFields?.transactionType == 'gas_bill'
            || pattern.dataFields?.transactionType == 'credit_card_bill'
            || pattern.dataFields?.transactionType == 'mobile_bill'
            || pattern.accountType == 'generic') {
          lstPattern.add(pattern);
        }
      });
    }
    return lstPattern;
  }


  @override
  void onInit() {
    super.onInit();
    if(cashMoneyPercentage.value <= 0.0) {
      getCashTransactionType().then((listPattern) {
        getData(listPattern: listPattern, percentage: cashMoneyPercentage, listData: cashMoneyList);
      });
    }

    if(billsEmiPercentage.value <= 0.0) {
      getBillsTransactionType().then((listPattern) {
        print('list## -> $listPattern');
        getData(listPattern: listPattern, percentage: billsEmiPercentage, listData: billsEmiList);
      });
    }
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
