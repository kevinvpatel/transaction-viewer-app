import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreditCardScreenController extends GetxController {
  //TODO: Implement HomeViewsCreditAndLoanScreenCreditCardScreenController

  final count = 0.obs;

  RxMap<String, dynamic> creditCardData = <String, dynamic>{}.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    final result = await rootBundle.loadString('assets/credit_card_apply.json');
    creditCardData.value = json.decode(result);

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
