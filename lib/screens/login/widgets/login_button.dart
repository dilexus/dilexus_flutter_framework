import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';

typedef void OnPressed();

class DxLoginButton extends StatelessWidget {
  final OnPressed onPressed;
  final DxLoginType loginButtonType;
  const DxLoginButton(this.loginButtonType, this.onPressed);
  @override
  Widget build(BuildContext context) {
    _LoginAttributes _loginAttributes = _LoginAttributes();
    _setLoginAttributes(_loginAttributes, context);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        child: RaisedButton.icon(
          icon: Icon(_loginAttributes.iconData, color: Theme.of(context).iconTheme.color),
          padding: EdgeInsets.all(12),
          color: _loginAttributes.color,
          onPressed: onPressed,
          label: Text(
            _loginAttributes.label,
          ),
        ),
      ),
    );
  }

  void _setLoginAttributes(_LoginAttributes loginAttributes, BuildContext context) {
    switch (loginButtonType) {
      case DxLoginType.facebook:
        loginAttributes.label = LocaleKeys.connect_with_facebook.tr();
        loginAttributes.color = HexColor("#4862A3");
        loginAttributes.iconData = FontAwesomeIcons.facebook;
        break;
      case DxLoginType.google:
        loginAttributes.label = LocaleKeys.connect_with_google.tr();
        loginAttributes.color = HexColor("#dd4b39");
        loginAttributes.iconData = FontAwesomeIcons.google;
        break;
      case DxLoginType.apple:
        loginAttributes.label = LocaleKeys.connect_with_apple.tr();
        loginAttributes.color = HexColor("#000000");
        loginAttributes.iconData = FontAwesomeIcons.apple;
        break;
      default:
        loginAttributes.label = LocaleKeys.sign_in.tr();
        loginAttributes.color = Theme.of(context).primaryColor;
        loginAttributes.iconData = FontAwesomeIcons.user;
    }
  }
}

class _LoginAttributes {
  String label;
  Color color;
  IconData iconData;
}
