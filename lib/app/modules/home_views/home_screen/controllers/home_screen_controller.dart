import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';

class HomeScreenController extends GetxController {
  //TODO: Implement HomeScreenController

  List<Map<String, dynamic>> listBanking = [
    {
      'title' : 'Balance',
      'image' : ConstantsImage.balance_icon
    },
    {
      'title' : 'IFSC',
      'image' : ConstantsImage.IFSC_icon
    },
    {
      'title' : 'Holiday',
      'image' : ConstantsImage.holiday_icon
    },
    {
      'title' : 'USSD',
      'image' : ConstantsImage.USSD_icon
    },
    {
      'title' : 'ATM',
      'image' : ConstantsImage.atm_icon
    },
  ];

  List<Map<String, dynamic>> listCalculators = [
    {
      'title' : 'Currency Convert',
      'image' : ConstantsImage.balance_icon
    },
    {
      'title' : 'Home Loan',
      'image' : ConstantsImage.IFSC_icon
    },
    {
      'title' : 'Business Loan',
      'image' : ConstantsImage.holiday_icon
    },
    {
      'title' : 'RD Calculator',
      'image' : ConstantsImage.USSD_icon
    },
    {
      'title' : 'FD Calculator',
      'image' : ConstantsImage.atm_icon
    },
  ];

  List<Map<String, dynamic>> listLoan = [
    {
      'title' : 'Credit',
      'image' : ConstantsImage.credit_card_icon
    },
    {
      'title' : 'Car',
      'image' : ConstantsImage.car_icon
    },
    {
      'title' : 'Home',
      'image' : ConstantsImage.Home_icon
    },
    {
      'title' : 'Business',
      'image' : ConstantsImage.business_icon
    },
    {
      'title' : 'Micro',
      'image' : ConstantsImage.micro_icon
    },
  ];

  List<Map<String, dynamic>> listSchemes = [
    {
      'title' : 'PF Employee',
      'image' : ConstantsImage.pf_employee_icon
    },
    {
      'title' : 'PS National',
      'image' : ConstantsImage.ps_national_icon
    },
    {
      'title' : 'SC National',
      'image' : ConstantsImage.sc_national_icon
    },
    {
      'title' : 'PM Jan Dhan',
      'image' : ConstantsImage.pm_jan_dhan_icon
    },
    {
      'title' : 'PM Vaya',
      'image' : ConstantsImage.pm_vaya_icon
    },
    {
      'title' : 'SS Post',
      'image' : ConstantsImage.ss_post_icon
    },
    {
      'title' : 'PF Public',
      'image' : ConstantsImage.pf_public_icon
    },
    {
      'title' : 'CS Senior',
      'image' : ConstantsImage.cs_senior_icon
    },
  ];

  final PageController pageController = PageController();
  RxInt currentPage = 0.obs;

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
