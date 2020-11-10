import 'package:dilexus/imports.dart';

class AppUtil {
  static Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  static void setAppTheme(AppTheme appTheme, BuildContext context) {
    if (appTheme == AppTheme.dark()) {
      ThemeProvider.controllerOf(context).setTheme('dark');
    } else {
      ThemeProvider.controllerOf(context).setTheme('light');
    }
  }

  static AppTheme getAppTheme(BuildContext context) {
    String id = ThemeProvider.themeOf(context).id;
    if (id == 'dark_theme') {
      return AppTheme.dark();
    }
    return AppTheme.light();
  }
}
