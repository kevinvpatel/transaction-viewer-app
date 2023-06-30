import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/credit_and_loan_screen/credit_card_screen/controllers/credit_card_screen_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CreditCardApplyScreenView extends GetView<CreditCardScreenController> {
  const CreditCardApplyScreenView({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    CreditCardScreenController controller = Get.put(CreditCardScreenController());
    double height = 100.h;
    double width = 100.w;

    Map<String, dynamic> cardData = Get.arguments;
    log('result -> ${cardData}');

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/CreditCardApplyScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: AppBar(
          title: Text(cardData['name']),
          leading: IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.chevron_left, size: 22.sp)
          ),
          actions: [
            InkWell(
              child: Image.asset(ConstantsImage.share_icon1, width: 20.sp),
            ),
            SizedBox(width: 15.sp)
          ],
          backgroundColor: ConstantsColor.backgroundDarkColor,
          elevation: 0,
        ),
        body: Container(
          height: height,
          width: width,
          child: InAppWebView(
            key: controller.webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse(cardData['link'])),
            initialOptions: controller.options,
            onWebViewCreated: (ctrl) {
              controller.webViewController?.value = ctrl;
              controller.update();
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
            },
            onLoadStop: (controller, url) async {

            },
            onLoadError: (controller, url, code, message) {

            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              // print(consoleMessage);
            },
          ),
        ),
      ),
    );
  }
}