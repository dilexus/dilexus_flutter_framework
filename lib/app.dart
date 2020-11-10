import 'package:dilexus/imports.dart';

typedef void OnAppInitialize();

class DxApp extends StatelessWidget {
  final Widget homeScreen;
  final OnAppInitialize onAppInitialize;
  DxApp(this.homeScreen, this.onAppInitialize);

  @override
  Widget build(BuildContext context) {
    onAppInitialize();
    return EasyLocalization(
      supportedLocales: FlavorConfig.instance.variables["supportedLocales"],
      useOnlyLangCode: FlavorConfig.instance.variables["useOnlyLangCode"],
      startLocale: FlavorConfig.instance.variables["startLocale"],
      path: FlavorConfig.instance.variables["langPath"],
      child: FlavorBanner(
        child: ThemeProvider(
          defaultThemeId: FlavorConfig.instance.variables["defaultTheme"],
          themes: FlavorConfig.instance.variables["appThemes"],
          saveThemesOnChange: FlavorConfig.instance.variables["saveThemesOnChange"],
          loadThemeOnInit: FlavorConfig.instance.variables["loadThemeOnInit"],
          child: ThemeConsumer(
            child: Builder(
                builder: (themeContext) => MaterialApp(
                      theme: ThemeProvider.themeOf(themeContext).data,
                      debugShowCheckedModeBanner:
                          FlavorConfig.instance.variables["showDebugBanner"],
                      home: homeScreen,
                    )),
          ),
        ),
      ),
    );
  }
}
