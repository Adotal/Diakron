// Routes
abstract final class Routes {
  static const login = '/login';
  static const forgotpassword = '/forgotpassword';
  static const resetpassword = '/reset-password';
  static const signup = '/signup';

  static const home = '/home';
  static const map = '/map';
  static const users = '/users';

  static const incentives = '/$incentivesRelative';
  static const settings = '/settings';

  // CRUD 5 type of users
  static const admins = '$users/$adminsRelative';
  static const adminsRelative = 'admins';
  static String adminById(String id) => '$admins/$id';

  static const collectionCenters = '$users/$collectionCentersRelative';
  static const collectionCentersRelative = 'collection-centers';
  static String collectionCenterById(String id) => '$collectionCenters/$id';

  static const participants = '$users/$participantsRelative';
  static const participantsRelative = 'participants';
  static String participantById(String id) => '$participants/$id';

  static const collectors = '$users/$collectorsRelative';
  static const collectorsRelative = 'collectors';
  static String collectorById(String id) => '$collectors/$id';

  static const stores = '$users/$storesRelative';
  static const storesRelative = 'stores';
  static String storeById(String id) => '$stores/$id';

  static const incentivesRelative = 'incentives';
  static const incentiveDetails = '$incentives/$detailsRelative';

  static const detailsRelative = 'details';
}
