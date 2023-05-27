import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:transaction_viewer_app/app/data/Reg_Model.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:transaction_viewer_app/app/data/services.dart';

class BankStatementScreenController extends GetxController {
  //TODO: Implement BankStatementScreenController

  RxDouble percentage = 0.0.obs;
  RxInt percentageCounter = 0.obs;

  RxString totalBalance = '0.0'.obs;

  RxList<String?> messageTotalBalanceList = <String?>[].obs;
  RxList<String?> bankList = <String?>[].obs;
  RxList<String?> regExList = <String?>[].obs;
  final SmsQuery query = SmsQuery();

  Future loadBankCategory() async {
    messageList.clear();
    // await Permission.sms.request();
    String jsonData = await rootBundle.loadString('assets/reg.json');
    Map<String, dynamic> result = json.decode(jsonData);
    Reg regData = Reg.fromJson(result);
    percentageCounter = 0.obs;

    await SMSServices.getSmsData().then((messages) async {
      // regData.rules?.forEach((rule) {
      //   regExList.addAll(rule.senders!);
      // });
      // ///Remove first part before dash(-)
      // bankList.value = messages.map((e) => e.address?.split('-').last).toSet().toList();
      // ///Sorting same values from 2 lists
      // bankList.value = bankList.toSet().intersection(regExList.toSet()).toList();

      List<SmsMessage> bankData = [];

      for(int i = 0; i < messages.length; i++) {

        for(int j = 0; j < regData.rules!.length; j++) {

          if(j == 0) {
            await Future.delayed(const Duration(milliseconds: 100));
            percentageCounter.value++;
            percentage.value = (percentageCounter.value) / messages.length * 100;
          }
          ///Check all sms available in RegEx json
          if(regData.rules![j].senders!.contains(messages[i].address?.split('-').last)) {

            ///RegEx Transaction message
            regData.rules![j].patterns!.forEach((regex) {
              final tempEx = regex.regex!.replaceAll(
                  '(?i)',
                  ''
              );
              final tryRegEx = RegExp(tempEx, caseSensitive: false);
              RegExpMatch? result = tryRegEx.firstMatch(messages[i].body!);

              if(result != null) {
                int? accountBalanceGroupId = regex.dataFields?.accountBalance?.groupId;
                final account_balance = accountBalanceGroupId == null ? null : result.group(accountBalanceGroupId);

                int? accountNumberGroupId = regex.dataFields?.pan?.groupId;
                final account_number = accountNumberGroupId == null ? regex.dataFields?.pan?.value : result.group(accountNumberGroupId);

                int? amountGroupId = regex.dataFields?.amount?.groupId;
                final transaction_amount = amountGroupId == null ? null : result.group(amountGroupId);


                ///account_balance != null means sms have proper transaction messages
                // if(account_balance != null || transaction_amount != null) {
                if(account_balance != null) {
                  messageList.add(messages[i]);
                  if(!bankList.value.contains(messages[i].address?.split('-').last)) {
                    bankList.value.add(messages[i].address?.split('-').last);
                    Map<String, dynamic> tempBankMap = {};
                    print('result -> ${result}');
                    print('account_balance -> ${account_balance}');
                    bankData.add(messages[i]);
                    tempBankMap['bank_address'] = messages[i].address?.split('-').last;
                    tempBankMap['bank_name'] = regData.rules![j].fullName;
                    tempBankMap['account_number'] = account_number;
                    tempBankMap['total_balance'] = account_balance;
                    mapMessageList.add(tempBankMap);
                  }
                }

                // if(account_balance != null) {
                //   bankList.value.add(messages[i].address?.split('-').last);
                //   messageList.add(messages[i]);
                  // messageTotalBalanceList.add(account_balance);
                // }
                // totalBalance.value = messageTotalBalanceList.first ?? '0.0';
              }
            });
          }
        }
      }
    });
  }

  Map<String, dynamic> bankBundleData = {};

  @override
  Future<void> onInit() async {
    super.onInit();
    if(percentage.value <= 0.0) {
    print('loadBankCategory initiate');
    String bankBundleString = await rootBundle.loadString('assets/bank_list_icons.json');
    bankBundleData = json.decode(bankBundleString);

    loadBankCategory().whenComplete(() {
        // bankList.value = bankList.value.toSet().toList();
        // bankList.forEach((bankName) {
        //   List<SmsMessage> messages = [];
        //   messageList.forEach((message) {
        //     if(bankName == message?.address?.split('-').last) {
        //       messages.add(message!);
        //       mapMessageList.value[bankName!] = messages;
        //     }
        //   });
        // });
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
