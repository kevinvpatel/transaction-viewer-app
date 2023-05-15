import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/modules/home/controllers/home_controller.dart';
import 'package:transaction_viewer_app/app/modules/home/views/home_view.dart';

import '../controllers/bank_category_screen_controller.dart';

class BankCategoryScreenView extends GetView<BankCategoryScreenController> {
  const BankCategoryScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BankCategoryScreenController controller = Get.put(BankCategoryScreenController());
    double height = 100.h;
    double width = 100.w;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank List'),
        centerTitle: true,
      ),
      body: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          color: Colors.orange.shade200,
          child: Obx(() {
            if(controller.percentage1.value.toStringAsFixed(0) == '100') {
               return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 17.sp),
                  itemCount: controller.bankList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(HomeView(), arguments: controller.bankList[index]!);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15.sp),
                        height: 45.sp,
                        width: width,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(controller.bankList[index]!),
                      ),
                    );
                  }
              );
            } else {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Please Wait',
                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500, fontSize: 18.sp)),
                      SizedBox(height: 10.sp),
                      Text(controller.percentage1.value.toStringAsFixed(2),
                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500, fontSize: 18.sp)),
                    ],
                  ),
                  SizedBox(
                    height: 50.sp,
                    width: 50.sp,
                    child: CircularProgressIndicator(
                        value: controller.percentage1.value / 100,
                        strokeWidth: 3,
                        backgroundColor: Colors.white38,
                    )
                  )
                ],
              );
            }
          }),
          // child: StreamBuilder<List<String?>>(
          //     stream: controller.loadBankCategory(),
          //     builder: (BuildContext context, AsyncSnapshot<List<String?>> snapshot) {
          //       print('controller.percentage.value 111-> ${controller.percentage1.value}');
          //       print('controller.isLoadingComplete.value-> ${controller.isLoadingComplete.value}');
          //       print('messageList.length@@@ -> ${controller.messageList.length} ');
          //
          //       if(controller.isLoadingComplete.value) {
          //         print('controller.percentage.value 222-> ${controller.percentage1.value}');
          //         return Obx(() => ListView.builder(
          //             padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 17.sp),
          //             itemCount: controller.bankList.length,
          //             itemBuilder: (context, index) {
          //               return InkWell(
          //                 onTap: () {
          //                   Get.to(HomeView(), arguments: controller.bankList[index]!);
          //                 },
          //                 child: Container(
          //                   margin: EdgeInsets.only(bottom: 15.sp),
          //                   height: 45.sp,
          //                   width: width,
          //                   color: Colors.white,
          //                   alignment: Alignment.center,
          //                   child: Text(controller.bankList[index]!),
          //                 ),
          //               );
          //             }
          //         ));
          //       } else {
          //         print('controller.percentage.value 333-> ${controller.percentage1.value} ');
          //         return Obx(() => Text('Please Wait : ${controller.j.value}',
          //             style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500, fontSize: 18.sp)));
          //       }
          //     }
          // )
      )
    );
  }
}
