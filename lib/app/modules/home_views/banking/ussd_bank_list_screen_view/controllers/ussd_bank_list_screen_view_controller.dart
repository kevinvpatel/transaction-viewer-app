import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transaction_viewer_app/app/data/DB.dart';

class UssdBankListScreenViewController extends GetxController {
  //TODO: Implement HomeViewsBankingUssdBankListScreenViewController

  final count = 0.obs;

  DBHelper dbHelper = DBHelper();
  RxList listData = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    listData.value = await dbHelper.initDb();
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
