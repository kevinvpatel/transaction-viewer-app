import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transaction_viewer_app/app/modules/bank_statement_views/bank_statement_screen/views/bank_statement_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/home_views/home_screen/views/home_screen_view.dart';

class BottomNavigationScreenController extends GetxController {
  //TODO: Implement BottomNavigationScreenController

  late PageController pageController;
  RxInt tabIndex = 1.obs;

  List<Widget> lstScreens = [
    BankStatementScreenView(),
    HomeScreenView(),
    HomeScreenView(),
  ];


  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: tabIndex.value);
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
