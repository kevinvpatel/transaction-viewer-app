import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    controller.loadRegExJson(transactionType: 'ALL');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: GetBuilder(
            init: HomeController(),
            builder: (controller) {
              return controller.allMessageDetails.value.isNotEmpty
                  ? Obx(() => Text('Current Balance : ${totalBalance.value}'))
                  : const SizedBox.shrink();
            },
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: controller.tabController,
            onTap: (index) {
              controller.loadRegExJson(transactionType: index != 0 ? index == 1 ? 'CREDITED' : 'DEBITED' : 'ALL');
            },
              tabs: [
                Tab(child: Text('ALL', style: TextStyle(fontSize: 16.5.sp),)),
                Tab(child: Text('CREDITED', style: TextStyle(fontSize: 16.5.sp),)),
                Tab(child: Text('DEBITED', style: TextStyle(fontSize: 16.5.sp),)),
              ]
          ),
        ),
        body: TabBarView(
            controller: controller.tabController,
            children: [
              tabAll(),
              tabCredit(),
              tabDebit(),
            ]
        ),
      ),
    );
  }

  tabAll() {
    double height = 100.h;
    double width = 100.w;

    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          print('controller.allMessageDetails.length -> ${controller.allMessageDetails.length}');
          return Obx(() => Container(
            height: height,
            width: width,
            color: Colors.green.shade200,
            child: controller.allMessageDetails.length > 0 ? GroupedListView(
                elements: controller.allMessageDetails,
                order: GroupedListOrder.DESC,
                itemComparator: (item1, item2) =>
                    item1['date'].compareTo(item2['date']),
                groupBy: (message) => message['group'],
                groupSeparatorBuilder: (group) {
                  return Container(
                    height: 33.sp,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Row(
                      children: [
                        Text(group, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                },
                separator: const Divider(color: Colors.black, height: 0, thickness: 1),
                itemBuilder: (context, message) {
                  print('msgDetail -> $message');
                  return Container(
                    height: 33.sp,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Row(
                      children: [
                        Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                        SizedBox(width: 15.sp),
                        SizedBox(
                            width: width * 0.5,
                            child: Text(message['transaction_account'] ?? 'UNKNOWN', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis, maxLines: 1)
                        ),
                        const Spacer(),
                        Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                      ],
                    ),
                  );
                }
            ) : const Center(child: Text('Please Wait...')),

            // child: StreamBuilder<List<SmsMessage>>(
            //     stream: controller.loadRegExJson(),
            //     builder: (BuildContext context, AsyncSnapshot<List<SmsMessage>> snapshot) {
            //       if(snapshot.connectionState == ConnectionState.done) {
            //         if(snapshot.data!.length > 0) {
            //           List<SmsMessage> messages = snapshot.data!;
            //           return GroupedListView(
            //               elements: controller.messageDetails,
            //               order: GroupedListOrder.DESC,
            //               itemComparator: (item1, item2) =>
            //                   item1['date'].compareTo(item2['date']),
            //               groupBy: (message) => message['group'],
            //               groupSeparatorBuilder: (group) {
            //                 return Container(
            //                   height: 33.sp,
            //                   color: Colors.white,
            //                   padding: EdgeInsets.symmetric(horizontal: 15.sp),
            //                   child: Row(
            //                     children: [
            //                       Text(group, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
            //                     ],
            //                   ),
            //                 );
            //               },
            //               separator: const Divider(color: Colors.black, height: 0, thickness: 1),
            //               itemBuilder: (context, message) {
            //                 print('msgDetail -> ${message}');
            //                 return Container(
            //                   height: 33.sp,
            //                   color: Colors.white,
            //                   padding: EdgeInsets.symmetric(horizontal: 15.sp),
            //                   child: Row(
            //                     children: [
            //                       Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
            //                       SizedBox(width: 15.sp),
            //                       Container(
            //                           width: width * 0.5,
            //                           child: Text(message['transaction_account'] ?? 'UNKNOWN', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis, maxLines: 1)
            //                       ),
            //                       Spacer(),
            //                       Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
            //                     ],
            //                   ),
            //                 );
            //               }
            //           );
            //         } else {
            //           return Center(child: Text('No Transactions Found For ${Get.arguments}'));
            //         }
            //       } else {
            //         return Center(child: Text('Please Wait...'));
            //       }
            //     }
            // ),
          ));
        }
    );
  }


  tabCredit() {
    double height = 100.h;
    double width = 100.w;

    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          print('controller.allMessageDetails.length -> ${controller.allMessageDetails.length}');
          return Obx(() => Container(
            height: height,
            width: width,
            color: Colors.green.shade200,
            child: controller.allMessageDetails.length > 0 ? GroupedListView(
                elements: controller.creditMessageDetails,
                order: GroupedListOrder.DESC,
                itemComparator: (item1, item2) =>
                    item1['date'].compareTo(item2['date']),
                groupBy: (message) => message['group'],
                groupSeparatorBuilder: (group) {
                  return Container(
                    height: 33.sp,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Row(
                      children: [
                        Text(group, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                },
                separator: const Divider(color: Colors.black, height: 0, thickness: 1),
                itemBuilder: (context, message) {
                  print('msgDetail -> $message');
                  return Container(
                    height: 33.sp,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Row(
                      children: [
                        Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                        SizedBox(width: 15.sp),
                        SizedBox(
                            width: width * 0.5,
                            child: Text(message['transaction_account'] ?? 'UNKNOWN', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis, maxLines: 1)
                        ),
                        const Spacer(),
                        Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                      ],
                    ),
                  );
                }
            ) : const Center(child: Text('Please Wait...')),

            // child: StreamBuilder<List<SmsMessage>>(
            //     stream: controller.loadRegExJson(),
            //     builder: (BuildContext context, AsyncSnapshot<List<SmsMessage>> snapshot) {
            //       if(snapshot.connectionState == ConnectionState.done) {
            //         if(snapshot.data!.length > 0) {
            //           List<SmsMessage> messages = snapshot.data!;
            //           return GroupedListView(
            //               elements: controller.messageDetails,
            //               order: GroupedListOrder.DESC,
            //               itemComparator: (item1, item2) =>
            //                   item1['date'].compareTo(item2['date']),
            //               groupBy: (message) => message['group'],
            //               groupSeparatorBuilder: (group) {
            //                 return Container(
            //                   height: 33.sp,
            //                   color: Colors.white,
            //                   padding: EdgeInsets.symmetric(horizontal: 15.sp),
            //                   child: Row(
            //                     children: [
            //                       Text(group, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
            //                     ],
            //                   ),
            //                 );
            //               },
            //               separator: const Divider(color: Colors.black, height: 0, thickness: 1),
            //               itemBuilder: (context, message) {
            //                 print('msgDetail -> ${message}');
            //                 return Container(
            //                   height: 33.sp,
            //                   color: Colors.white,
            //                   padding: EdgeInsets.symmetric(horizontal: 15.sp),
            //                   child: Row(
            //                     children: [
            //                       Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
            //                       SizedBox(width: 15.sp),
            //                       Container(
            //                           width: width * 0.5,
            //                           child: Text(message['transaction_account'] ?? 'UNKNOWN', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis, maxLines: 1)
            //                       ),
            //                       Spacer(),
            //                       Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
            //                     ],
            //                   ),
            //                 );
            //               }
            //           );
            //         } else {
            //           return Center(child: Text('No Transactions Found For ${Get.arguments}'));
            //         }
            //       } else {
            //         return Center(child: Text('Please Wait...'));
            //       }
            //     }
            // ),
          ));
        }
    );
  }


  tabDebit() {
    double height = 100.h;
    double width = 100.w;

    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          print('controller.allMessageDetails.length -> ${controller.allMessageDetails.length}');
          return Obx(() => Container(
            height: height,
            width: width,
            color: Colors.green.shade200,
            child: controller.allMessageDetails.length > 0 ? GroupedListView(
                elements: controller.debitMessageDetails,
                order: GroupedListOrder.DESC,
                itemComparator: (item1, item2) =>
                    item1['date'].compareTo(item2['date']),
                groupBy: (message) => message['group'],
                groupSeparatorBuilder: (group) {
                  return Container(
                    height: 33.sp,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Row(
                      children: [
                        Text(group, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                },
                separator: const Divider(color: Colors.black, height: 0, thickness: 1),
                itemBuilder: (context, message) {
                  print('msgDetail -> $message');
                  return Container(
                    height: 33.sp,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Row(
                      children: [
                        Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                        SizedBox(width: 15.sp),
                        SizedBox(
                            width: width * 0.5,
                            child: Text(message['transaction_account'] ?? 'UNKNOWN', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis, maxLines: 1)
                        ),
                        const Spacer(),
                        Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
                      ],
                    ),
                  );
                }
            ) : const Center(child: Text('Please Wait...')),

            // child: StreamBuilder<List<SmsMessage>>(
            //     stream: controller.loadRegExJson(),
            //     builder: (BuildContext context, AsyncSnapshot<List<SmsMessage>> snapshot) {
            //       if(snapshot.connectionState == ConnectionState.done) {
            //         if(snapshot.data!.length > 0) {
            //           List<SmsMessage> messages = snapshot.data!;
            //           return GroupedListView(
            //               elements: controller.messageDetails,
            //               order: GroupedListOrder.DESC,
            //               itemComparator: (item1, item2) =>
            //                   item1['date'].compareTo(item2['date']),
            //               groupBy: (message) => message['group'],
            //               groupSeparatorBuilder: (group) {
            //                 return Container(
            //                   height: 33.sp,
            //                   color: Colors.white,
            //                   padding: EdgeInsets.symmetric(horizontal: 15.sp),
            //                   child: Row(
            //                     children: [
            //                       Text(group, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
            //                     ],
            //                   ),
            //                 );
            //               },
            //               separator: const Divider(color: Colors.black, height: 0, thickness: 1),
            //               itemBuilder: (context, message) {
            //                 print('msgDetail -> ${message}');
            //                 return Container(
            //                   height: 33.sp,
            //                   color: Colors.white,
            //                   padding: EdgeInsets.symmetric(horizontal: 15.sp),
            //                   child: Row(
            //                     children: [
            //                       Text(DateFormat('dd MMM').format(message['date']), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
            //                       SizedBox(width: 15.sp),
            //                       Container(
            //                           width: width * 0.5,
            //                           child: Text(message['transaction_account'] ?? 'UNKNOWN', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis, maxLines: 1)
            //                       ),
            //                       Spacer(),
            //                       Text('${message['transaction_type'] == 'credit' ? '+' : '-'}  ₹ ${message['transaction_amount']}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: message['transaction_type'] == 'credit' ? Colors.green : Colors.red)),
            //                     ],
            //                   ),
            //                 );
            //               }
            //           );
            //         } else {
            //           return Center(child: Text('No Transactions Found For ${Get.arguments}'));
            //         }
            //       } else {
            //         return Center(child: Text('Please Wait...'));
            //       }
            //     }
            // ),
          ));
        }
    );
  }

}