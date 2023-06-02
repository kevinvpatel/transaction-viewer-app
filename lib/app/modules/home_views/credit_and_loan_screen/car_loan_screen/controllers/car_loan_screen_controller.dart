import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class CarLoanScreenController
    extends GetxController {
  //TODO: Implement HomeViewsCreditAndLoanScreenCarLoanScreenController

  List<String> listLoanDetails = [
    'assets/credit & loan files/carloan.html',
    'assets/credit & loan files/homeloan.html',
    'assets/credit & loan files/bussiness.html',
    'assets/credit & loan files/personal.html',
  ];

  RxList<Element> listHeadings = <Element>[].obs;
  RxList<Element> listBody = <Element>[].obs;
  RxString str = ''.obs;
  Element? element;

  html({required String filePath}) async {
    final result = await rootBundle.loadString(filePath);
    // log('result -> ${result}');
    var document = parse(result);
    // str.value = parse(document.body!.text).documentElement!.text;
    // log('html -> ${document.body?.getElementsByTagName('h3')}');
    document.body?.getElementsByTagName('h3').forEach((element) {
      log('headings  -> ${element.text.trim()}');
      listHeadings.add(element);
    });
    document.body?.getElementsByTagName('p').forEach((element) {
      log('bodies -> ${element.text.trim()}');
      listBody.add(element);
    });
    update();
  }

  @override
  void onInit() {
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
