import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';

import 'login_back_button.dart';

class DxLoginWidgetEmailVerify extends StatefulWidget {
  final OnAfterEmailVerify onAfterEmailVerify;
  final CarouselController carouselController;

  DxLoginWidgetEmailVerify(this.carouselController, this.onAfterEmailVerify);

  @override
  _DxLoginWidgetEmailVerifyState createState() => _DxLoginWidgetEmailVerifyState();
}

class _DxLoginWidgetEmailVerifyState extends State<DxLoginWidgetEmailVerify> {
  Timer timer;
  final Logger logger = Logger("EmailVerifyFragment");
  bool isEmailVerified = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 32,
                child: DxLoginBackButton(
                    widget.carouselController, () => widget.carouselController.jumpToPage(0)),
              ),
              Text(LocaleKeys.email_verification.tr(),
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isEmailVerified
                        ? Text(
                            LocaleKeys.your_email_is_verified_message
                                .tr(args: [tr(LocaleKeys.app_name)]),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            LocaleKeys.your_email_is_not_verified_message
                                .tr(args: [tr(LocaleKeys.app_name)]),
                            textAlign: TextAlign.center,
                          ),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          padding: EdgeInsets.all(14),
                          color: Theme.of(context).primaryColor,
                          child: Text(isEmailVerified
                              ? tr(LocaleKeys.next)
                              : tr(LocaleKeys.verifying_your_email)),
                          onPressed: !isEmailVerified
                              ? null
                              : () {
                                  widget.onAfterEmailVerify();
                                },
                        ),
                      ),
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      FirebaseAuth.instance.currentUser..reload();
      var user = FirebaseAuth.instance.currentUser;
      if (user.emailVerified) {
        setState(() {
          isEmailVerified = true;
        });
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }
}
