import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BalanceScreenController extends GetxController {
  //TODO: Implement HomeViewsBankingBalanceScreenController

  var bankData = [];


  getBankData() async {
    String bankBundleString = await rootBundle.loadString('assets/bank_numbers.json');
    bankData = json.decode(bankBundleString);
    // print('bankData -> $bankData');
    update();
  }


  @override
  Future<void> onInit() async {
    super.onInit();
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
