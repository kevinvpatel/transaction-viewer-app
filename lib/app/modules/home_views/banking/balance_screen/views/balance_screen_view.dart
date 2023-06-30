import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/balance_screen/views/balance_detail_screen_view.dart';
import '../controllers/balance_screen_controller.dart';

class BalanceScreenView extends GetView<BalanceScreenController> {
  const BalanceScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BalanceScreenController controller = Get.put(BalanceScreenController());
    double height = 100.h;
    double width = 100.w;

    controller.getBankData();
    AdService adService = AdService();

    RxList searchedData = [].obs;
    RxBool isSearchOn = false.obs;

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/BalanceDetailScreenView', context: context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Select Bank', onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/BalanceDetailScreenView', context: context);
          // Get.back();
        }),
        body: Container(
          margin: EdgeInsets.only(top: 15.sp),
          child: Column(
            children: [
              searchBar(
                width: width,
                fieldName: 'Search Bank',
                isSearchOn: isSearchOn,
                searchedData: searchedData
              ),
              SizedBox(height: 15.sp),
              GetBuilder(
                init: BalanceScreenController(),
                builder: (controller) {
                  return Expanded(
                    child: Obx(() => ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(left: 17.sp, right: 17.sp, bottom: 17.sp, top: 10.sp),
                      itemCount: isSearchOn.value == true ? searchedData.length : controller.bankData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            adService.checkCounterAd(
                              currentScreen: '/BalanceDetailScreenView',
                              context: context,
                              pageToNavigate: const BalanceDetailScreenView(),
                              argument: isSearchOn.value == true ? searchedData[index] : controller.bankData[index]
                            );
                          },
                          child: bankItems(
                              width: width,
                              title: isSearchOn.value == true ? searchedData[index]['bank_name'] : controller.bankData[index]['bank_name'],
                              image: isSearchOn.value == true ? searchedData[index]['icon'] : controller.bankData[index]['icon']
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 15.sp),
                    )),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bankItems({required double width, required String title, String? image}) {
    return Container(
      height: 33.sp,
      width: width,
      decoration: BoxDecoration(
        gradient: ConstantsColor.buttonGradient,
        borderRadius: BorderRadius.circular(14.sp),
        boxShadow: ConstantsWidgets.boxShadow
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 13.sp),
      child: Row(
        children: [
          Container(
            width: 28.sp,
            child: image != ""
                ? ClipOval(
                    child: Image.asset('assets/bank icons/$image.png')
                ) : Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Image.asset(ConstantsImage.bank_holiday_icon, width: 25.sp),
                ),
          ),
          SizedBox(width: 15.sp),
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),)
        ],
      ),
    );
  }

  Widget searchBar({
    required double width,
    required String fieldName,
    required RxBool isSearchOn,
    required RxList searchedData
  }) {
    return Container(
      height: 28.5.sp,
      width: width * 0.95,
      decoration: BoxDecoration(
          gradient: ConstantsColor.buttonGradient,
          borderRadius: BorderRadius.circular(20.sp),
          boxShadow: ConstantsWidgets.boxShadow
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 15.sp),
          const Icon(CupertinoIcons.search, color: Colors.white),
          SizedBox(width: 15.sp),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              style: TextStyle(fontSize: 16.5.sp, color: Colors.white, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  hintText: fieldName,
                  hintStyle: TextStyle(fontSize: 15.5.sp, color: Colors.white, fontWeight: FontWeight.w400),
                  border: InputBorder.none
              ),
              onChanged: (str) {
                if(str.length > 0) {
                  isSearchOn.value = true;
                } else {
                  isSearchOn.value = false;
                }
                searchedData.clear();
                searchedData.value = controller.bankData.where((element) {
                  return element['bank_name'].toString().toLowerCase().contains(str.toLowerCase());
                }).toList();

              },
            ),
          ),
        ],
      ),
    );
  }

}
