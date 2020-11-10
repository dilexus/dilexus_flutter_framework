import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';

import 'login_back_button.dart';

typedef void OnPasswordReset(String email);

class DxLoginWidgetResetPassword extends StatelessWidget {
  final CarouselController carouselController;
  final OnPasswordReset onPasswordReset;

  DxLoginWidgetResetPassword(this.carouselController, this.onPasswordReset);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Logger logger = Logger("DxLoginWidgetResetPassword");

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
                  child:
                      DxLoginBackButton(carouselController, () => carouselController.jumpToPage(1)),
                ),
                Text(LocaleKeys.password_reset.tr(), style: Theme.of(context).textTheme.headline5),
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
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              padding: EdgeInsets.all(14),
                              color: Theme.of(context).primaryColor,
                              child: Text(tr(LocaleKeys.reset_the_password)),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  String email = _fbKey.currentState.value['email'].trim();
                                  _onPasswordReset(context, email);
                                }
                              },
                            ),
                          ),
                        ),
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

  _onPasswordReset(BuildContext context, String email) {
    onPasswordReset(email);
    _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
      DialogUtil().showOKDialog(
          context, LocaleKeys.app_name.tr(), LocaleKeys.password_reset_email_sent, () {
        carouselController.jumpToPage(1);
      });
    }).catchError((onError) {
      DialogUtil().showOKDialog(
          context, LocaleKeys.app_name.tr(), LocaleKeys.error_resetting_password, () {});
    });
  }
}
