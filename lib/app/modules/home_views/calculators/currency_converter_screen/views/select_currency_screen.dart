import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/currency_converter_screen/controllers/currency_converter_screen_controller.dart';
import 'package:transaction_viewer_app/app/modules/home_views/home_screen/controllers/home_screen_controller.dart';

class SelectCurrencyScreen extends GetView<CurrencyConverterScreenController> {
  const SelectCurrencyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CurrencyConverterScreenController controller = Get.put(CurrencyConverterScreenController());
    double height = 100.h;
    double width = 100.w;

    controller.isSearchOn.value = false;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Change City', onTapBack: () {
          adService.checkBackCounterAd();
          Get.back();
        }, isShareButtonEnable: false),
        body: Container(
          padding: EdgeInsets.only(left: 15.sp, right: 15.sp, top: 20.sp),
          child: Column(
            children: [
              searchBar(width: width, fieldName: 'Enter Currency Name', isSearchOn: controller.isSearchOn),
              SizedBox(height: 17.sp),
              Expanded(
                  child: FutureBuilder<RxList<Map<String, dynamic>>>(
                      future: controller.getCurrencyList(),
                      builder: (BuildContext context, AsyncSnapshot<RxList<Map<String, dynamic>>> snapshot) {
                        if(!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        } else {
                          if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active|| snapshot.connectionState == ConnectionState.none) {
                            return Center(
                                child: Text(controller.failedAPIMessage.value,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15.8.sp),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )
                            );
                          } else {
                            return Obx(() {
                              List<Map<String, dynamic>> listCurrency = controller.isSearchOn.value ? controller.searchedCurrencyList : snapshot.data!;
                              return ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: listCurrency.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      adService.checkCounterAd();
                                      if(Get.arguments == 'From') {
                                        controller.txtCurrency1.value = listCurrency[index];
                                      } else {
                                        controller.txtCurrency2.value = listCurrency[index];
                                      }
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 30.sp,
                                      width: width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.sp),
                                          gradient: ConstantsColor.buttonGradient,
                                          boxShadow: ConstantsWidgets.boxShadow
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                                      margin: EdgeInsets.only(right: 3.sp),
                                      alignment: Alignment.centerLeft,
                                      child: Text(listCurrency[index]['name'],
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15.8.sp),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(height: 16.sp),
                              );
                            });
                          }
                        }
                      }
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar({
    required double width,
    required String fieldName,
    required RxBool isSearchOn,
  }) {
    return Container(
      height: 29.sp,
      width: width * 0.95,
      decoration: BoxDecoration(
          gradient: ConstantsColor.buttonGradient,
          borderRadius: BorderRadius.circular(20.sp),
          boxShadow: ConstantsWidgets.boxShadow
      ),
      margin: EdgeInsets.symmetric(horizontal: 1.2.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 15.sp),
          Icon(CupertinoIcons.search, color: Colors.white, size: 19.sp),
          SizedBox(width: 15.sp),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                hintText: fieldName,
                hintStyle: TextStyle(fontSize: 15.5.sp, color: Colors.white, fontWeight: FontWeight.w300),
                border: InputBorder.none,
              ),
              onChanged: (str) {
                if(str.length > 0) {
                  isSearchOn.value = true;
                } else {
                  isSearchOn.value = false;
                }

                controller.searchedCurrencyList.value = controller.currencyList.value.where((element) {
                  print('str => $str');
                  print('element => ${element['name']}');
                  return element['name'].toString().toLowerCase().contains(str);
                }).toList();
                print('controller.searchedCurrencyList.value => ${controller.searchedCurrencyList.value}');
                print(' ');
                //
                // controller.update();
              },
            ),
          ),
        ],
      ),
    );
  }

}