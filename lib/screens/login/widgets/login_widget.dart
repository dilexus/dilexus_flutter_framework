import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';
import 'package:dilexus/screens/login/widgets/login_widget_loading.dart';
import 'package:dilexus/screens/login/widgets/login_widget_reset_password.dart';
import 'package:dilexus/util/dialog_util.dart';

import 'login_widget_buttons.dart';
import 'login_widget_email_verify.dart';
import 'login_widget_login.dart';
import 'login_widget_register.dart';

typedef void OnAfterLogin(DxLoginType loginType);
typedef void OnAfterEmailVerify();

class DxLoginWidget extends StatefulWidget {
  final OnAfterLogin onAfterLogin;
  final OnAfterEmailVerify onAfterEmailVerify;

  DxLoginWidget(this.onAfterLogin, this.onAfterEmailVerify);

  @override
  _DxLoginWidgetState createState() => _DxLoginWidgetState();
}

class _DxLoginWidgetState extends State<DxLoginWidget> {
  final Logger logger = Logger("DxLoginWidget");
  AppContextProvider appContextProvider;
  final CarouselController carouselController = CarouselController();
  final DxLoginWidgetLoadingMessage loadingMessage = DxLoginWidgetLoadingMessage();
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    appContextProvider = Provider.of<AppContextProvider>(context);
    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
          height: double.infinity,
          initialPage: 0,
          enableInfiniteScroll: false,
          viewportFraction: 1.0,
          scrollPhysics: NeverScrollableScrollPhysics()),
      items: [
        DxLoginWidgetButtons(carouselController, _onBeforeLogin, _onLoginSuccess, _onLoginFailed),
        DxLoginWidgetLogin(carouselController, _onBeforeLogin, _onLoginSuccess, _onLoginFailed),
        DxLoginWidgetRegister(
            carouselController, _onBeforeRegister, _onRegistrationSuccess, _onRegistrationFailed),
        DxLoginWidgetEmailVerify(carouselController, widget.onAfterEmailVerify),
        DxLoginWidgetResetPassword(carouselController, _onPasswordReset),
        DxLoginWidgetLoading(carouselController, loadingMessage)
      ],
    );
  }

  void _onBeforeLogin(DxLoginType loginType) {
    int initialPage = 0;
    if (loginType == DxLoginType.custom) {
      initialPage = 1;
    }
    DialogUtil().loadLoginLoading(carouselController, loadingMessage, initialPage, Icons.login,
        LocaleKeys.sign_in_up.tr(), LocaleKeys.please_wait.tr());
  }

  void _onBeforeRegister(DxLoginType loginType) {
    int initialPage = 0;
    if (loginType == DxLoginType.custom) {
      initialPage = 1;
    }
    DialogUtil().loadLoginLoading(carouselController, loadingMessage, initialPage, Icons.login,
        LocaleKeys.sign_in_up.tr(), LocaleKeys.please_wait.tr());
  }

  Future<void> _onLoginSuccess(DxLoginType loginType, User user) async {
    logger.debug("User signed in with $loginType was successful. user: ${user.displayName}");
    AuthUser authUser = await AuthUtil().getAuthUserFromFirebaseUser(user);
    appContextProvider.authUser = authUser;
    if (!user.emailVerified) {
      logger.debug("User's email is not verified");
      user.sendEmailVerification();
      carouselController.jumpToPage(3);
    } else {
      widget.onAfterLogin(loginType);
    }
  }

  void _onLoginFailed(DxLoginType loginType, Exception ex) {
    loadingMessage.dismiss();
    logger.error("User signed in with $loginType was unsuccessful");
    if (ex is FirebaseAuthException) {
      switch (ex.code) {
        case "account-exists-with-different-credential":
          DialogUtil().showOKDialog(context, LocaleKeys.app_name.tr(),
              LocaleKeys.error_account_exist_with_different_credentials.tr(), () {});
          break;
        case "wrong-password":
        case "user-not-found":
          DialogUtil().showOKDialog(
              context, LocaleKeys.app_name.tr(), LocaleKeys.error_wrong_password.tr(), () {});
          break;
        default:
          DialogUtil().showOKDialog(
              context, LocaleKeys.app_name.tr(), LocaleKeys.error_login_error.tr(), () {});
      }
    }
  }

  void _onRegistrationSuccess(DxLoginType loginType, User user) {
    logger.debug("User signed up in with $loginType was successful");
    _onLoginSuccess(loginType, user);
  }

  void _onRegistrationFailed(DxLoginType loginType, Exception ex) {
    logger.error("User signed up in with $loginType was unsuccessful");
    if (ex != null) {
      DialogUtil().showOKDialog(
          context, LocaleKeys.app_name.tr(), LocaleKeys.error_registration_error.tr(), () {});
    }
  }

  void _onPasswordReset(String email) {}
}
