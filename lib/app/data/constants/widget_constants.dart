import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';

abstract class ConstantsWidgets {

  static List<BoxShadow> boxShadow = const [BoxShadow(offset: Offset(0.8, 0.9), color: Colors.white30, spreadRadius: 0, blurRadius: 0.5)];

  static Widget gradientButton({
    required Function() onTap,
    required String title,
    double? titleSize,
    Widget? suffixChild,
    required double height,
    required double width,
    double? borderRadius
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 60.0)),
          padding: const EdgeInsets.all(0.0),
          elevation: 0.5,
          shadowColor: Colors.white
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: ConstantsColor.buttonGradient,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 60.0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: titleSize ?? 15.5.sp),
              ),
            ),
            suffixChild ?? const SizedBox(),
            SizedBox(width: suffixChild != null ? 15.sp : 0)
          ],
        ),
      ),
    );
  }

  static PreferredSizeWidget appBar({required String title, Function()? onTapBack, bool isShareButtonEnable = true}) {
    return AppBar(
      title: Text(title),
      leading: onTapBack == null ? const SizedBox.shrink() :IconButton(
          onPressed: onTapBack,
          icon: const Icon(CupertinoIcons.arrow_left)
      ),
      leadingWidth: onTapBack == null ? 0 : 56.0,
      actions: [
        isShareButtonEnable ? InkWell(
          child: Image.asset(ConstantsImage.share_icon1, width: 20.sp),
        ) : const SizedBox.shrink(),
        isShareButtonEnable ? SizedBox(width: 15.sp) : const SizedBox.shrink()
      ],
      backgroundColor: ConstantsColor.backgroundDarkColor,
      elevation: 0,
    );
  }


}