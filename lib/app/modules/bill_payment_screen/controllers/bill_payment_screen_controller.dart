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


  RxBool isShowHeading = true.obs;

  List<String> listTransaction = ['15/05/23 Stmt Alert: Total Amount Due on your IndusInd Bank Credit Card XXXX4808 '
      'is INR 2089.59 and Minimum Amount Due is INR 104.48, payable by 04/06/23. Payment to be made immediately if '
      'previous statement dues are unpaid or Card account is overlimit. Click https://bit.ly/3exupmF to pay now - IndusInd Bank',
      'Greetings from RBL Bank! Your a/c XXX3015 is debited with INR 9000.00 for Chq No 22 on 12-05-2023 ref . URVA ARVINDBHAI '
          'PATEL.Available balance is INR 998296.45 . Please call  91 22 61156300 or 1800 1206 16161 for any assistance.'
  ];

  Future getData({
    required RxList<Patterns> listPattern,
    required RxDouble percentage,
    required RxList<Map<String, dynamic>> listData
  }) async {
    try {
      for(int i = 0; i < listTransaction.length; i++) {

        for(int j = 0; j < listPattern.length; j++) {

          if(j == 0) {
            await Future.delayed(const Duration(milliseconds: 100));
            percentage.value = ((i+1) / listTransaction.length) * 100;
          }

          String? expression = listPattern[j].regex;
          expression = expression!.replaceAll(
              '(?i)',
              ''
          );
          final tryRegEx = RegExp(expression, caseSensitive: false);
          RegExpMatch? result = tryRegEx.firstMatch(listTransaction[i]);

          if(result != null) {
            print('listPattern[j].regex222 ->> ${listPattern[j].regex}');
            print('patternUID ->> ${listPattern[j].patternUID}');
            print('messages[i].body ->> ${listTransaction[i]}');
            int? accountNumberGroupId = listPattern[j].dataFields?.pan?.groupId;
            final account_number = accountNumberGroupId == null
                ? listPattern[j].dataFields?.pan?.value
                : result.group(accountNumberGroupId);

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

            Duration duration = DateTime.now().difference(DateTime.now().add(Duration(days: 2)));

            print('');
            // if(listPattern[j].dataFields?.statementType == 'loan_emi') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Loan EMIs'
            //   });
            //   log('billsEmiList loan_emi1->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.transactionType == 'loan_emi') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Loan EMIs'
            //   });
            //   log('billsEmiList loan_emi2 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.statementType == 'internet_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Loan EMIs'
            //   });
            //   log('billsEmiList internet_bill ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.statementType == 'debit_prepaid') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Prepaid Bill'
            //   });
            //   log('billsEmiList debit_prepaid ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.transactionType == 'mobile_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Phone Bill'
            //   });
            //   log('billsEmiList mobile_bill1 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.statementType == 'mobile_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Phone Bill'
            //   });
            //   log('billsEmiList mobile_bill2 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.transactionType == 'credit_card_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Credit Card Bill'
            //   });
            //   log('billsEmiList credit_card_bill1 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.statementType == 'credit_card_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Credit Card Bill'
            //   });
            //   log('billsEmiList credit_card_bill2 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.transactionType == 'gas_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Gas Bill'
            //   });
            //   log('billsEmiList gas_bill1 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.statementType == 'gas_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Gas Bill'
            //   });
            //   log('billsEmiList gas_bill2 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.statementType == 'electricity_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Electricity Bill'
            //   });
            //   log('billsEmiList electricity_bill1 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.transactionType == 'electricity_bill') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Electricity Bill'
            //   });
            //   log('billsEmiList electricity_bill2 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.transactionType == 'insurance_premium') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Insurance Bill'
            //   });
            //   log('billsEmiList insurance_premium1 ->> $cashMoneyList');
            // } else if(listPattern[j].dataFields?.statementType == 'insurance_premium') {
            //   billsEmiList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'Insurance Bill'
            //   });
            //   log('billsEmiList insurance_premium2 ->> $cashMoneyList');
            // } else {
            //   cashMoneyList.add({
            //     'date' : DateTime.now(),
            //     'duration' : duration,
            //     'body' : listTransaction[i],
            //     'group' : DateFormat('MMM yyyy').format(DateTime.now()),
            //     'account_number' : account_number,
            //     'transaction_account' : transaction_account,
            //     'category' : 'ATM Withdrawal'
            //   });
            //   log('cashMoneyList ->> $cashMoneyList');
            // }
            listData.add({
              'date' : DateTime.now(),
              'duration' : duration,
              'body' : listTransaction[i],
              'group' : DateFormat('MMM yyyy').format(DateTime.now()),
              'account_number' : account_number,
              'transaction_account' : transaction_account,
              'category' : listPattern[j].dataFields?.statementType == 'loan_emi' ? 'Loan EMIs'
                  : listPattern[j].dataFields?.transactionType == 'loan_emi' ? 'Loan EMIs'

                  : listPattern[j].dataFields?.statementType == 'pattern.accountType' ? 'Generic Bill'

                  : listPattern[j].dataFields?.statementType == 'debit_prepaid' ? 'Prepaid Bill'

                  : listPattern[j].dataFields?.transactionType == 'mobile_bill' ? 'Phone Bill'
                  : listPattern[j].dataFields?.statementType == 'mobile_bill' ? 'Phone Bill'

                  : listPattern[j].dataFields?.transactionType == 'credit_card_bill' ? 'Credit Card Bill'
                  : listPattern[j].dataFields?.statementType == 'credit_card_bill' ? 'Credit Card Bill'

                  : listPattern[j].dataFields?.transactionType == 'gas_bill' ? 'Gas Bill'
                  : listPattern[j].dataFields?.statementType == 'gas_bill' ? 'Gas Bill'

                  : listPattern[j].dataFields?.statementType == 'electricity_bill' ? 'Electricity Bill'
                  : listPattern[j].dataFields?.transactionType == 'electricity_bill' ? 'Electricity Bill'

                  : listPattern[j].dataFields?.transactionType == 'insurance_premium' ? 'Insurance Bill'
                  : listPattern[j].dataFields?.statementType == 'insurance_premium' ? 'Insurance Bill'
                  : 'ATM Withdrawal'
            });
            log(' ');
            print(' ');
          }
        }
      }

      // await SMSServices.getSmsData().then((messages) async {
      //   for(int i = 0; i < messages.length; i++) {
      //
      //     for(int j = 0; j < listPattern.length; j++) {
      //
      //       if(j == 0) {
      //         await Future.delayed(const Duration(milliseconds: 100));
      //         percentage.value = i / messages.length * 100;
      //       }
      //       print('listPattern[j].patternUID ->> ${listPattern[j].patternUID}');
      //       print('listPattern[j].regex111 ->> ${listPattern[j].regex}');
      //
      //       String? expression = listPattern[j].regex;
      //       expression = expression!.replaceAll(
      //           '(?i)',
      //           ''
      //       );
      //       final tryRegEx = RegExp(expression, caseSensitive: false);
      //       RegExpMatch? result = tryRegEx.firstMatch(messages[i].body!);
      //
      //       if(result != null) {
      //         print('expression ->> ${expression}');
      //         print('listPattern[j].regex222 ->> ${listPattern[j].regex}');
      //         print('messages[i].body ->> ${messages[i].body}');
      //         print('result == null ->> ${result == null}');
      //         int? accountNumberGroupId = listPattern[j].dataFields?.pan?.groupId;
      //         final account_number = accountNumberGroupId == null ? listPattern[j].dataFields?.pan?.value : result.group(accountNumberGroupId);
      //
      //         int? transactionGroupId;
      //         if(listPattern[j].dataFields?.pos?.groupId != null) {
      //           transactionGroupId = listPattern[j].dataFields?.pos?.groupId;
      //         } else if(listPattern[j].dataFields?.transactionTypeRule?.groupId != null) {
      //           transactionGroupId = listPattern[j].dataFields?.transactionTypeRule?.groupId;
      //         } else if(listPattern[j].dataFields?.note?.groupId != null) {
      //           transactionGroupId = listPattern[j].dataFields?.note?.groupId;
      //         } else {
      //           transactionGroupId = listPattern[j].dataFields?.posTypeRules?.groupId;
      //         }
      //         final transaction_account = transactionGroupId == null ? null : result.group(transactionGroupId);
      //
      //         Duration duration = DateTime.now().difference(messages[i].date!);
      //         listData.add({
      //           'date' : messages[i].date!,
      //           'duration' : duration,
      //           'body' : messages[i].body!,
      //           'group' : DateFormat('MMM yyyy').format(messages[i].date!),
      //           'account_number' : account_number,
      //           'transaction_account' : transaction_account,
      //           'category' : listPattern[j].dataFields?.statementType == 'loan_emi' ? 'Loan EMIs'
      //               : listPattern[j].dataFields?.transactionType == 'debit_atm' ? 'ATM Withdrawal'
      //               : listPattern[j].dataFields?.statementType == 'debit_prepaid' ? 'Prepaid Bill'
      //               : listPattern[j].dataFields?.statementType == 'mobile_bill' ? 'Phone Bill'
      //               : listPattern[j].dataFields?.statementType == 'credit_card_bill' ? 'Credit Card Bill'
      //               : listPattern[j].dataFields?.statementType == 'gas_bill' ? 'Gas Bill'
      //               : listPattern[j].dataFields?.statementType == 'electricity_bill' ? 'Electricity Bill'
      //               : listPattern[j].dataFields?.statementType == 'insurance_premium' ? 'Insurance Bill'
      //               : 'Generic Bill'
      //         });
      //         log('listData ->> $listData');
      //         print(' ');
      //       }
      //     }
      //   }
      // });
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
            || pattern.dataFields?.statementType == 'loan_emi'

            || pattern.dataFields?.transactionType == 'debit_prepaid'

            || pattern.dataFields?.transactionType == 'electricity_bill'
            || pattern.dataFields?.statementType == 'electricity_bill'

            || pattern.dataFields?.transactionType == 'insurance_premium'
            || pattern.dataFields?.statementType == 'insurance_premium'

            || pattern.dataFields?.transactionType == 'gas_bill'
            || pattern.dataFields?.statementType == 'gas_bill'

            || pattern.dataFields?.transactionType == 'credit_card_bill'
            || pattern.dataFields?.statementType == 'credit_card_bill'

            || pattern.dataFields?.transactionType == 'mobile_bill'
            || pattern.dataFields?.statementType == 'mobile_bill'
            || pattern.accountType == 'generic') {
          lstPattern.add(pattern);
          print('pattern@@ -> ${pattern.patternUID}');
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
        getData(listPattern: listPattern, percentage: cashMoneyPercentage, listData: cashMoneyList).then((value) {
          print('cashMoneyList -> ${cashMoneyList}');
        });
      });
    }

    if(billsEmiPercentage.value <= 0.0) {
      getBillsTransactionType().then((listPattern) {
        print('list## -> $listPattern');
        getData(listPattern: listPattern, percentage: billsEmiPercentage, listData: billsEmiList).then((value) {
          print('billsEmiList -> ${billsEmiList}');
        });
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
