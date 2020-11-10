import 'dart:math';

import 'package:dilexus/imports.dart';

class AuthUtil {
  static final AuthUtil _singleton = AuthUtil._internal();

  factory AuthUtil() {
    return _singleton;
  }

  AuthUtil._internal();

  Future<AuthUser> getAuthUserFromFirebaseUser(User user) async {
    return AuthUser(user.uid, user.displayName, user.photoURL, user.email, user.isAnonymous,
        user.emailVerified, await user.getIdToken(true), user.refreshToken);
  }

  String createNonce(int length) {
    final random = Random();
    final charCodes = List<int>.generate(length, (_) {
      int codeUnit;
      switch (random.nextInt(3)) {
        case 0:
          codeUnit = random.nextInt(10) + 48;
          break;
        case 1:
          codeUnit = random.nextInt(26) + 65;
          break;
        case 2:
          codeUnit = random.nextInt(26) + 97;
          break;
      }
      return codeUnit;
    });
    return String.fromCharCodes(charCodes);
  }
}
