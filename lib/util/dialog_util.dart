import 'package:dilexus/generated/locale_keys.g.dart';
import 'package:dilexus/imports.dart';
import 'package:dilexus/screens/login/widgets/login_widget_loading.dart';
import 'package:dilexus/util/enums/share_type.dart';

typedef void OnShare(DxShareType shareType);

class DialogUtil {
  static final DialogUtil _singleton = DialogUtil._internal();

  factory DialogUtil() {
    return _singleton;
  }

  DialogUtil._internal();

  void showOKDialog(BuildContext context, String title, String message, Function onOKTap) {
    Alert(
      context: context,
      title: title,
      desc: message,
      style: AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
          titleStyle: Theme.of(context).textTheme.headline5,
          descStyle: Theme.of(context).textTheme.bodyText1),
      buttons: [
        DialogButton(
          color: Theme.of(context).buttonColor,
          child: Text(
            tr(LocaleKeys.ok),
          ),
          onPressed: () {
            Navigator.pop(context);
            onOKTap();
          },
        ),
      ],
    ).show();
  }

  void showConfirmDialog(
      BuildContext context, String title, String message, Function onYesTap, Function onNoTap) {
    Alert(
      context: context,
      title: title,
      desc: message,
      style: AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
          titleStyle: Theme.of(context).textTheme.headline5,
          descStyle: Theme.of(context).textTheme.bodyText1),
      buttons: [
        DialogButton(
          color: Theme.of(context).buttonColor,
          child: Text(
            tr(LocaleKeys.yes),
          ),
          onPressed: () {
            Navigator.pop(context);
            onYesTap();
          },
        ),
        DialogButton(
          color: Theme.of(context).buttonColor,
          child: Text(
            tr(LocaleKeys.no),
          ),
          onPressed: () {
            Navigator.pop(context);
            onNoTap();
          },
        )
      ],
    ).show();
  }

  void loadLoginLoading(
      CarouselController carouselController,
      DxLoginWidgetLoadingMessage loadingMessage,
      int initialPage,
      IconData icon,
      String message,
      String progressMessage) {
    carouselController.jumpToPage(5);
    loadingMessage.carouselController = carouselController;
    loadingMessage.icon = icon;
    loadingMessage.initialPage = initialPage;
    loadingMessage.message = message;
    loadingMessage.progressMessage = progressMessage;
  }

  void showRatingDialog(
      BuildContext context, String title, String message, Function onOKTap, Function onCancelTap) {
    double selectedRating = 5.0;
    Alert(
      context: context,
      title: title,
      desc: message,
      style: AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
          titleStyle: Theme.of(context).textTheme.headline5,
          descStyle: Theme.of(context).textTheme.bodyText1),
      content: Container(
        padding: EdgeInsets.all(8),
        child: RatingBar(
          initialRating: selectedRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 30.0,
          unratedColor: Colors.grey,
          itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.white,
          ),
          onRatingUpdate: (rating) {
            selectedRating = rating;
          },
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            tr(LocaleKeys.ok),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.pop(context);
            onOKTap(selectedRating);
          },
        ),
        DialogButton(
          child: Text(
            tr(LocaleKeys.cancel),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.pop(context);
            onCancelTap();
          },
        )
      ],
    ).show();
  }

  void showShareDialog(
      BuildContext context, String title, String message, OnShare onShare, Function onCancelTap) {
    Alert(
      context: context,
      title: title,
      desc: message,
      style: AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
          titleStyle: Theme.of(context).textTheme.headline5,
          descStyle: Theme.of(context).textTheme.bodyText1),
      content: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onShare(DxShareType.facebook);
              },
              child: Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.facebook, color: Colors.white),
                    SizedBox(width: 30),
                    Text(LocaleKeys.facebook.tr())
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onShare(DxShareType.whatsapp);
              },
              child: Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    SizedBox(width: 30),
                    Text(LocaleKeys.whatsapp.tr())
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onShare(DxShareType.twitter);
              },
              child: Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.twitter, color: Colors.white),
                    SizedBox(width: 30),
                    Text(LocaleKeys.twitter.tr())
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onShare(DxShareType.other);
              },
              child: Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.envelope, color: Colors.white),
                    SizedBox(width: 30),
                    Text(LocaleKeys.other_social.tr())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
            child: Text(
              tr(LocaleKeys.cancel),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              onCancelTap();
            },
            color: Theme.of(context).buttonColor)
      ],
    ).show();
  }
}
