import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_views_calculators_currency_converter_screen_controller.dart';

class HomeViewsCalculatorsCurrencyConverterScreenView
    extends GetView<HomeViewsCalculatorsCurrencyConverterScreenController> {
  const HomeViewsCalculatorsCurrencyConverterScreenView({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeViewsCalculatorsCurrencyConverterScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeViewsCalculatorsCurrencyConverterScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
