// Routes
abstract final class Routes {
  static const homeRelative = 'home';
  static const home = '/$homeRelative';
  
  static const login = '/login';
  static const forgotpassword = '/forgotpassword';
  static const resetpassword = '/reset-password';
  static const signup = '/signup';

  // static const coupon = '/$homeRelative/$couponRelative';
  // static const couponRelative = 'coupon';

  static String couponById(String id) => '$home/$id';
  
  static const favoritesRelative = 'favorites';
  static const favorites = '/$favoritesRelative';

  static const scanner = '/$scannerRelative';
  static const scannerRelative = 'scanner';

  static const map = '/$mapRelative';
  static const mapRelative = 'map';

  static const profile = '/$profileRelative';
  static const profileRelative = 'profile';

  static const qrCouponRelative = 'qr-coupon';
  static const qrCoupon = '/$qrCouponRelative';
}
