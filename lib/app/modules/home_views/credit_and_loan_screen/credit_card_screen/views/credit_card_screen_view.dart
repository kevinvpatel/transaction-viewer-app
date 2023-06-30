import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/credit_and_loan_screen/credit_card_screen/views/credit_card_apply_screen.dart';
import '../controllers/credit_card_screen_controller.dart';


class CreditCardScreenView extends GetView<CreditCardScreenController> {
  const CreditCardScreenView({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    CreditCardScreenController controller = Get.put(CreditCardScreenController());
    double height = 100.h;
    double width = 100.w;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/CreditCardScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Credit Card Apply', isShareButtonEnable: true, onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/CreditCardScreenView', context: context);
          // Get.back();
        }),
        body: Obx(() => ListView.separated(
          padding: EdgeInsets.only(top: 15.sp, left: 15.sp, right: 15.sp),
          itemCount: controller.creditCardData.keys.length,
          itemBuilder: (ctx, index) {
            List list = controller.creditCardData.values.toList();
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 15.sp),
              height: 55.sp,
              width: width,
              decoration: BoxDecoration(
                  boxShadow: ConstantsWidgets.boxShadow,
                  borderRadius: BorderRadius.circular(15.sp),
                  gradient: ConstantsColor.buttonGradient
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(list[index]['image'], height: 27.sp),
                      SizedBox(width: 14.sp),
                      Expanded(
                        child: Text(list[index]['name'],
                          style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.sp),
                  Text(' ${list[index]['data']}',
                    style: TextStyle(color: Colors.white70, fontSize: 14.5.sp, fontWeight: FontWeight.w300),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(flex: 3),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      adService.checkCounterAd(
                          currentScreen: '/CreditCardScreenView',
                          context: context,
                          pageToNavigate: const CreditCardApplyScreenView(),
                          argument: list[index]
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: ConstantsColor.pinkGradient,
                          borderRadius: BorderRadius.circular(40.sp)
                      ),
                      padding: EdgeInsets.all(4.sp),
                      child: Container(
                        width: width * 0.33,
                        height: 26.sp,
                        decoration: BoxDecoration(
                            gradient: ConstantsColor.buttonGradient,
                            borderRadius: BorderRadius.circular(40.sp)
                        ),
                        alignment: Alignment.center,
                        child: Text('Apply Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.sp),),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 15.sp);
          },
        )),
      ),
    );
  }
}
