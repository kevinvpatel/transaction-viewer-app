import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/modules/welcome_screen/controllers/welcome_screen_controller.dart';

class PrivacyPolicyScreenView extends GetView<WelcomeScreenController> {
  const PrivacyPolicyScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    WelcomeScreenController controller = Get.put(WelcomeScreenController());
    double height = 100.h;
    double width = 100.w;

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        body: Container(
          height: height,
          width: width,
          child: InAppWebView(
            key: controller.webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse('https://www.google.com/')),
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