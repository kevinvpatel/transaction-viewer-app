import 'package:get/get.dart';
import '../modules/bank_statement_views/bank_detail_screen/bindings/bank_detail_screen_binding.dart';
import '../modules/bank_statement_views/bank_detail_screen/views/bank_detail_screen_view.dart';
import '../modules/bank_statement_views/bank_statement_screen/bindings/bank_statement_screen_binding.dart';
import '../modules/bank_statement_views/bank_statement_screen/views/bank_statement_screen_view.dart';
import '../modules/bill_payment_screen/bindings/bill_payment_screen_binding.dart';
import '../modules/bill_payment_screen/views/bill_payment_screen_view.dart';
import '../modules/bottom_navigation_screen/bindings/bottom_navigation_screen_binding.dart';
import '../modules/bottom_navigation_screen/views/bottom_navigation_screen_view.dart';
import '../modules/home_views/banking/balance_screen/bindings/balance_screen_binding.dart';
import '../modules/home_views/banking/balance_screen/views/balance_screen_view.dart';
import '../modules/home_views/banking/holiday_screen/bindings/holiday_screen_binding.dart';
import '../modules/home_views/banking/holiday_screen/views/holiday_screen_view.dart';
import '../modules/home_views/banking/ifsc_screen/bindings/ifsc_screen_binding.dart';
import '../modules/home_views/banking/ifsc_screen/views/ifsc_screen_view.dart';
import '../modules/home_views/banking/ussd_bank_list_screen_view/bindings/ussd_bank_list_screen_view_binding.dart';
import '../modules/home_views/banking/ussd_bank_list_screen_view/views/ussd_bank_list_screen_view_view.dart';
import '../modules/home_views/calculators/currency_converter_screen/bindings/currency_converter_screen_binding.dart';
import '../modules/home_views/calculators/currency_converter_screen/views/currency_converter_screen_view.dart';
import '../modules/home_views/calculators/home_loan_calculator_screen/bindings/home_loan_calculator_screen_binding.dart';
import '../modules/home_views/calculators/home_loan_calculator_screen/views/home_loan_calculator_screen_view.dart';
import '../modules/home_views/credit_and_loan_screen/car_loan_screen/bindings/car_loan_screen_binding.dart';
import '../modules/home_views/credit_and_loan_screen/car_loan_screen/views/car_loan_screen_view.dart';
import '../modules/home_views/credit_and_loan_screen/credit_card_screen/bindings/credit_card_screen_binding.dart';
import '../modules/home_views/credit_and_loan_screen/credit_card_screen/views/credit_card_screen_view.dart';
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
    GetPage(
      name: _Paths.IFSC_SCREEN,
      page: () => const IfscScreenView(),
      binding: IfscScreenBinding(),
    ),
    GetPage(
      name: _Paths.BILL_PAYMENT_SCREEN,
      page: () => const BillPaymentScreenView(),
      binding: BillPaymentScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME_LOAN_CALCULATOR_SCREEN,
      page: () => const HomeLoanCalculatorScreenView(),
      binding: HomeLoanCalculatorScreenBinding(),
    ),
    GetPage(
      name: _Paths.CURRENCY_CONVERTER_SCREEN,
      page: () => const CurrencyConverterScreenView(),
      binding: CurrencyConverterScreenBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_CARD_SCREEN,
      page: () => const CreditCardScreenView(),
      binding: CreditCardScreenBinding(),
    ),
    GetPage(
      name: _Paths.CAR_LOAN_SCREEN,
      page: () => const CarLoanScreenView(),
      binding: CarLoanScreenBinding(),
    ),
    GetPage(
      name: _Paths.BALANCE_SCREEN,
      page: () => const BalanceScreenView(),
      binding: BalanceScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOLIDAY_SCREEN,
      page: () => const HolidayScreenView(),
      binding: HolidayScreenBinding(),
    ),
    GetPage(
      name: _Paths.USSD_BANK_LIST_SCREEN_VIEW,
      page: () => const UssdBankListScreenViewView(),
      binding: UssdBankListScreenViewBinding(),
    ),
  ];
}
