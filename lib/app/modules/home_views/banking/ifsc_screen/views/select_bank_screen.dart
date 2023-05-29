

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/ifsc_screen/controllers/ifsc_screen_controller.dart';

class SelectBankScreenView extends GetView<IfscScreenController> {
  const SelectBankScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    IfscScreenController controller = Get.put(IfscScreenController());
    double height = 100.h;
    double width = 100.w;

    controller.searchedList.value.clear();

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: Get.arguments, onTapBack: () => Get.back()),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 15.sp),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.sp),
              searchBar(
                width: width,
                fieldName: 'Search ${Get.arguments.toString().split(' ').last}'
              ),
              SizedBox(height: 15.sp),
              Expanded(
                  child: Container(
                    child: bankList(controller: controller),
                  )
              )
            ]
        ),
      ),
    );
  }

  bankList({required IfscScreenController controller}) {
    double width = 100.w;
    double containerHeight = 33.sp;

    return Obx(() => ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(10.sp),
      separatorBuilder: (context, index) => SizedBox(height: 15.sp),
      itemCount: controller.isSearchOn.value == true ? controller.searchedList.value.length : Get.arguments == 'Select Bank' ? ifsc_list.length
          : Get.arguments == 'Select State' ? controller.stateList.length
          : Get.arguments == 'Select District' ? controller.cityList.length
          : controller.areaList.length,
      itemBuilder: (context, index) {
        if(Get.arguments == 'Select State') {
          log(' controller.stateList -> ${controller.stateList}');
        }
        if(Get.arguments == 'Select District') {
          log(' controller.cityList -> ${controller.cityList}');
        }
        if(Get.arguments == 'Select Branch') {
          log(' controller.areaList -> ${controller.areaList}');
        }

        return InkWell(
          onTap: () async {

            if(controller.bankName.value == 'Select Bank') {
              log('controller.bankName.value 11 -> ${ifsc_list[index].split('.').first}');
            } else {
              log('controller.bankName.value 22 -> ${controller.bankName.value}');
            }

            if(Get.arguments == 'Select Bank') {
              controller.bankName.value = 'Select Bank';
              controller.stateList.clear();
              controller.cityList.clear();
              controller.areaList.clear();
              controller.detailMap.clear();
            }

            List<String> lines =[];
            try {
              String path;
              if(controller.isSearchOn.value == true) {
                path = 'assets/IFSC_Code/${controller.bankName.value == 'Select Bank' ? controller.searchedList.value[index].split('.').first : controller.bankName.value}.txt';
              } else {
                path = 'assets/IFSC_Code/${controller.bankName.value == 'Select Bank' ? ifsc_list[index].split('.').first : controller.bankName.value}.txt';
              }
              log('path  -> ${path}');
              String fileData = await rootBundle.loadString(path);
              lines = LineSplitter.split(fileData).toList();
            } catch(e) {
              log('e  -> ${e}');
            }

            if(Get.arguments == 'Select Bank') {

              if(controller.isSearchOn.value == true) {
                controller.bankName.value = controller.searchedList.value[index].split('.').first;
              } else {
                controller.bankName.value = ifsc_list[index].split('.').first;
              }
              controller.stateName.value = 'Select State';
              controller.districtName.value = 'Select District';
              controller.branchName.value = 'Select Branch';
              log('controller.stateList 11 -> ${controller.stateList}');
              log('controller.bankName.value_____ -> ${controller.bankName.value}');

              List<String> states = lines[0].split('*');
              controller.stateList.addAll(states);
              log('lines[0]  -> ${lines[0]}');
              log('controller.stateList  22-> ${controller.stateList}');

            }
            else if(Get.arguments == 'Select State') {
              if(controller.isSearchOn.value == true) {
                controller.stateName.value = controller.searchedList.value[index];
              } else {
                controller.stateName.value = controller.stateList[index];
              }
              log('*********');
              log('controller.isSearchOn.value -> ${controller.isSearchOn.value}');
              log('controller.stateName.value@@ -> ${controller.stateName.value}');
              log('controller.stateList[index]@@ -> ${controller.stateList[index]}');
              log('************');
              controller.districtName.value = 'Select District';
              controller.branchName.value = 'Select Branch';

              controller.cityList.clear();
              controller.areaList.clear();
              controller.detailMap.clear();
              final secondLineList = lines[1].split('**');
              secondLineList.removeWhere((element) => element == '');
              secondLineList.forEach((element) {
                if(controller.isSearchOn.value == true) {
                  if(element.split('->').first == controller.searchedList.value[index]) {
                    log('element selected@@-> ${element.split('->').last.split('*').toList()}');
                    controller.cityList.addAll(element.split('->').last.split('*').toList());
                  }
                } else {
                  if(element.split('->').first == controller.stateList[index]) {
                    log('element selected@@-> ${element.split('->').last.split('*').toList()}');
                    controller.cityList.addAll(element.split('->').last.split('*').toList());
                  }
                }
                // map_districts.add({element.split('->').first : element.split('->').last.split('*').toList()});
              });

            }
            else if(Get.arguments == 'Select District') {
              if(controller.isSearchOn.value == true) {
                controller.districtName.value = controller.searchedList.value[index];
              } else {
                controller.districtName.value = controller.cityList[index];
              }
              controller.branchName.value = 'Select Branch';

              controller.areaList.clear();
              controller.detailMap.clear();
              final temp = lines[2].split('**');
              temp.removeWhere((element) => element == '');
              temp.forEach((element) {
                if(controller.isSearchOn.value == true) {
                  if(element.split('->')[1] == controller.searchedList.value[index]) {
                    log('element selected@@-> ${element.split('->').last.split('*').toList()}');
                    controller.areaList.addAll(element.split('->').last.split('*').toList());
                  }
                } else {
                  if(element.split('->')[1] == controller.cityList[index]) {
                    log('element selected@@-> ${element.split('->').last.split('*').toList()}');
                    controller.areaList.addAll(element.split('->').last.split('*').toList());
                  }
                }
                // map_branchs.add({element.split('->')[1] : element.split('->').last.split('*').toList()});
              });
            }
            else {
              if(controller.isSearchOn.value == true) {
                controller.branchName.value = controller.searchedList.value[index];
              } else {
                controller.branchName.value = controller.areaList[index];
              }

              final temp = lines[3].split('**');
              temp.removeWhere((element) => element == '');
              temp.forEach((element) {
                Map<String, dynamic> map = {};
                List<String> tempList = element.split('->').last.split('*');
                if(controller.isSearchOn.value == true) {
                  if(element.split('->')[2] == controller.searchedList.value[index]) {
                    print('element.split()[2]@@@ -> ${element.split('->')[2]}');
                    print('tempList -> ${tempList}');
                    map['branch'] = '${element.split('->')[2]}';
                    map['address'] = '${tempList[0]}';
                    map['phone_number'] = tempList[1].split(',').last;
                    map['ifsc_code'] = tempList[2];
                    map['micr_code'] = tempList[3];
                    controller.detailMap.addAll(map);
                  }
                } else {
                  if(element.split('->')[2] == controller.areaList[index]) {
                    print('element.split()[2] -> ${element.split('->')[2]}');
                    map['branch'] = '${element.split('->')[2]}';
                    map['address'] = '${tempList[0]}';
                    map['phone_number'] = tempList[1].split(',').last;
                    map['ifsc_code'] = tempList[2];
                    map['micr_code'] = tempList[3];
                    controller.detailMap.addAll(map);
                  }
                }
              });
              print(' ');
              print('detail -> ${controller.detailMap}');
            }

            controller.isSearchOn.value = false;
            // for(int i = 0; i < lines.length; i++) {
            //   if(i == 0) {
            //     List<String> states = lines[i].split('*');
            //     controller.stateList.addAll(states);
            //     // print('states  -> $states');
            //   }
            //   if(i == 1) {
            //     final temp = lines[i].split('**');
            //     temp.removeWhere((element) => element == '');
            //     temp.forEach((element) {
            //       map_districts.add({element.split('->').first : element.split('->').last.split('*').toList()});
            //     });
            //     // print('city @@-> $map_districts');
            //   }
            //   if(i == 2) {
            //     final temp = lines[i].split('**');
            //     temp.removeWhere((element) => element == '');
            //     temp.forEach((element) {
            //       map_branchs.add({element.split('->')[1] : element.split('->').last.split('*').toList()});
            //     });
            //     // print('areas @@-> $map_branchs');
            //   }
            //   if(i == 3) {
            //     final temp = lines[i].split('**');
            //     temp.removeWhere((element) => element == '');
            //     temp.forEach((element) {
            //       Map<String, dynamic> map = {};
            //       List<String> tempList = element.split('->').last.split('*');
            //       map['branch'] = '${element.split('->')[2]}';
            //       map['address'] = '${tempList[0]}';
            //       map['phone_number'] = tempList[1];
            //       map['ifsc_code'] = tempList[2];
            //       map['micr_code'] = tempList[3];
            //       map_details.add(map);
            //     });
            //     // details.forEach((element) {
            //       print(' ');
            //       print('detail -> ${map_details}');
            //     // });
            //   }
            //
            // }
            log(' ');
            Get.back();
          },
          child: Material(
            elevation: 1.2,
            shadowColor: Colors.white70,
            borderRadius: BorderRadius.circular(16.2.sp),
            child: Container(
              height: containerHeight,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.sp),
                  gradient: ConstantsColor.buttonGradient
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.sp),
                  Container(
                    padding: EdgeInsets.all(3.5.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.sp),
                        gradient: ConstantsColor.pinkGradient
                    ),
                    child: Container(
                        height: containerHeight - 18.sp,
                        width: containerHeight - 18.sp,
                        decoration: BoxDecoration(
                            color: ConstantsColor.backgroundDarkColor,
                            borderRadius: BorderRadius.circular(15.sp)
                        ),
                        padding: EdgeInsets.all(12.sp),
                        child: Image.asset(ConstantsImage.balance_icon)
                    ),
                  ),
                  SizedBox(width: 15.sp),
                  Expanded(
                    child: Text(controller.isSearchOn.value == true ? controller.searchedList.value[index] : Get.arguments == 'Select Bank' ? ifsc_list[index].split('.').first
                        : Get.arguments == 'Select State' ? controller.stateList[index]
                        : Get.arguments == 'Select District' ? controller.cityList[index]
                        : controller.areaList[index],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15.5.sp),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 15.sp),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }



  Widget searchBar({required double width, required String fieldName}) {
    return Material(
      elevation: 1,
      shadowColor: Colors.white70,
      borderRadius: BorderRadius.circular(20.sp),
      child: Container(
        height: 30.sp,
        width: width * 0.95,
        decoration: BoxDecoration(
          gradient: ConstantsColor.buttonGradient,
          borderRadius: BorderRadius.circular(20.sp)
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
                  hintStyle: TextStyle(fontSize: 16.5.sp, color: Colors.white, fontWeight: FontWeight.w400),
                  border: InputBorder.none
                ),
                onChanged: (str) {
                  if(str.length > 0) {
                    controller.isSearchOn.value = true;
                  } else {
                    controller.isSearchOn.value = false;
                  }
                  print('Get.arguments -> ${Get.arguments}');
                  print('controller.isSearchOn.value -> ${controller.isSearchOn.value}');

                  if(Get.arguments == 'Select Bank') {
                    // ifsc_list.forEach((element) {
                    //   if(element.toLowerCase().contains(str.toLowerCase())) {
                    //     controller.searchedList.value.add(element.split('.').first);
                    //     print('controller.searchedList.value -> ${controller.searchedList.value}');
                    //   }
                    // });
                    controller.searchedList.value = ifsc_list.where((element) => element.toLowerCase().contains(str.toLowerCase())).toList();
                    controller.searchedList.value = controller.searchedList.value.map((e) => e.toString().split('.').first).toList();
                  } else if(Get.arguments == 'Select State') {
                    controller.searchedList.value = controller.stateList.where((element) => element.toLowerCase().contains(str.toLowerCase())).toList();
                  } else if(Get.arguments == 'Select District') {
                    controller.searchedList.value = controller.cityList.where((element) => element.toLowerCase().contains(str.toLowerCase())).toList();
                  } else {
                    controller.searchedList.value = controller.areaList.where((element) => element.toLowerCase().contains(str.toLowerCase())).toList();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}