import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:transaction_viewer_app/app/data/Reg_Model.dart';
import 'package:transaction_viewer_app/app/data/regData.dart';
import 'package:transaction_viewer_app/app/data/services.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/controllers/bank_statement_screen_controller.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/views/bank_statement_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/bill_payment_screen/views/bill_payment_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/home_views/home_screen/views/home_screen_view.dart';

class BottomNavigationScreenController extends GetxController {
  //TODO: Implement BottomNavigationScreenController

  late PageController pageController;
  RxInt bottomNavigationTabIndex = 1.obs;


  RxDouble percentage = 0.0.obs;
  RxInt percentageCounter = 0.obs;

  late Box messageBox;

  RxList<String?> bankList = <String?>[].obs;
  RxList<Map> bankStatementList = <Map>[].obs;
  RxList<Map> allMessageDetails = <Map>[].obs;
  RxList<Map> creditMessageDetails = <Map>[].obs;
  RxList<Map> debitMessageDetails = <Map>[].obs;


  Future loadBankCategory() async {
    percentageCounter = 0.obs;
    messageBox = await Hive.openBox('messageBox');

    await SMSServices.getSmsData().then((sms) async {
      print('sms messageBox ->> ${messageBox.get('smsLength') == null}');
      int smsLength = 0;
      if(messageBox.get('smsLength') == null) {
        messageBox.put('smsLength', sms.length);
      } else {
        smsLength = messageBox.get('smsLength');
      }
      print('smsLength ->> ${smsLength}');
      print('sms ->> ${sms.length}');
      print('messageBox.length ->> ${messageBox.length}');

      // fetchSms();

      if(messageBox.length <= 1) {
        fetchSms();
      } else {
        if(smsLength != sms.length) {
          fetchSms();
        } else {
          percentage.value = 100.0;
          ///Balance Check
          allMessageDetails.addAll(List<Map>.from(messageBox.get('allMessageDetails')));
          creditMessageDetails.addAll(List<Map>.from(messageBox.get('creditMessageDetails')));
          debitMessageDetails.addAll(List<Map>.from(messageBox.get('debitMessageDetails')));
          bankStatementList.addAll(List<Map>.from(messageBox.get('bankStatementList')));
          print('bankStatementList@ 111  -> ${bankStatementList}');
        }
      }
    });
  }


  RxList<Map> cashMoneyList = <Map>[].obs;

  Future fetchSms() async {
    // String jsonData = await rootBundle.loadString('assets/reg.json');
    // Map<String, dynamic> result = json.decode(jsonData);
    print('regJson -> $regJson');
    Reg regData = Reg.fromJson(regJson);
    print('regData -> $regData');

    await SMSServices.getSmsData().then((messages) async {
      messageBox.put('smsLength', messages.length);

      for(int i = 0; i < messages.length; i++) {

        for(int j = 0; j < regData.rules!.length; j++) {

          if(j == 0) {
            await Future.delayed(const Duration(milliseconds: 100));
            percentageCounter.value++;
            percentage.value = (percentageCounter.value) / messages.length * 100;
          }


          ///Check all sms available in RegEx json

          if(regData.rules![j].senders!.any((element) => messages[i].address!.contains(element))) {
            print('regData.rules![j].senders -> ${regData.rules![j].senders}');
            print('messages[i].address?.split(-).last -> ${messages[i].address?.split('-').last}');
            ///RegEx Transaction message
            regData.rules![j].patterns!.forEach((regex) {
              final tempEx = regex.regex!.replaceAll(
                  '(?i)',
                  ''
              );
              final tryRegEx = RegExp(tempEx, caseSensitive: false);
              RegExpMatch? result = tryRegEx.firstMatch(messages[i].body!);
              print('tempEx111 -> ${tempEx}');
              print('messages body111 -> ${messages[i].body}');
              print('result -> ${result}');

              if(result != null) {
                int? accountBalanceGroupId = regex.dataFields?.accountBalance?.groupId;
                final account_balance = accountBalanceGroupId == null ? null : result.group(accountBalanceGroupId);

                int? accountNumberGroupId = regex.dataFields?.pan?.groupId;
                final account_number = accountNumberGroupId == null ? regex.dataFields?.pan?.value : result.group(accountNumberGroupId);

                int? amountGroupId = regex.dataFields?.amount?.groupId;
                final transaction_amount = amountGroupId == null ? null : result.group(amountGroupId);

                int? transactionGroupId;
                if(regex.dataFields?.pos?.groupId != null) {
                  transactionGroupId = regex.dataFields?.pos?.groupId;
                } else if(regex.dataFields?.transactionTypeRule?.groupId != null) {
                  transactionGroupId = regex.dataFields?.transactionTypeRule?.groupId;
                } else if(regex.dataFields?.note?.groupId != null) {
                  transactionGroupId = regex.dataFields?.note?.groupId;
                } else {
                  transactionGroupId = regex.dataFields?.posTypeRules?.groupId;
                }
                final transaction_account = transactionGroupId == null ? null : result.group(transactionGroupId);

                ///account_balance != null means sms have proper transaction messages


                print('messages body222 -> ${messages[i].body}');
                print('account_balance -> $account_balance');
                ///Balance Check Detail Screen Data
                if(account_balance != null) {
                  allMessageDetails.value.add({
                    'date' : messages[i].date!,
                    'body' : messages[i].body!,
                    'group' : DateFormat('MMM yyyy').format(messages[i].date!),
                    'transaction_amount' : transaction_amount,
                    'account_balance' : account_balance,
                    'account_number' : account_number,
                    'transaction_account' : transaction_account,
                    'transaction_type' : regex.dataFields?.transactionType == 'credit' ? 'credit' : 'debit',
                    'isDuplicate' : regex.dataFields?.posTypeRules?.rules?.last.incomeFlagOverride == false ? true : false,
                    'isDebitCard' : regex.dataFields!.transactionTypeRule?.rules?.any((element) => element.txnType == 'debit_atm') == true ? true : false
                  });

                  if(regex.dataFields?.transactionType == 'credit') {
                    creditMessageDetails.value.add({
                      'date' : messages[i].date!,
                      'body' : messages[i].body!,
                      'group' : DateFormat('MMM yyyy').format(messages[i].date!),
                      'transaction_amount' : transaction_amount,
                      'account_balance' : account_balance,
                      'account_number' : account_number,
                      'transaction_account' : transaction_account,
                      'transaction_type' : 'credit',
                      'isDuplicate' : regex.dataFields?.posTypeRules?.rules?.last.incomeFlagOverride == false ? true : false,
                      'isDebitCard' : regex.dataFields!.transactionTypeRule?.rules?.any((element) => element.txnType == 'debit_atm') == true ? true : false
                    });
                  } else {
                    debitMessageDetails.value.add({
                      'date' : messages[i].date!,
                      'body' : messages[i].body!,
                      'group' : DateFormat('MMM yyyy').format(messages[i].date!),
                      'transaction_amount' : transaction_amount,
                      'account_balance' : account_balance,
                      'account_number' : account_number,
                      'transaction_account' : transaction_account,
                      'transaction_type' : 'debit',
                      'isDuplicate' : regex.dataFields?.posTypeRules?.rules?.last.incomeFlagOverride == false ? true : false,
                      'isDebitCard' : regex.dataFields!.transactionTypeRule?.rules?.any((element) => element.txnType == 'debit_atm') == true ? true : false
                    });
                  }


                  ///Balance Check Screen Data
                  if(!bankList.contains(account_number)) {
                    bankList.add(account_number);
                    Map<String, dynamic> tempBankMap = {};
                    tempBankMap['bank_address'] = messages[i].address?.split('-').last;
                    tempBankMap['bank_name'] = regData.rules![j].fullName;
                    tempBankMap['account_number'] = account_number;
                    tempBankMap['total_balance'] = account_balance;
                    bankStatementList.add(tempBankMap);
                    bankStatementList.value = bankStatementList.toSet().toList();
                  }
                }

                ///Bill Payment Screen Data
                if(regex.dataFields?.transactionType == 'loan_emi' || regex.dataFields?.transactionType == 'debit_prepaid'
                    || regex.dataFields?.transactionType == 'electricity_bill' || regex.dataFields?.transactionType == 'insurance_premium'
                    || regex.dataFields?.transactionType == 'gas_bill' || regex.dataFields?.transactionType == 'credit_card_bill'
                    || regex.dataFields?.transactionType == 'mobile_bill' || regex.dataFields?.transactionType == 'internet_bill'
                ) {
                  billPaymentDataAdd(
                      smsDateTime: messages[i].date!,
                      smsBody: messages[i].body!,
                      account_number: account_number,
                      transaction_account: transaction_account,
                      listName: cashMoneyList,
                      regex: regex,
                      category: regex.dataFields!.transactionType!
                  );
                } else if(regex.dataFields?.statementType == 'loan_emi' || regex.dataFields?.statementType == 'debit_prepaid'
                    || regex.dataFields?.statementType == 'electricity_bill' || regex.dataFields?.statementType == 'insurance_premium'
                    || regex.dataFields?.statementType == 'gas_bill' || regex.dataFields?.statementType == 'credit_card_bill'
                    || regex.dataFields?.statementType == 'mobile_bill' || regex.dataFields?.statementType == 'internet_bill'
                ) {
                  billPaymentDataAdd(
                      smsDateTime: messages[i].date!,
                      smsBody: messages[i].body!,
                      account_number: account_number,
                      transaction_account: transaction_account,
                      listName: cashMoneyList,
                      regex: regex,
                      category: regex.dataFields!.statementType!
                  );
                }

                // if(regex.dataFields!.transactionTypeRule!.rules!.any((element) => element.txnType == 'debit_atm')) {
                //   billPaymentDataAdd(
                //       smsDateTime: messages[i].date!,
                //       smsBody: messages[i].body!,
                //       account_number: account_number,
                //       transaction_account: transaction_account,
                //       listName: cashMoneyList,
                //       regex: regex,
                //       category: 'debit_atm'
                //   );
                // }

                regex.dataFields?.transactionTypeRule?.rules?.forEach((rule) {
                  if(rule.txnType == 'debit_atm') {
                    billPaymentDataAdd(
                        smsDateTime: messages[i].date!,
                        smsBody: messages[i].body!,
                        account_number: account_number,
                        transaction_account: transaction_account,
                        listName: cashMoneyList,
                        regex: regex,
                        category: rule.txnType!
                    );
                  }
                });

              }
            });
          }
        }
      }
      update();
    }).whenComplete(() {
      ///Balance Check
      messageBox.put('bankStatementList', bankStatementList);
      print('mapMessageList@ -> ${bankStatementList}');
      messageBox.put('allMessageDetails', allMessageDetails);
      messageBox.put('creditMessageDetails', creditMessageDetails);
      messageBox.put('debitMessageDetails', debitMessageDetails);

      ///Bill Payment
      messageBox.put('cashMoneyList', cashMoneyList);
      update();
    });
  }


  billPaymentDataAdd({
    required RxList<Map> listName,
    required String smsBody,
    required DateTime smsDateTime,
    required String? account_number,
    required Patterns regex,
    required String category,
    required String? transaction_account}) {
    listName.add({
      'date' : smsDateTime,
      'body' : smsBody,
      'group' : DateFormat('MMM yyyy').format(smsDateTime),
      'account_number' : account_number,
      'transaction_account' : transaction_account,
      'forKnown' : category,
      'patternUID' : regex.patternUID,
      'category' : category == 'loan_emi' ? 'Loan EMIs'
          : category == 'internet_bill' ? 'Generic Bill'
          : category == 'debit_prepaid' ? 'Prepaid Bill'
          : category == 'mobile_bill' ? 'Phone Bill'
          : category == 'credit_card_bill' ? 'Credit Card Bill'
          : category == 'gas_bill' ? 'Gas Bill'
          : category == 'electricity_bill' ? 'Electricity Bill'
          : category == 'insurance_premium' ? 'Insurance Bill'
          : category == 'debit_atm' ? 'ATM Withdrawal'
          : 'none',
    });
  }



  List<Widget> lstScreens = [
    BankStatementScreenView(),
    HomeScreenView(),
    BillPaymentScreenView(),
  ];


  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: bottomNavigationTabIndex.value);
    loadBankCategory();
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
