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
      width: width * 0.8,
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
    String? currentScreen
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
            ad.show();
            if (interstitialAdMob == null) {
              print('attempt to show InterstitialAd before loaded');
            }
            Future.delayed(const Duration(milliseconds: 1000), () {
              print('ad popup close');
              Get.back();
            });
          }, onAdFailedToLoad: onAdFailedToLoad
          )
      ).catchError((err) => print('InterstitialAd err -> $err'));
    } else if(configData[isBack ? Get.previousRoute : currentScreen]['interstitial-type'] == 'url') {

      if(await canLaunchUrl(Uri.parse(configData[isBack ? Get.previousRoute : currentScreen]['link']))) {
        await launchUrl(Uri.parse(configData[isBack ? Get.previousRoute : currentScreen]['link']));
      } else {
        Fluttertoast.showToast(msg: 'Could not launch url: ${configData[isBack ? Get.previousRoute : currentScreen]['link']}');
      }
      Future.delayed(const Duration(milliseconds: 1000), () => Get.back());

    } else {
      FacebookInterstitialAd.loadInterstitialAd(
          placementId: configData['interstitial-facebook'],
          listener: (result, value) {
            if(result == InterstitialAdResult.LOADED) {
              FacebookInterstitialAd.showInterstitialAd(delay: 2000).then((value) =>
                  Future.delayed(const Duration(milliseconds: 1000), () => Get.back()));
            }
          }
      );
    }
  }


  checkCounterAd({required String currentScreen}) {
    print('counterr -> $counterInterstitalAd');
    print('@@ -> ${configData['counter']}');


    print('interstitial @@ currentScreen -> ${currentScreen}');
    print('interstitial @@ configData -> ${configData}');

    return Future.delayed(const Duration(milliseconds: 1200), () {
      if(counterInterstitalAd.value == configData['counter']) {
        counterInterstitalAd.value = 1;

        Get.dialog(
            barrierDismissible: false,
            WillPopScope(
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
            )
        );
        Future.delayed(const Duration(milliseconds: 1000), () {
          interstitialAd(onAdFailedToLoad: (error) {
            interstitialAdMob = null;
            interstitialAd(
                adId: configData['interstitial-admob'],
                onAdFailedToLoad: (loadAdError) {
                  counterInterstitalAd.value = 1;
                  Future.delayed(const Duration(milliseconds: 1000), () => Get.back());
                }
            );
          });
        });
      } else {
        counterInterstitalAd.value++;
      }
    });
  }

  checkBackCounterAd({required String currentScreen}) {
    print('backCounter -> $backCounterInterstitalAd');
    print('backCounter@@ -> ${configData['back_counter']}');
    Future.delayed(const Duration(milliseconds: 1200), () {
      if(backCounterInterstitalAd.value == configData['back_counter']) {
        backCounterInterstitalAd.value = 1;
        Get.dialog(
            barrierDismissible: false,
            WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                content: Row(
                  children: [
                    SizedBox(
                        height: 25.sp,
                        width: 25.sp,
                        child: const CircularProgressIndicator(color: Colors.white)
                    ),
                    const Spacer(),
                    Text('Please Wait...', style: TextStyle(fontSize: 16.5.sp)),
                    const Spacer(),
                  ],
                ),
              ),
            )
        );
        Future.delayed(const Duration(milliseconds: 1000), () {
          interstitialAd(
              isBack: currentScreen == '/HomeScreenView' ? false : true,
              onAdFailedToLoad: (error) {
                interstitialAdMob = null;
                interstitialAd(
                  isBack: currentScreen == '/HomeScreenView' ? false : true,
                  adId: configData['interstitial-admob'],
                  onAdFailedToLoad: (loadAdError ) {
                    backCounterInterstitalAd.value = 1;
                    Future.delayed(const Duration(milliseconds: 1000), () => Get.back());
                  },
                );
              });
        });
      } else {
        backCounterInterstitalAd.value++;
      }
    });
  }

}