import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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


    controller.html(filePath: 'assets/credit & loan files/${Get.arguments}.html');

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: 'controller.listCarloan[0].text', isShareButtonEnable: false, onTapBack: () => Get.back()),
      body: Container(
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
              child: GetBuilder(
                  init: CarLoanScreenController(),
                  builder: (controller) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: controller.listHeadings.length,
                      itemBuilder: (context, index) {
                        log('controller.listHeadings -> ${controller.listHeadings.length}');
                        // return index % 2 != 0
                        //     ? Text('${controller.listBody[index].text.trim()}\n\n', style: TextStyle(color: Colors.white, fontSize: 15.5.sp),)
                        //     : SizedBox.shrink();
                        return Text('${controller.listBody[index].text.trim()}\n\n', style: TextStyle(color: Colors.white, fontSize: 15.5.sp),);
                      },
                      separatorBuilder: (context, index) {
                        ///Headings
                        // return index % 2 == 0 && index != 0
                        //     ? Text(controller.listHeadings[index].text.trim(),
                        //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 19.sp),)
                        //     : SizedBox.shrink();
                        return Text(controller.listHeadings[index].text.trim(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 19.sp),);
                      },
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
