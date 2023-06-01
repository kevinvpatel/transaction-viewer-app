import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrencyConverterScreenController extends GetxController {
  //TODO: Implement HomeViewsCalculatorsCurrencyConverterScreenController

  Rx<TextEditingController> enteredAmount = TextEditingController().obs;
  RxString convertedAmount = '00'.obs;

  RxMap<String, dynamic> txtCurrency1 = <String, dynamic>{}.obs;
  RxMap<String, dynamic> txtCurrency2 = <String, dynamic>{}.obs;


  ///Currency List
  RxString failedAPIMessage = ''.obs;
  RxBool isSearchOn = false.obs;

  RxList<Map<String, dynamic>> searchedCurrencyList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> currencyList = <Map<String, dynamic>>[].obs;

  Future<RxList<Map<String, dynamic>>> getCurrencyList() async {
    currencyList = <Map<String, dynamic>>[].obs;

    http.Response response = await http.get(
        Uri.parse('https://currency-converter18.p.rapidapi.com/api/v1/supportedCurrencies'),
        headers: {'X-RapidAPI-Key' : '7d868c649amshe5043f350a71f8bp16a4ffjsn89f8096a1aba', 'X-RapidAPI-Host' : 'currency-converter18.p.rapidapi.com'}
    );
    final result = json.decode(response.body);

    try {
      if(response.statusCode == 200) {
        ///convert List<dynamic> to List<Map<String, dynamic>>
        currencyList.value = (result as List).map((e) => e as Map<String, dynamic>).toList();
      } else {
        failedAPIMessage.value = result['message'];
        print('Response Status Code Currency -> ${result}');
      }

    } catch(e) {
      print('Currency Api Fetch Err -> $e');
    }
    return currencyList;
  }



  convertCurrency({required String currency1, required String currency2, required String amount}) async {
    convertedAmount.value = 'Please Wait...';
    http.Response response = await http.get(
        Uri.parse('https://currency-converter18.p.rapidapi.com/api/v1/convert?from=$currency1&to=$currency2&amount=$amount'),
        headers: {'X-RapidAPI-Key' : '7d868c649amshe5043f350a71f8bp16a4ffjsn89f8096a1aba', 'X-RapidAPI-Host' : 'currency-converter18.p.rapidapi.com'}
    );
    final result = json.decode(response.body);

    try {
      if(response.statusCode == 200) {
        print('Currency result -> ${result['result']['convertedAmount']}');
        convertedAmount.value = result['result']['convertedAmount'].toString();
      } else {
        failedAPIMessage.value = result['message'];
        print('Response Status Code Currency Change-> ${result}');
      }

    } catch(e) {
      print('Currency Change Api Fetch Err -> $e');
    }
  }


  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getCurrencyList();
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
