import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/ussd_bank_list_screen_view/views/ussd_bank_detail_screen_view.dart';

import '../controllers/ussd_bank_list_screen_view_controller.dart';

class UssdBankListScreenViewView extends GetView<UssdBankListScreenViewController> {
  const UssdBankListScreenViewView({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    UssdBankListScreenViewController controller = Get.put(UssdBankListScreenViewController());
    double height = 100.h;
    double width = 100.w;


    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: 'All Bank USSD Code'),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(top: 8.sp),
        child: Obx(() => ListView.separated(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 12.sp, right: 12.sp, top: 10.sp, bottom: 17.sp),
          itemCount: controller.listData.length,
          itemBuilder: (context, index) {
            final bankData = controller.listData[index];
            // print('controller.listData -> ${bankData}');
            print(' ');
            return InkWell(
              onTap: () {
                Get.to(const UssdBankDetailScreenViewView(), arguments: bankData);
              },
              child: Container(
                height: 33.sp,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 12.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.sp),
                    gradient: ConstantsColor.buttonGradient,
                    boxShadow: ConstantsWidgets.boxShadow
                ),
                alignment: Alignment.centerLeft,
                child: Text(bankData['vName'],
                  style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 15.sp),
        )),
      ),
    );
  }
}
