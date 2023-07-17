import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';

class Demoo extends StatefulWidget {
  const Demoo({Key? key}) : super(key: key);

  @override
  State<Demoo> createState() => _DemooState();
}

class _DemooState extends State<Demoo> {
  @override
  Widget build(BuildContext context) {

    double width = 100.w;

    return Scaffold(
      body: Container(
        height: 100.h,
        width: width,
        margin: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3.5.sp)
        ),
        child: Column(
            children: List.generate(3, (index) {
              return Column(
                children: [
                  Text('APR 20', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),),
                  Container(
                    height: 40.w,
                    width: width,
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20.sp);
                        },
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            constraints: BoxConstraints(
                              minHeight: 20.sp,
                            ),
                            width: width,
                            child: Row(
                                children: [
                                  Container(
                                    width: width * 0.2,
                                    alignment: Alignment.center,
                                    child: Text('20 Apr')
                                  ),
                                  Container(width: 1, color: Colors.black, height: double.infinity),
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.only(left: 15.sp),
                                        child: Text('UPI Amazon',
                                          style: TextStyle(overflow: TextOverflow.ellipsis),)
                                    ),
                                  ),
                                  Container(width: 1, color: Colors.black, height: double.infinity),
                                  Container(
                                      width: width * 0.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: 12.sp),
                                      child: Text('2000000000000000022222222222', maxLines: 2)
                                  ),
                                ]
                            ),
                          );
                        }
                    ),
                  ),
                  Divider(thickness: 3.5.sp, color: Colors.black),
                  SizedBox(height: 12.sp)
                ],
              );
            }
              // }
            )
        ),
      ),
    );
  }
}
