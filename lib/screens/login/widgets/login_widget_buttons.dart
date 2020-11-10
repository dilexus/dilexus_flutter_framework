import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';

import 'login_button.dart';

typedef void OnBeforeRegister(DxLoginType loginType);
typedef void OnRegistrationSuccess(DxLoginType loginType, User user);
typedef void OnRegistrationFailed(DxLoginType loginType, Exception exception);

class DxLoginWidgetButtons extends StatelessWidget {
  final Logger logger = Logger("DxLoginWidgetButtons");

  final OnBeforeRegister onBeforeLogin;
  final OnRegistrationSuccess onLoginSuccess;
  final OnRegistrationFailed onLoginFailed;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final CarouselController carouselController;

  DxLoginWidgetButtons(
      this.carouselController, this.onBeforeLogin, this.onLoginSuccess, this.onLoginFailed);

  @override
  Widget build(BuildContext context) {
    List<String> loginTypes = FlavorConfig.instance.variables["loginTypes"];
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 32,
              ),
              Text(LocaleKeys.sign_in.tr(), style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (loginTypes?.contains("facebook"))
                    DxLoginButton(DxLoginType.facebook, _onFacebookSignIn),
                  if (loginTypes.contains("google"))
                    DxLoginButton(DxLoginType.google, _onGoogleSignIn),
                  if (loginTypes.contains("apple.ios") && Platform.isIOS ||
                      loginTypes.contains("apple"))
                    DxLoginButton(DxLoginType.apple, _onAppleSignIn),
                  if (loginTypes.contains("custom"))
                    DxLoginButton(DxLoginType.custom, () => carouselController.nextPage()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onGoogleSignIn() async {
    onBeforeLogin(DxLoginType.google);
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final User user = (await firebaseAuth.signInWithCredential(credential)).user;
      logger.info("User signed in with Google was successful. user: ${user.displayName}");
      onLoginSuccess(DxLoginType.google, user);
    } catch (e) {
      logger.error(e.toString());
      onLoginFailed(DxLoginType.google, e);
    }
  }

  Future<void> _onFacebookSignIn() async {
    onBeforeLogin(DxLoginType.facebook);
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
        try {
          User user = (await firebaseAuth.signInWithCredential(credential)).user;
          logger.info("User signed in with Facebook was successful. user: ${user.displayName}");
          onLoginSuccess(DxLoginType.facebook, user);
        } catch (e) {
          logger.error(e.toString());
          onLoginFailed(DxLoginType.facebook, e);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        logger.error(result.errorMessage);
        onLoginFailed(DxLoginType.facebook, Exception(result.errorMessage));
        break;
      case FacebookLoginStatus.error:
        logger.error(result.errorMessage);
        onLoginFailed(DxLoginType.facebook, Exception(result.errorMessage));
        break;
    }
  }

  Future<void> _onAppleSignIn() async {
    onBeforeLogin(DxLoginType.apple);

    final nonce = AuthUtil().createNonce(32);

    final appleCredentials = Platform.isIOS
        ? await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: sha256.convert(utf8.encode(nonce)).toString(),
          )
        : await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              redirectUri: Uri.parse(FlavorConfig.instance.variables["appleRedirectURL"]),
              clientId: FlavorConfig.instance.variables["appleServiceID"],
            ),
            nonce: sha256.convert(utf8.encode(nonce)).toString(),
          );

    var credentials = OAuthCredential(
      providerId: "apple.com",
      signInMethod: "oauth",
      accessToken: appleCredentials.identityToken,
      idToken: appleCredentials.identityToken,
      rawNonce: nonce,
    );

    try {
      User user = (await firebaseAuth.signInWithCredential(credentials)).user;
      if (appleCredentials.givenName != null || appleCredentials.familyName != null) {
        user
            .updateProfile(
                displayName:
                    "${appleCredentials.givenName ?? ""} ${appleCredentials.familyName ?? ""}")
            .then((value) {
          FirebaseAuth.instance.currentUser..reload();
          user = FirebaseAuth.instance.currentUser;
          logger.info("User signed in with Apple was successful. user: ${user.displayName}");
          onLoginSuccess(DxLoginType.apple, user);
        });
      } else {
        logger.info("User signed in with Apple was successful. user: ${user.displayName}");
        onLoginSuccess(DxLoginType.apple, user);
      }
    } catch (e) {
      logger.error(e.toString());
      onLoginFailed(DxLoginType.apple, e);
    }
  }
}
