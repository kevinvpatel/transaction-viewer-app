import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import '../controllers/bank_detail_screen_controller.dart';

extension UtilListExtension on List{
  groupBy(String key) {
    try {
      List<Map<String, dynamic>> result = [];
      List<String> keys = [];

      this.forEach((f) => keys.add(f[key]));

      [...keys.toSet()].forEach((k) {
        List data = [...this.where((e) => e[key] == k)];
        result.add({k: data});
      });

      return result;
    } catch (e, s) {
      // printCatchNReport(e, s);
      return this ;
    }
  }
}

class BankDetailScreenView extends GetView<BankDetailScreenController> {
  const BankDetailScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BankDetailScreenController controller = Get.put(BankDetailScreenController());
    double height = 100.h;
    double width = 100.w;
    controller.loadRegExJson(transactionType: 'ALL');


    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: Get.arguments, onTapBack: () {}),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Column(
          children: [
            Material(
              borderRadius: BorderRadius.circular(15.sp),
              elevation: 1,
              shadowColor: Colors.white70,
              child: Container(
                height: 48.sp,
                width: width,
                decoration: BoxDecoration(
                  gradient: ConstantsColor.buttonGradient,
                  borderRadius: BorderRadius.circular(15.sp)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('A/c No : XXXXXX545564', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w400),),
                    Text('Total Balance', style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),),
                    Text('80,954.65', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideSwitcher(
                  slidersHeight: 27.sp,
                  slidersWidth: width * 0.27,
                  sliderContainer: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 28.sp,
                    width: width * 0.27,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.sp),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(128, 34, 208, 1),
                            Color.fromRGBO(200, 32, 203, 0.82),
                            Color.fromRGBO(242, 142, 206, 1),
                            Color.fromRGBO(241, 130, 144, 1),
                          ]
                      )
                    ),
                    padding: EdgeInsets.all(5.sp),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.sp),
                        color: ConstantsColor.backgroundDarkColor,
                      ),
                    ),
                  ),
                  initialIndex: 0,
                  containerHeight: 27.sp,
                  containerWight: width * 0.815,
                  containerGradient: ConstantsColor.buttonGradient,
                  onSelect: (int index) {
                    controller.loadRegExJson(transactionType: index != 0 ? index == 1 ? 'CREDITED' : 'DEBITED' : 'ALL');
                    controller.tabIndex.value = index;
                  },
                  children: [
                    Text('ALL', style: TextStyle(fontSize: 15.2.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                    Text('CREDITED', style: TextStyle(fontSize: 15.2.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                    Text('DEBITED', style: TextStyle(fontSize: 15.2.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                  // s
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Image.asset(ConstantsImage.select_month_icon, height: 23.sp, width: 23.sp)
                )
              ],
            ),
            // controller.tabIndex.value == 0 ? Container()
            //     : controller.tabIndex.value == 1 ? Container()
            //     : Container()
            SizedBox(height: 15.sp),
            Expanded(
              child: GetBuilder(
                init: BankDetailScreenController(),
                builder: (controller) {
                  List<Map<String, dynamic>> listMessages = controller.allMessageDetails.groupBy('group');
                  return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: listMessages.length,
                      itemBuilder: (context, index) {
                        // listMessages[index].values.first.forEach((element) {
                        //   print('transaction_amount --> ${element['transaction_amount']}');
                        //   print('body --> ${element['body']}');
                        //   print('element --> ${element}');
                        //   print(' ');
                        //
                        // });
                        final t = listMessages[index].values.reduce((value, element) {

                          print('value --> ${value}');
                          print('element --> ${element}');
                          return element;
                        });
                        print('t --> ${t}');

                        return Column(
                          children: [
                            Material(
                              elevation: 2,
                              shadowColor: Colors.white54,
                              borderRadius: BorderRadius.circular(18.sp),
                              child: Container(
                                height: 34.sp,
                                width: width,
                                decoration: BoxDecoration(
                                    gradient: ConstantsColor.buttonGradient,
                                    borderRadius: BorderRadius.circular(18.sp)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 18.sp),
                                    Text(listMessages[index].keys.first.toString().toUpperCase(),
                                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                                    Spacer(),
                                    Text(listMessages[index].keys.first.toString().toUpperCase(),
                                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                                    SizedBox(width: 18.sp),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: List.generate(listMessages[index].values.first.length, (groupedIndex) {
                                List listGroupedMessages = listMessages[index].values.first.toList();
                                return InkWell(
                                  onTap: () {
                                    detailDialoge(message: listGroupedMessages[groupedIndex]['body']);
                                  },
                                  child: Container(
                                    height: 33.sp,
                                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                                    child: Row(
                                      children: [
                                        Text(DateFormat('dd MMM').format(listGroupedMessages[groupedIndex]['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                                        SizedBox(width: 15.sp),
                                        SizedBox(
                                            width: width * 0.5,
                                            child: Text(listGroupedMessages[groupedIndex]['transaction_account'] ?? 'UNKNOWN',
                                                style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                                        ),
                                        const Spacer(),
                                        Text('${listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${listGroupedMessages[groupedIndex]['transaction_amount']}',
                                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: listGroupedMessages[groupedIndex]['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        );
                        return StickyHeader(
                          header: Material(
                            elevation: 2,
                            shadowColor: Colors.white54,
                            borderRadius: BorderRadius.circular(18.sp),
                            child: Container(
                              height: 34.sp,
                              width: width,
                              decoration: BoxDecoration(
                                  gradient: ConstantsColor.buttonGradient,
                                  borderRadius: BorderRadius.circular(18.sp)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 18.sp),
                                  Text(controller.allMessageDetails[index]['group'].toString().toUpperCase(),
                                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                                  Spacer(),
                                  Text(controller.allMessageDetails[index]['group'],
                                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                                  SizedBox(width: 18.sp),
                                ],
                              ),
                            ),
                          ),
                          content: InkWell(
                            onTap: () {
                              detailDialoge(message: controller.allMessageDetails[index]['body']);
                            },
                            child: Container(
                              height: 33.sp,
                              padding: EdgeInsets.symmetric(horizontal: 15.sp),
                              child: Row(
                                children: [
                                  Text(DateFormat('dd MMM').format(controller.allMessageDetails[index]['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                                  SizedBox(width: 15.sp),
                                  SizedBox(
                                      width: width * 0.5,
                                      child: Text(controller.allMessageDetails[index]['transaction_account'] ?? 'UNKNOWN',
                                          style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                                  ),
                                  const Spacer(),
                                  Text('${controller.allMessageDetails[index]['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${controller.allMessageDetails[index]['transaction_amount']}',
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: controller.allMessageDetails[index]['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(color: Colors.white, height: 0, thickness: 0.2),
                  );
                  return GroupedListView(
                    elements: controller.allMessageDetails,
                    groupBy: (message) => message['group'],
                    floatingHeader: false,
                    physics: BouncingScrollPhysics(),
                    groupSeparatorBuilder: (group) {
                      return Material(
                        elevation: 2,
                        shadowColor: Colors.white54,
                        borderRadius: BorderRadius.circular(18.sp),
                        child: Container(
                          height: 34.sp,
                          width: width,
                          decoration: BoxDecoration(
                            gradient: ConstantsColor.buttonGradient,
                            borderRadius: BorderRadius.circular(18.sp)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 18.sp),
                              Text(group.toString().toUpperCase(), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                              Spacer(),
                              Text(group, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                              SizedBox(width: 18.sp),
                            ],
                          ),
                        ),
                      );
                    },
                    separator: const Divider(color: Colors.white, height: 0, thickness: 0.2),
                    itemBuilder: (context, message) {
                      return InkWell(
                        onTap: () {
                          detailDialoge(message: message);
                        },
                        child: Container(
                          height: 33.sp,
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Row(
                            children: [
                              Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                              SizedBox(width: 15.sp),
                              SizedBox(
                                  width: width * 0.5,
                                  child: Text(message['transaction_account'] ?? 'UNKNOWN',
                                      style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1)
                              ),
                              const Spacer(),
                              Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                            ],
                          ),
                        ),
                      );
                    },
                    itemComparator: (item1, item2) => item1['date'].compareTo(item2['date']),
                    // elementIdentifier: (element) => element.name,
                    order: GroupedListOrder.DESC,
                  );
                }
              )
            )
          ],
        ),
      ),
    );
  }


  detailDialoge({required Map<String, dynamic> message}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            width: 95.w,
            decoration: BoxDecoration(
              gradient: ConstantsColor.buttonGradient,
              borderRadius: BorderRadius.circular(18.sp),
              border: Border.all(color: Colors.white)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
                    )
                  ],
                ),
                Text('Transaction Details', style: TextStyle(fontSize: 18.5.sp, fontWeight: FontWeight.w600, color: ConstantsColor.purpleColor)),
                SizedBox(height: 20.sp),
                Text('Account no - XXXXX${message['account_number']}', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                SizedBox(height: 15.sp),
                Padding(
                  padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
                  child: Text(message['body'],
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.white),
                      textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }


}
