// Routes
abstract final class Routes {

  static const homeRelative = 'home';
  static const home = '/$homeRelative';

  static const login = '/login';
  static const forgotpassword = '/forgotpassword';
  static const resetpassword = '/reset-password';
  static const signup = '/signup';

  static const collections = '/$collectionsRelative';
  static const collectionsRelative = 'collections';

  static const collectionDetails = '$collections/$detailsRelative';
  static const detailsRelative = 'details';

  static String collectionQRById(String id) => '$collections/$id';

  static const scanner = '/$scannerRelative';
  static const scannerRelative = 'scanner';

  static const map = '/$mapRelative';
  static const mapRelative = 'map';

  static const profile = '/$profileRelative';
  static const profileRelative = 'profile';

}
