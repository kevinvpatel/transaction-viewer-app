import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import '../controllers/car_loan_screen_controller.dart';

class CarLoanScreenView extends GetView<CarLoanScreenController> {
  const CarLoanScreenView({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    CarLoanScreenController controller = Get.put(CarLoanScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/CarLoanScreenView');
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        // appBar: ConstantsWidgets.appBar(title: 'controller.listCarloan[0].text', isShareButtonEnable: false, onTapBack: () => Get.back()),
        appBar: AppBar(
          title: Text(Get.arguments['title']),
          leading: IconButton(
              onPressed: () {
                adService.checkBackCounterAd(currentScreen: '/CarLoanScreenView');
                Get.back();
              },
              icon: const Icon(CupertinoIcons.arrow_left)
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
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.sp),
                child: Text('Loan Details', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),),
              ),
              Container(
                height: height * 0.8,
                padding: EdgeInsets.all(17.sp),
                margin: EdgeInsets.all(17.sp),
                decoration: BoxDecoration(
                  gradient: ConstantsColor.buttonGradient,
                  borderRadius: BorderRadius.circular(15.sp),
                  boxShadow: ConstantsWidgets.boxShadow
                ),
                child: Obx(() => SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Html(
                    style: {
                      "h3": Style(color: Colors.white, fontWeight: FontWeight.w500, fontSize: FontSize(19.sp)),
                      "h2": Style(color: Colors.white, fontWeight: FontWeight.w500, fontSize: FontSize(19.sp)),
                      "p": Style(color: Colors.white, fontSize: FontSize(15.5.sp)),
                      "ul": Style(color: Colors.white, fontSize: FontSize(15.5.sp)),
                      "li": Style(color: Colors.white, fontSize: FontSize(15.5.sp))
                    },
                    data: controller.htmlCode.value,
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
