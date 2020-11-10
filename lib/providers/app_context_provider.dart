import 'package:dilexus/imports.dart';

class AppContextProvider with ChangeNotifier {
  PackageInfo _packageInfo;
  PackageInfo get packageInfo => _packageInfo;
  set packageInfo(PackageInfo packageInfo) {
    _packageInfo = packageInfo;
    notifyListeners();
  }

  AuthUser _authUser;
  AuthUser get authUser => _authUser;
  set authUser(AuthUser authUser) {
    _authUser = authUser;
    notifyListeners();
  }
}
