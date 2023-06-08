import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';

import '../controllers/atm_map_screen_view_controller.dart';

class AtmMapScreenViewView extends GetView<AtmMapScreenViewController> {
  const AtmMapScreenViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AtmMapScreenViewController controller = Get.put(AtmMapScreenViewController());
    double height = 100.h;
    double width = 100.w;

    String query = Uri.encodeComponent('atm near me');
    print('query -> $query');
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    return Scaffold(
      // backgroundColor: ConstantsColor.backgroundDarkColor,
      // appBar: ConstantsWidgets.appBar(title: 'ATM LIST'),
      body: Container(
        height: height,
        width: width,
        child: InAppWebView(
          key: controller.webViewKey,
          initialUrlRequest: URLRequest(url: Uri.parse(googleUrl)),
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
    );
  }
}
