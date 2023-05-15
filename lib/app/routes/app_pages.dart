import 'package:get/get.dart';

import '../modules/bank_category_screen/bindings/bank_category_screen_binding.dart';
import '../modules/bank_category_screen/views/bank_category_screen_view.dart';
import '../modules/bank_statement_views/bank_detail_screen/bindings/bank_detail_screen_binding.dart';
import '../modules/bank_statement_views/bank_detail_screen/views/bank_detail_screen_view.dart';
import '../modules/bank_statement_views/bank_statement_screen/bindings/bank_statement_screen_binding.dart';
import '../modules/bank_statement_views/bank_statement_screen/views/bank_statement_screen_view.dart';
import '../modules/bottom_navigation_screen/bindings/bottom_navigation_screen_binding.dart';
import '../modules/bottom_navigation_screen/views/bottom_navigation_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_views/home_screen/bindings/home_screen_binding.dart';
import '../modules/home_views/home_screen/views/home_screen_view.dart';
import '../modules/onboarding_screen/bindings/onboarding_screen_binding.dart';
import '../modules/onboarding_screen/views/onboarding_screen_view.dart';
import '../modules/permission_screen/bindings/permission_screen_binding.dart';
import '../modules/permission_screen/views/permission_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/welcome_screen/bindings/welcome_screen_binding.dart';
import '../modules/welcome_screen/views/welcome_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BANK_CATEGORY_SCREEN,
      page: () => const BankCategoryScreenView(),
      binding: BankCategoryScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.PERMISSION_SCREEN,
      page: () => const PermissionScreenView(),
      binding: PermissionScreenBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREEN,
      page: () => const OnboardingScreenView(),
      binding: OnboardingScreenBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME_SCREEN,
      page: () => const WelcomeScreenView(),
      binding: WelcomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME_SCREEN,
      page: () => const HomeScreenView(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAVIGATION_SCREEN,
      page: () => const BottomNavigationScreenView(),
      binding: BottomNavigationScreenBinding(),
    ),
    GetPage(
      name: _Paths.BANK_STATEMENT_SCREEN,
      page: () => const BankStatementScreenView(),
      binding: BankStatementScreenBinding(),
    ),
    GetPage(
      name: _Paths.BANK_DETAIL_SCREEN,
      page: () => const BankDetailScreenView(),
      binding: BankDetailScreenBinding(),
    ),
  ];
}
