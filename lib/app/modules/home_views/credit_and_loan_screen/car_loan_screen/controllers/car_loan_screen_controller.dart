import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class CarLoanScreenController
    extends GetxController {
  //TODO: Implement HomeViewsCreditAndLoanScreenCarLoanScreenController


  RxString htmlCode = ''.obs;

  html({required String filePath}) async {
    final result = await rootBundle.loadString(filePath);
    var document = parse(result);
    htmlCode.value = document.body!.innerHtml;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    log('Get.arguments@@ -> ${Get.arguments['path']}');
    html(filePath: Get.arguments['path']);
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
