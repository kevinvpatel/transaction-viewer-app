import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/fuel_price_model.dart';

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

  List<Map<String, dynamic>> listCreditAndLoan = [
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


  String stateName = 'Gujarat';
  String cityName = 'Surat';

  Rx<String> failedAPIMessage = 'Price Not Available For Selected City \nPlease Select Another'.obs;

  Future<Price?> getFuelPriceData({String? state, String? city}) async {
    Price? price;
    print('state -> ${state}');
    print('city -> ${city}');
    http.Response response = await http.get(
        Uri.parse('https://daily-petrol-diesel-lpg-cng-fuel-prices-in-india.p.rapidapi.com/v1/fuel-prices/today/india/${state}/${city}'),
        headers: {'X-RapidAPI-Key' : '7d868c649amshe5043f350a71f8bp16a4ffjsn89f8096a1aba', 'X-RapidAPI-Host' : 'daily-petrol-diesel-lpg-cng-fuel-prices-in-india.p.rapidapi.com'}
    );
    final result = json.decode(response.body);

    try {
      if(response.statusCode == 200) {
        price = Price.fromJson(result);
      } else {
        failedAPIMessage.value = result['message'];
        print('Response Status Code Fuel Price -> ${result}');
      }

    } catch(e) {
      print('Fuel Price Api Fetch Err -> $e');
    }
    // update();

    return price;
  }


  Map<String, dynamic> allCitiesMap = {};

  @override
  Future<void> onInit() async {
    super.onInit();
    String allCities = await rootBundle.loadString('assets/fuel_price_city/allcitystate.json');
    allCitiesMap = json.decode(allCities);
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
