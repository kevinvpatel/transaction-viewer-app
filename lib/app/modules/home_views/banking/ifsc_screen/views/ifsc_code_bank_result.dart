import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transaction_viewer_app/app/data/constants.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/ifsc_screen/controllers/ifsc_screen_controller.dart';

class IfscCodeBankResultView extends GetView<IfscScreenController> {
  const IfscCodeBankResultView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    IfscScreenController controller = Get.put(IfscScreenController());
    double height = 100.h;
    double width = 100.w;

    Map<String, dynamic> map = Get.arguments;

    print('map -> ${map}');


    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: '', onTapBack: () => Get.back(), isShareButtonEnable: false),
      body: Container(
        height: height,
        width: width,
        margin: EdgeInsets.only(left: 13.sp, right: 11.sp, top: 15.sp),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 15.sp),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.sp),
                          gradient: ConstantsColor.pinkGradient
                      ),
                      padding: EdgeInsets.all(6.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ConstantsColor.backgroundDarkColor,
                          borderRadius: BorderRadius.circular(50.sp)
                        ),
                        child: convertBankAddressToBankIcon(bankName: map['bank_name'], bankBundleData: controller.bankBundleData, padding: 15.sp, height: 32.sp)
                      ),
                    ),
                    SizedBox(width: 20.sp),
                    Container(
                      width: width * 0.7,
                      child: Text(map['bank_name'],
                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.sp),
                Row(
                  children: [
                    box(width: width * 0.46, title: 'District', data: map['district_name']),
                    Spacer(),
                    box(width: width * 0.45, title: 'State', data: map['state_name']),
                    SizedBox(width: 5.sp),
                  ],
                ),
                SizedBox(height: 25.sp),
                box(width: width - 19.sp, height: 45.sp, title: 'Address', data: map['details']['address'], verticalPadding: 15.sp),
                SizedBox(height: 23.sp),
                Text('Branch Codes', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500, fontSize: 18.sp),),
                SizedBox(height: 23.sp),
                branchCodeBox(width: width - 19.sp, height: 38.sp, title: 'IFSC', data: map['details']['ifsc_code'], verticalPadding: 5.sp),
                SizedBox(height: 22.sp),
                branchCodeBox(width: width - 19.sp, height: 38.sp, title: 'MICR Code', data: map['details']['micr_code'], verticalPadding: 5.sp),
                SizedBox(height: 22.sp),
                branchCodeBox(width: width - 19.sp, height: 38.sp, title: 'Phone Number', data: map['details']['phone_number'], verticalPadding: 5.sp),
                SizedBox(height: 22.sp),
              ]
          ),
        ),
      ),
    );
  }


  Widget box({required double width, double? height, required String title, required String data, double? verticalPadding}) {
    return Container(
      width: width,
      height: height ?? 42.sp,
      decoration: BoxDecoration(
        boxShadow: ConstantsWidgets.boxShadow,
        gradient: ConstantsColor.buttonGradient,
        borderRadius: BorderRadius.circular(17.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: verticalPadding ?? 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Text(title, style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500, fontSize: 16.5.sp),),
          Spacer(),
          Text(
            data,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.5.sp, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          Spacer(),
        ],
      ),
    );
  }


  Widget branchCodeBox({required double width, double? height, required String title, required String data, double? verticalPadding}) {
    return Container(
      width: width,
      height: height ?? 42.sp,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(offset: Offset(0.8, 0.9), color: Colors.white30, spreadRadius: 0, blurRadius: 0.5)],
        gradient: ConstantsColor.buttonGradient,
        borderRadius: BorderRadius.circular(17.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 17.5.sp, vertical: verticalPadding ?? 0.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17.5.sp),),
              Spacer(),
              Text(
                data,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade400, fontWeight: FontWeight.w300),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          button(
            height: height,
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: data));
              Fluttertoast.showToast(msg: 'Copied ${title} : $data');
            },
            imagePath: ConstantsImage.copy_icon
          ),
          SizedBox(width: 17.sp),
          button(height: height, onTap: () => Share.share(data), imagePath: ConstantsImage.sharecode_icon)
        ],
      ),
    );
  }


  Widget button({double? height, required Function() onTap, required String imagePath}) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(3.2.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.2.sp),
              gradient: ConstantsColor.pinkGradient
          ),
          child: Container(
            height: (height ?? 42.sp) * 0.45,
            width: (height ?? 42.sp) * 0.45,
            decoration: BoxDecoration(
              color: ConstantsColor.backgroundDarkColor,
              borderRadius: BorderRadius.circular(13.sp),
            ),
            padding: EdgeInsets.all(10.5.sp),
            child: Image.asset(imagePath),
          ),
        ),
      );
  }


}