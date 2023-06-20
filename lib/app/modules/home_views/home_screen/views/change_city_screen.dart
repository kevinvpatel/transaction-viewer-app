import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/adServices.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/bottom_navigation_screen/views/bottom_navigation_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/home_views/home_screen/controllers/home_screen_controller.dart';
import 'package:transaction_viewer_app/app/modules/home_views/home_screen/views/home_screen_view.dart';

class ChangeCityScreen extends GetView<HomeScreenController> {
  const ChangeCityScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());
    double height = 100.h;
    double width = 100.w;

    Map<String, dynamic> mapCities = Get.arguments;

    RxMap<String, dynamic> searchedMap = <String, dynamic>{}.obs;
    RxBool isSearchOn = false.obs;

    AdService adService = AdService();

    return WillPopScope(
      onWillPop: () async {
        adService.checkBackCounterAd(currentScreen: '/ChangeCityScreen');
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ConstantsColor.backgroundDarkColor,
        appBar: ConstantsWidgets.appBar(title: 'Change City', onTapBack: () {
          adService.checkBackCounterAd(currentScreen: '/ChangeCityScreen');
          Get.back();
        }, isShareButtonEnable: false),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
          child: Column(
            children: [
              searchBar(width: width, fieldName: 'Search City....', isSearchOn: isSearchOn, cityData: mapCities, searchedMap: searchedMap),
              Expanded(
                child: GetBuilder(
                    init: HomeScreenController(),
                    builder: (controller) {
                      return ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(height: 16.sp),
                          padding: EdgeInsets.symmetric(vertical: 20.sp),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: isSearchOn.value == true ? searchedMap.keys.length : mapCities.keys.length,
                          itemBuilder: (context, stateIndex) {
                            List<String> listStates = isSearchOn.value == true
                                ? searchedMap.keys.toList()
                                : mapCities.keys.toList();
                            List listCities = isSearchOn.value == true
                                ? searchedMap.values.toList()[stateIndex]
                                : mapCities.values.toList()[stateIndex];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listStates[stateIndex],
                                  style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w500, fontSize: 17.sp),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 12.sp),
                                ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: listCities.length,
                                  itemBuilder: (context, cityIndex) {
                                    return InkWell(
                                      onTap: () {
                                        adService.checkCounterAd(currentScreen: '/ChangeCityScreen');
                                        controller.stateName = listStates[stateIndex];
                                        controller.cityName = listCities[cityIndex]['cityName'];
                                        log('controller.stateName -> ${controller.stateName}');
                                        log('controller.cityName -> ${controller.cityName}');
                                        Get.back();
                                        Future.delayed(Duration(milliseconds: 1200), () {
                                          controller.update();
                                        });
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
                                        child: Text(listCities[cityIndex]['cityName'],
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 15.8.sp),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => SizedBox(height: 16.sp),
                                )
                              ],
                            );
                          }
                      );
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
    required RxMap<String, dynamic> searchedMap,
    required Map<String, dynamic> cityData
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

                searchedMap.clear();
                cityData.forEach((key, value) {
                  List lst = value.toList();
                  lst.forEach((element) {
                    if(element['cityName'].toString().toLowerCase().contains(str.toLowerCase())) {
                      searchedMap.addAll({key: [element]});
                    } else if(key.toLowerCase().contains(str.toLowerCase())) {
                      searchedMap.addAll({key: value});
                    }
                  });
                });
                controller.update();
              },
            ),
          ),
        ],
      ),
    );
  }
  
}