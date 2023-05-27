import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';

class IfscScreenController extends GetxController {
  //TODO: Implement HomeViewsBankingIfscScreenController

  RxString bankName = 'Select Bank'.obs;
  RxString stateName = 'Select State'.obs;
  RxString districtName = 'Select District'.obs;
  RxString branchName = 'Select Branch'.obs;


  RxList searchedList = [].obs;
  RxBool isSearchOn = false.obs;


  List stateList = [];
  List cityList = [];
  List areaList = [];
  Map detailMap = {};


  Map<String, dynamic> bankBundleData = {};


  @override
  Future<void> onInit() async {
    super.onInit();

    String bankBundleString = await rootBundle.loadString('assets/bank_list_icons.json');
    bankBundleData = json.decode(bankBundleString);
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
