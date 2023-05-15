import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transaction_viewer_app/app/data/Reg_Model.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:transaction_viewer_app/app/data/services.dart';
import 'package:transaction_viewer_app/app/modules/home/controllers/home_controller.dart';

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}

class BankCategoryScreenController extends GetxController {
  //TODO: Implement BankCategoryScreenController
  RxDouble percentage1 = 0.0.obs;
  RxInt percentage = 0.obs;


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
    percentage = 0.obs;

    await SMSServices.getSmsData().then((messages) async {
      // regData.rules?.forEach((rule) {
      //   regExList.addAll(rule.senders!);
      // });
      // ///Remove first part before dash(-)
      // bankList.value = messages.map((e) => e.address?.split('-').last).toSet().toList();
      // ///Sorting same values from 2 lists
      // bankList.value = bankList.toSet().intersection(regExList.toSet()).toList();


      for(int i = 0; i < messages.length; i++) {

        for(int j = 0; j < regData.rules!.length; j++) {

            if(j == 0) {
              await Future.delayed(const Duration(milliseconds: 100));
              percentage.value++;
              percentage1.value = (percentage.value) / messages.length * 100;
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

                if(account_balance != null) {
                  bankList.value.add(messages[i].address?.split('-').last);
                  messageList.add(messages[i]);
                  messageTotalBalanceList.add(account_balance);
                }
                totalBalance.value = messageTotalBalanceList.first ?? '0.0';
              }
            });
          }
        }
      }
    });
  }



  @override
  void onInit() {
    super.onInit();
    loadBankCategory().whenComplete(() {
      bankList.value = bankList.value.toSet().toList();
    });
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
