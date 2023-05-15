import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/modules/splash_screen/controllers/splash_screen_controller.dart';

class Screens {

  static PageController pageController = PageController();

  static Widget subScreen1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 10.sp) ,child: Image.asset(ConstantsImage.instant_balance_check_image)),
          SizedBox(height: 20.sp),
          Text('Instant Bank \nBalance Check', textAlign: TextAlign.start ,style: TextStyle(fontSize: 23.sp, color: ConstantsColor.purpleColor, fontWeight: FontWeight.w700),),
          SizedBox(height: 15.sp),
          Text('Internet Banking you can access net banking \n'
              'of all your bank account with the help of the \n'
              'bank balance check all enquiry app. You will \n'
              'be able to check balances, view bank \n'
              'statements and access other banking \n'
              'services provided by your bank',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15.8.sp, color: Colors.white, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  static Widget subScreen2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 10.sp) ,child: Image.asset(ConstantsImage.all_banking_balance_enquire_image)),
          SizedBox(height: 20.sp),
          Text('All Banking \nBalance Enquiry', textAlign: TextAlign.start ,style: TextStyle(fontSize: 23.sp, color: ConstantsColor.purpleColor, fontWeight: FontWeight.w700),),
          SizedBox(height: 15.sp),
          Text('If you want to know your bank’s account \n'
              'balance any time anywhere by free of cost, \n'
              'this is the app that will help you with that. You \n'
              'don’t want to login to your bank account or \n'
              'internet banking or any mobile banking , also \n'
              'no need to share your credentials of any \n'
              'account.',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15.8.sp, color: Colors.white, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  static Widget subScreen3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 18.sp) ,child: Image.asset(ConstantsImage.checking_your_bank_account_image)),
          SizedBox(height: 20.sp),
          Text('Checking Your \nBank Account', textAlign: TextAlign.start ,style: TextStyle(fontSize: 23.sp, color: ConstantsColor.purpleColor, fontWeight: FontWeight.w700),),
          SizedBox(height: 15.sp),
          Text('All Bank Balance Check and IFSC code all bank \n'
              '- Find all bank IFSC code with the help of \n'
              'balance check app : All Bank Balance Enquiry \n'
              'app. Moreover, you can search for IFSC code \n'
              'by pincode number.',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15.8.sp, color: Colors.white, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }



}