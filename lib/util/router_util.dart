import 'package:dilexus/imports.dart';

class RouterUtil {
  //static FirebaseAnalytics analytics = FirebaseAnalytics();
  static void push(BuildContext context, Widget screen, AnimationType animationType) {
    //analytics.setCurrentScreen(screenName: screen.toString());
    Navigator.of(context).push(PageRouteTransition(
        animationType: animationType, builder: (context) => ThemeConsumer(child: screen)));
  }

  static void pushNReplace(
      BuildContext context, Widget screen, AnimationType animationType) {
    //analytics.setCurrentScreen(screenName: screen.toString());
    Navigator.of(context).pushReplacement(PageRouteTransition(
        animationType: animationType, builder: (context) => ThemeConsumer(child: screen)));
  }
}
