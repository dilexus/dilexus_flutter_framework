import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';

typedef void OnBeforeRegister(DxLoginType loginType);
typedef void OnRegistrationSuccess(DxLoginType loginType, User firebaseUser);
typedef void OnRegistrationFailed(DxLoginType loginType, Exception exception);

class DxLoginWidgetRegister extends StatelessWidget {
  final CarouselController carouselController;
  final OnBeforeRegister onBeforeRegister;
  final OnRegistrationSuccess onRegistrationSuccess;
  final OnRegistrationFailed onRegistrationFailed;

  DxLoginWidgetRegister(this.carouselController, this.onBeforeRegister, this.onRegistrationSuccess,
      this.onRegistrationFailed);

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
                ),
                Text(LocaleKeys.sign_up.tr(), style: Theme.of(context).textTheme.headline5),
                Container(
                  padding: EdgeInsets.all(24),
                  child: FormBuilder(
                    key: _fbKey,
                    initialValue: {},
                    child: Column(
                      children: <Widget>[
                        FormBuilderTextField(
                          attribute: "name",
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: tr(LocaleKeys.name),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              )),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                          ],
                        ),
                        FormBuilderTextField(
                          attribute: "email",
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: tr(LocaleKeys.email),
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
                              labelText: tr(LocaleKeys.password),
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
                        FormBuilderTextField(
                          attribute: "confirm_password",
                          obscureText: true,
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: tr(LocaleKeys.confirm_password),
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
                              child: Text(
                                tr(LocaleKeys.sign_up),
                              ),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  String name = _fbKey.currentState.value['name'].trim();
                                  String email = _fbKey.currentState.value['email'].trim();
                                  String password = _fbKey.currentState.value['password'];
                                  String confirmPassword =
                                      _fbKey.currentState.value['confirm_password'];
                                  if (password != confirmPassword) {
                                    DialogUtil().showOKDialog(context, LocaleKeys.app_name.tr(),
                                        LocaleKeys.password_and_confirm_password_does_not_match,
                                        () {
                                      carouselController.jumpToPage(2);
                                    });
                                    return;
                                  }
                                  _onSignUp(name, email, password);
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
                                Text(tr(LocaleKeys.have_an_account) + " "),
                                InkWell(
                                  onTap: () => carouselController.previousPage(),
                                  child: Text(
                                    tr(LocaleKeys.sign_in),
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

  _onSignUp(String name, String email, String password) async {
    onBeforeRegister(DxLoginType.custom);
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      user.updateProfile(displayName: name);
      FirebaseAuth.instance.currentUser..reload();
      logger.info("User Custom Registration was successful. user: ${user.displayName}");
      onRegistrationSuccess(DxLoginType.custom, user);
    } catch (e) {
      logger.error(e.toString());
      onRegistrationFailed(DxLoginType.custom, e);
    }
  }
}
