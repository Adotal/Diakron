// Routes
abstract final class Routes {
  static const homeRelative = 'home';
  static const home = '/$homeRelative';

  static const guardRelative = 'guard';
  static const guard = '/$guardRelative';

  static const login = '/login';
  static const forgotpassword = '/forgotpassword';
  static const resetpassword = '/reset-password';
  static const signup = '/signup';
  static const uploadDataRoot = '/upload_data/';
  static const uploadData = '/upload_data/step1';
  static const uploadData2 = '/upload_data/step2';
  static const uploadData3 = '/upload_data/step3';
  static const privacyPolicy = '/upload_data/privacy-policy';
  static const waitingApproval = '/waiting_approval';

  static const profile = '/$storeRelative';
  static const storeRelative = 'store';

  static const scanner = '/$scannerRelative';
  static const scannerRelative = 'scanner';

  static const activity = '/$activityRelative';
  static const activityRelative = 'activity';

  static const coupons = '/$couponsRelative';
  static const couponsRelative = 'coupons';
  static const createRelative = 'create';
  static const createCoupon = '/$couponsRelative/$createRelative';
  static String couponById(String id) => '$coupons/$id';
}
