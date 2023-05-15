import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    ResponsiveSizer(
        builder: (ctx, orientation, screenType) => GetMaterialApp(
          title: "Application",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Poppins'),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        )
    ),
  );
}
