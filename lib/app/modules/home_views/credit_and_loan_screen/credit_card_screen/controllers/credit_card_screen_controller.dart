import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class CreditCardScreenController extends GetxController {
  //TODO: Implement HomeViewsCreditAndLoanScreenCreditCardScreenController


  final GlobalKey webViewKey = GlobalKey();
  Rx<InAppWebViewController>? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      incognito: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      userAgent: 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/60.0',
      javaScriptEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );


  RxMap<String, dynamic> creditCardData = <String, dynamic>{}.obs;

  RxBool isLoading = true.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    final result = await rootBundle.loadString('assets/credit_card_apply.json');
    creditCardData.value = json.decode(result);
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
