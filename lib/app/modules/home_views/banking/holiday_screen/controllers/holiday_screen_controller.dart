import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HolidayScreenController extends GetxController {
  //TODO: Implement HomeViewsBankingHolidayScreenController

  RxList listHolidays = [].obs;


  Future getBankHolidays() async {
    try {
      String temp = await rootBundle.loadString('assets/bankholiday.json');
      Map<String, dynamic> tempMap = json.decode(temp);
      listHolidays.addAll(tempMap['BankHoliDay']);
    } catch (err) {
      log('err -> ${err}');
    }
  }

  @override
  void onInit() {
    super.onInit();
    log('temp @@@@@@@@@@@@@@@@@@@');
    getBankHolidays();
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
