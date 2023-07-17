import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:transaction_viewer_app/app/data/Reg_Model.dart';
import 'package:transaction_viewer_app/app/data/services.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/controllers/bank_detail_screen_controller.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_detail_screen/views/bank_detail_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/bottom_navigation_screen/controllers/bottom_navigation_screen_controller.dart';

class BankStatementScreenController extends GetxController {
  //TODO: Implement BankStatementScreenController


  RxString totalBalance = '0.0'.obs;

  RxList<String?> messageTotalBalanceList = <String?>[].obs;
  RxList<String?> regExList = <String?>[].obs;
  final SmsQuery query = SmsQuery();


  RxInt tabIndex = 0.obs;
  ScrollController scrollController = ScrollController();


  Map<String, dynamic> bankBundleData = {};

  RxList<Map<String, dynamic>> listBanks = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listDebitCards = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listWallets = <Map<String, dynamic>>[].obs;

  BottomNavigationScreenController bottomNavigationScreenController = Get.put(BottomNavigationScreenController());

  @override
  Future<void> onInit() async {
    super.onInit();
    print('loadBankCategory initiate');
    String bankBundleString = await rootBundle.loadString('assets/bank_list_icons.json');
    bankBundleData = json.decode(bankBundleString);

    ///Banks List
    listBanks.value = bottomNavigationScreenController.allMessageDetails.groupBy('account_number');
    listBanks.removeWhere((element) {
      List<Map<dynamic, dynamic>> list = List<Map<dynamic, dynamic>>.from(element.values.first.toList());
      return list.any((e) => e['isDebitCard']) == true;
    });
    listBanks.removeWhere((element) {
      List<Map<dynamic, dynamic>> list = List<Map<dynamic, dynamic>>.from(element.values.first.toList());
      return list.any((e) => e['account_number'] == 'XXXX' || e['account_number'] == 'Unknown');
    });
    print('listBanks11 -> $listBanks');

    ///Debit Cards List
    listDebitCards.value = bottomNavigationScreenController.allMessageDetails.groupBy('account_number');
    listDebitCards.removeWhere((element) {
      List<Map<dynamic, dynamic>> list = List<Map<dynamic, dynamic>>.from(element.values.first.toList());
      return list.any((e) => e['isDebitCard']) == false;
    });

    ///Wallets List
    listWallets.value = bottomNavigationScreenController.allMessageDetails.groupBy('account_number');
    listWallets.removeWhere((element) {
      List<Map<dynamic, dynamic>> list = List<Map<dynamic, dynamic>>.from(element.values.first.toList());
      return list.any((e) => e['account_number'] != 'XXXX' && e['account_number'] != 'Unknown');
    });
    print('listBanks -> $listWallets');
    update();
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
