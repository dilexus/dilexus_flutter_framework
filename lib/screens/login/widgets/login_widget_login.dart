import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';

import 'login_back_button.dart';

typedef void OnBeforeLogin(DxLoginType loginType);
typedef void OnLoginSuccess(DxLoginType loginType, User firebaseUser);
typedef void OnLoginFailed(DxLoginType loginType, Exception exception);

class DxLoginWidgetLogin extends StatelessWidget {
  final CarouselController carouselController;
  final OnBeforeLogin onBeforeLogin;
  final OnLoginSuccess onLoginSuccess;
  final OnLoginFailed onLoginFailed;

  DxLoginWidgetLogin(
      this.carouselController, this.onBeforeLogin, this.onLoginSuccess, this.onLoginFailed);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Logger logger = Logger("DxLoginWidgetLogin");

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Column(
              children: [
                Container(
                  height: 32,
                  child: DxLoginBackButton(
                      carouselController, () => carouselController.previousPage()),
                ),
                Text(LocaleKeys.sign_in.tr(), style: Theme.of(context).textTheme.headline5),
                Container(
                  padding: EdgeInsets.all(24),
                  child: FormBuilder(
                    key: _fbKey,
                    initialValue: {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FormBuilderTextField(
                          attribute: "email",
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: LocaleKeys.email.tr(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              )),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ],
                        ),
                        FormBuilderTextField(
                          attribute: "password",
                          obscureText: true,
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: LocaleKeys.password.tr(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              )),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(6),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              padding: EdgeInsets.all(14),
                              color: Theme.of(context).primaryColor,
                              child: Text(tr(LocaleKeys.sign_in)),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  String email = _fbKey.currentState.value['email'].trim();
                                  String password = _fbKey.currentState.value['password'];
                                  _onSignIn(email, password);
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(tr(LocaleKeys.dont_have_an_account)),
                                InkWell(
                                  onTap: () => carouselController.nextPage(),
                                  child: Text(
                                    LocaleKeys.sign_up.tr(),
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                )
                              ],
                            )),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  tr(LocaleKeys.forgot_your_password),
                                ),
                                InkWell(
                                  onTap: () => carouselController.jumpToPage(4),
                                  child: Text(
                                    LocaleKeys.reset.tr(),
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                )
                              ],
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onSignIn(String email, String password) async {
    onBeforeLogin(DxLoginType.custom);
    try {
      UserCredential result =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      logger.info("User Custom Login was successful. user: ${user.displayName}");
      onLoginSuccess(DxLoginType.custom, user);
    } catch (e) {
      logger.error(e.toString());
      onLoginFailed(DxLoginType.custom, e);
    }
  }
}
