import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/color_constants.dart';
import 'package:transaction_viewer_app/app/modules/home_views/banking/balance_screen/views/balance_screen_view.dart';
import 'package:transaction_viewer_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

RxInt counterInterstitalAd = 1.obs;
RxInt backCounterInterstitalAd = 1.obs;

class AdService {

  ///BANNER AD
  static BannerAd? bannerAdAdMob;
  static RxBool isBannerAdLoaded = false.obs;

  static Widget bannerAd({required double width, required String currentScreen}) {
    debugPrint('currentScreen bannerAd -> ${currentScreen}');
    debugPrint('configData.value -> ${configData.value}');
    debugPrint('data -> ${configData.value[currentScreen]['banner-type']}');

    if(configData.value[currentScreen]['banner-type'] == 'admob') {
      bannerAdAdMob = BannerAd(
          size: AdSize.banner,
          // adUnitId: data['banner-admob'],
          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              isBannerAdLoaded.value = true;
              print('Banner Loaded Successfully @@@@@@');
            },
            onAdFailedToLoad: (ad, error) {
              isBannerAdLoaded.value = false;
              print('Banner -> ${ad.responseInfo?.adapterResponses}  &  Failed -> $error');
              // ad.dispose();
            },
          ),
          request: const AdRequest()
      );
      bannerAdAdMob?.load();
    }

    return configData.value[currentScreen]['banner-type'] == 'admob' ?
    SizedBox(
      height: 50,
      width: width,
      child: AdWidget(ad: bannerAdAdMob!),
    )
        : FacebookBannerAd(
      bannerSize: BannerSize.STANDARD,
      keepAlive: true,
      placementId: configData.value['banner-facebook'],
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            print("Error Facebook Banner Ad: $value");
            break;
          case BannerAdResult.LOADED:
            print("Loaded Banner Ad: $value");
            break;
          case BannerAdResult.CLICKED:
            print("Clicked Banner Ad: $value");
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            print("Logging Impression Banner Ad: $value");
            break;
        }
      },
    );
  }


  ///NATIVE AD
  static Widget nativeAd({
    required double width,
    required double height,
    required bool smallAd,
    required double radius,
    required String currentScreen
  }) {
    debugPrint('currentScreen nativeAd -> ${currentScreen}');
    debugPrint('configData.value nativeAd -> ${configData}');
    NativeAd? nativeMediumAd;
    RxBool isNativeAdLoaded = false.obs;
    if(configData[currentScreen]['native-type'] == 'admob') {
      nativeMediumAd = NativeAd(
          adUnitId: configData[currentScreen]['native-admob'],
          factoryId: smallAd ? 'listTile' : 'listTileMedium',   // listTile = small Ad , listTileMedium = medium Ad
          listener: NativeAdListener(
              onAdLoaded: (ad) {
                isNativeAdLoaded.value = true;
                print('Native Ad Loaded Successfully @@@@@@');
              },
              onAdFailedToLoad: (ad, error) {
                isNativeAdLoaded.value = false;
                print('Native Ad Loaded failed -> $error');
              }
          ),
          request: const AdRequest()
      );
      nativeMediumAd.load();
    }

    return Obx(() {
      return configData[currentScreen]['native-type'] == 'admob' ?
      ///GOOGLE AD
      isNativeAdLoaded.value == true
          ? AdWidget(ad: nativeMediumAd!)
      // : const Center(child: CircularProgressIndicator(color: ConstantsColor.themeColor))
          : const Center(child: CupertinoActivityIndicator())
      ///FACEBOOK AD
          : configData[currentScreen]['native-type'] == 'facebook' ? FacebookNativeAd(
        placementId: configData['native-facebook'],
        adType: NativeAdType.NATIVE_AD,
        height: height,
        // bannerAdSize: NativeBannerAdSize.HEIGHT_120,
        width: smallAd ? width * 0.43 : width,
        backgroundColor: Colors.blue,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Colors.deepPurple,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        listener: (result, value) {
          print("Native Banner Ad: $result --> $value");
        },
      ) : InkWell(
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () async {
          if(await canLaunchUrl(Uri.parse(configData[currentScreen]['link']))){
            await launchUrl(Uri.parse(configData[currentScreen]['link']));
          } else {
            Fluttertoast.showToast(msg: 'Could not launch url: ${configData[currentScreen]['link']}');
          }
        },
        child: SizedBox(
          // height: 300,
          width: smallAd ? width * 0.6 : width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.network(configData[currentScreen]['image-link'], fit: BoxFit.cover)
          ),
        ),
      );
    });
  }

  ///INTERSTITIAL AD
  InterstitialAd? interstitialAdMob;
  Future interstitialAd({
    String? adId,
    required Function(LoadAdError) onAdFailedToLoad,
    bool isBack = false,
    String? currentScreen,
    BuildContext? dialogCtx,
    dynamic pageToNavigate,
    dynamic argument,
    required bool isCheckBack
  }) async {
    ///isBack is here to prevent to take previousRoute name
    ///isBack = true "PreviousRoute"   isBack = false "CurrentRoute"
    print('interstitial currentScreen -> ${currentScreen}');
    print('interstitial isBack -> ${isBack}');
    print('interstitial configData -> ${configData[currentScreen]}');
    print('interstitial  -> ${configData}');

    if(configData[isBack ? Get.previousRoute : currentScreen]['interstitial-type'] == 'admob') {
      await InterstitialAd.load(
          adUnitId: adId ?? configData[isBack ? Get.previousRoute : currentScreen]['interstitial-admob'],
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
            interstitialAdMob = ad;
            print('interstitialAd LOAD 33 -> $adId');
            Navigator.pop(dialogCtx!);
            if(isCheckBack) {
              Get.back();
            } else {
              Get.to(pageToNavigate, arguments: argument);
            }
            ad.show();
            if (interstitialAdMob == null) {
              print('   to show InterstitialAd before loaded');
            }
          }, onAdFailedToLoad: onAdFailedToLoad
          )
      ).catchError((err) => print('InterstitialAd err -> $err'));
    } else if(configData[isBack ? Get.previousRoute : currentScreen]['interstitial-type'] == 'url') {

      if(await canLaunchUrl(Uri.parse(configData[isBack ? Get.previousRoute : currentScreen]['link']))) {
        await launchUrl(Uri.parse(configData[isBack ? Get.previousRoute : currentScreen]['link']));
        Navigator.pop(dialogCtx!);
        if(isCheckBack) {
          Get.back();
        } else {
          Get.to(pageToNavigate, arguments: argument);
        }
      } else {
        Fluttertoast.showToast(msg: 'Could not launch url: ${configData[isBack ? Get.previousRoute : currentScreen]['link']}');
      }

    } else {
      print('interstitial-facebook -> ${configData['interstitial-facebook']}');
      FacebookInterstitialAd.loadInterstitialAd(
          placementId: configData['interstitial-facebook'],
          listener: (result, value) {
            if(result == InterstitialAdResult.LOADED) {
              Navigator.pop(dialogCtx!);
              if(isCheckBack) {
                Get.back();
              } else {
                Get.to(pageToNavigate, arguments: argument);
              }
              FacebookInterstitialAd.showInterstitialAd(delay: 2000);
            }
          }
      );
    }
  }


  checkCounterAd({required String currentScreen, dynamic pageToNavigate, dynamic argument, required BuildContext context}) {
    if(counterInterstitalAd.value == configData['counter']) {
      counterInterstitalAd.value = 1;

      BuildContext dialogCtx = context;

      showDialog(
          context: dialogCtx,
          builder: (dialogctx) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                content: Row(
                  children: [
                    SizedBox(
                        height: 25.sp,
                        width: 25.sp,
                        child: const CircularProgressIndicator(color: ConstantsColor.backgroundDarkColor)
                    ),
                    const Spacer(),
                    Text('Please Wait...', style: TextStyle(fontSize: 16.5.sp)),
                    const Spacer(),
                  ],
                ),
              ),
            );
          }
      );

      interstitialAd(
          isCheckBack: false,
          onAdFailedToLoad: (error) {
            interstitialAdMob = null;
            interstitialAd(
                isCheckBack: false,
                adId: configData['interstitial-admob'],
                onAdFailedToLoad: (loadAdError) {
                  counterInterstitalAd.value = 1;
                },
                currentScreen: currentScreen,
                dialogCtx: dialogCtx,
                argument: argument,
                pageToNavigate: pageToNavigate
            );
          },
          currentScreen: currentScreen,
          dialogCtx: dialogCtx,
          argument: argument,
          pageToNavigate: pageToNavigate
      );
    } else {
      if(pageToNavigate != null) {
        Get.to(pageToNavigate, arguments: argument);
      }
      counterInterstitalAd.value++;
    }
  }

  checkBackCounterAd({required String currentScreen, required BuildContext context}) {
    if(backCounterInterstitalAd.value == configData['back_counter']) {
      backCounterInterstitalAd.value = 1;
      BuildContext dialogCtx = context;

      showDialog(
          context: dialogCtx,
          builder: (dialogctx) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                content: Row(
                  children: [
                    SizedBox(
                        height: 25.sp,
                        width: 25.sp,
                        child: const CircularProgressIndicator(color: ConstantsColor.backgroundDarkColor)
                    ),
                    const Spacer(),
                    Text('Please Wait...', style: TextStyle(fontSize: 16.5.sp)),
                    const Spacer(),
                  ],
                ),
              ),
            );
          }
      );

      interstitialAd(
          isCheckBack: true,
          isBack: currentScreen == '/HomeScreenView' ? false : true,
          onAdFailedToLoad: (error) {
            interstitialAdMob = null;
            interstitialAd(
                isCheckBack: true,
                isBack: currentScreen == '/HomeScreenView' ? false : true,
                adId: configData['interstitial-admob'],
                onAdFailedToLoad: (loadAdError ) {
                  backCounterInterstitalAd.value = 1;
                }
            );
          },
          currentScreen: currentScreen,
          dialogCtx: dialogCtx,
      );
    } else {
      Get.back();
      backCounterInterstitalAd.value++;
    }
  }

}