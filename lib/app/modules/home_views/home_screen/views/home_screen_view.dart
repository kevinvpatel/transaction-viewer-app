import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/widget_constants.dart';
import 'package:transaction_viewer_app/app/data/fuel_price_model.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/ifsc_screen/views/ifsc_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/home_loan_calculator_screen/views/business_loan_calculator_screen.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/home_loan_calculator_screen/views/fd_loan_calculator_screen.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/home_loan_calculator_screen/views/home_loan_calculator_screen_view.dart';
import 'package:transaction_viewer_app/app/modules/home_views/calculators/home_loan_calculator_screen/views/rd_loan_calculator_screen.dart';
import 'package:transaction_viewer_app/app/modules/home_views/home_screen/views/change_city_screen.dart';

import '../controllers/home_screen_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());
    double height = 100.h;
    double width = 100.w;

    return Scaffold(
      backgroundColor: ConstantsColor.backgroundDarkColor,
      appBar: ConstantsWidgets.appBar(title: 'All Bank Balance Check'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 15.sp),
            ///Advertise
            Container(
              height: 32.h,
              width: 100.w,
              margin: EdgeInsets.symmetric(horizontal: 10.sp),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15.sp),
              ),
            ),
            ///Banking
            gradientCard(height: height, width: width, title: 'Banking', mapData: controller.listBanking, isBanking: true),
            SizedBox(height: 22.sp),
            dailyPriceList(height: height, width: width),
            SizedBox(height: 22.sp),
            simpleCard(width: width, title: 'Credit & Loan Products', data: controller.listCreditAndLoan),
            ///Calculators
            gradientCard(height: height, width: width, title: 'Calculators', mapData: controller.listCalculators, isBanking: false),
            SizedBox(height: 22.sp),
            simpleCard(width: width, title: 'Schemes  ', data: controller.listSchemes),
            SizedBox(height: 30.sp),
          ],
        ),
      ),
    );
  }


  dailyPriceList({required double height, required double width}) {
    double cardHeight = height * 0.36;

    return Container(
      height: cardHeight,
      width: width,
      decoration: const BoxDecoration(
          gradient: ConstantsColor.buttonGradient
      ),
      child: Column(
        children: [
          SizedBox(height: 17.sp),
          Container(
            width: width,
            padding: EdgeInsets.only(left: 12.sp),
            alignment: Alignment.centerLeft,
            child: Text('Daily Price List', style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500))
          ),
          SizedBox(height: 15.sp),
          ///Petrol Price Scroll
          GetBuilder(
            init: HomeScreenController(),
            builder: (controller) {
              return FutureBuilder<Price?>(
                  future: controller.getFuelPriceData(state: controller.stateName, city: controller.cityName),
                  builder: (BuildContext context, AsyncSnapshot<Price?> snapshot) {
                    if(snapshot.hasData) {
                      if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.none) {
                        return Container(
                            height: cardHeight * 0.64,
                            width: width,
                            child: const Center(child: CircularProgressIndicator(color: Colors.white))
                        );
                      } else {
                        Price? price = snapshot.data;
                        print('price -> ${price?.fuel?.diesel?.retailPrice}');
                        return fuelPriceSlider(price: price);
                      }
                    } else {
                      return fuelPriceSlider();
                    }
                  }
              );
            }
          ),
          // Spacer(),
        ],
      ),
    );
  }


  fuelPriceSlider({Price? price}) {
    double width = 100.w;
    double height = 100.h;
    double cardHeight = height * 0.36;

    print('price111 -> $price');

    return GetBuilder(
      init: HomeScreenController(),
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              height: cardHeight * 0.64,
              width: width,
              child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: price != null ? 3 : 1,
                  onPageChanged: (page) => controller.currentPage.value = page,
                  itemBuilder: (context, index) {
                    return Container(
                      height: cardHeight * 0.6,
                      margin: EdgeInsets.symmetric(horizontal: 21.sp),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(91, 17, 176, 1),
                          borderRadius: BorderRadius.circular(17.sp)
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: null, icon: SizedBox(width: 20.sp, height: 20.sp)),
                              Text('Today’s Fuel Price', style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w600)),
                              IconButton(
                                  onPressed: (){},
                                  icon: Image.asset(ConstantsImage.more_circle_icon, height: 20.sp)
                              )
                            ],
                          ),
                          Spacer(),
                          price != null ? IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('₹ ${price.fuel?.petrol?.retailPrice}', style: TextStyle(color: Colors.white, fontSize: 19.sp, fontWeight: FontWeight.w600)),
                                    SizedBox(height: 12.sp),
                                    Text('Petrol', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w300)),
                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                                Column(
                                  children: [
                                    Text('₹ ${price.fuel?.diesel?.retailPrice}', style: TextStyle(color: Colors.white, fontSize: 19.sp, fontWeight: FontWeight.w600)),
                                    SizedBox(height: 12.sp),
                                    Text('Diesel', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w300)),
                                  ],
                                ),

                              ],
                            ),
                          ) : Center(
                              child: Obx(() => Text(controller.failedAPIMessage.value,
                                style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ))
                          ),
                          Spacer(flex: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  print('controller.allCitiesMap -> ${controller.allCitiesMap}');
                                  Get.to(const ChangeCityScreen(), arguments: controller.allCitiesMap);
                                },
                                child: Row(
                                  children: [
                                    Text('${controller.cityName.toUpperCase()}, ${controller.stateName.toUpperCase()} ',
                                      style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 18.sp),
                                    SizedBox(width: 12.sp)
                                  ],
                                ),
                              )
                            ],
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    );
                  }
              ),
            ),
            SizedBox(height: cardHeight * 0.07),
            SmoothPageIndicator(
                controller: controller.pageController,  // PageController
                count: price != null ? 3 : 1,
                effect: ExpandingDotsEffect(
                    dotColor: Colors.white70,
                    activeDotColor: Colors.white,
                    dotHeight: 11.5.sp,
                    expansionFactor: 3,
                    dotWidth: 11.5.sp
                ),  // your preferred effect
                onDotClicked: (index){
                }
            ),
          ],
        );
      }
    );
  }


  simpleCard({required double width, required String title, required List<Map<String, dynamic>> data}) {
    return Column(
      children: [
        Container(
            width: width,
            padding: EdgeInsets.only(left: 12.sp),
            alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500))
        ),
        SizedBox(height: 15.sp),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.sp),
          child: Wrap(
            spacing: 22.sp,
            runSpacing: 15.sp,
            children: List.generate(data.length, (index) {
              return Column(
                children: [
                  Container(
                    height: 33.8.sp,
                    width: 33.8.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.sp),
                      gradient: ConstantsColor.buttonGradient,
                    ),
                    padding: EdgeInsets.all(10.sp),
                    child: Image.asset(data[index]['image']),
                  ),
                  SizedBox(height: 10.sp),
                  Container(
                    width: 35.sp,
                    child: Text(data[index]['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.sp, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis
                    ),
                  )
                ],
              );
            }),
          ),
        )
      ],
    );
  }



  gradientCard({required double height, required double width, required String title, required List<Map<String, dynamic>> mapData, required bool isBanking}) {
    double cardHeight = height * 0.14;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.sp),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500),),
          SizedBox(height: 15.sp),
          Material(
            color: Colors.transparent,
            elevation: 1,
            shadowColor: Colors.white54,
            borderRadius: BorderRadius.circular(15.sp),
            child: Container(
              height: cardHeight,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.sp),
                gradient: ConstantsColor.buttonGradient
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(mapData.length, (index) {
                  return InkWell(
                    onTap: () {
                      if(isBanking == true) {
                        if(index == 0) {
                          Get.to(IfscScreenView());
                        } else if(index == 1) {
                          Get.to(IfscScreenView());
                        } else if(index == 2) {
                          Get.to(IfscScreenView());
                        } else if(index == 3) {
                          Get.to(IfscScreenView());
                        } else {
                          Get.to(IfscScreenView());
                        }
                      } else {
                        if(index == 0) {
                          Get.to(HomeLoanCalculatorScreenView());
                        } else if(index == 1) {
                          Get.to(HomeLoanCalculatorScreenView());
                        } else if(index == 2) {
                          Get.to(BusinessLoanCalculatorScreenView());
                        } else if(index == 3) {
                          Get.to(RDLoanCalculatorScreenView());
                        } else {
                          Get.to(FDLoanCalculatorScreenView());
                        }
                      }

                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: cardHeight * 0.45,
                          width: cardHeight * 0.45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.sp),
                              gradient: ConstantsColor.pinkGradient
                          ),
                          padding: EdgeInsets.all(3.5.sp),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.sp),
                              color: ConstantsColor.backgroundDarkColor
                            ),
                            padding: EdgeInsets.all(14.sp),
                            child: Image.asset(mapData[index]['image']),
                          ),
                        ),
                        SizedBox(height: 11.sp),
                        Container(
                          width: cardHeight * 0.45,
                          child: Text(mapData[index]['title'], textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5.sp, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis)
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }


}
