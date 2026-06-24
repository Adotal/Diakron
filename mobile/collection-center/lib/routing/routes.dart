// Routes
abstract final class Routes {
  static const homeRelative = 'home';
  static const home = '/$homeRelative';

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

  static const guardRelative = 'guard';
  static const guard = '/$guardRelative';

  static const collections = '/$collectionsRelative';
  static const collectionsRelative = 'collections';

  static const collectionDetails = '$collections/$detailsRelative';
  static const detailsRelative = 'details';

  static const scanner = '/$scannerRelative';
  static const scannerRelative = 'scanner';

  static const stats = '/$statsRelative';
  static const statsRelative = 'stats';

  static const profile = '/$profileRelative';
  static const profileRelative = 'profile';
}
