
import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:education_systems_mobile/pages/root_page.dart';
import 'package:education_systems_mobile/pages/routes.dart';
import 'package:education_systems_mobile/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/auth/auth_repository.dart';
import 'bloc/bloc_providers.dart';
import 'core/http/api_provider.dart';
import 'package:education_systems_mobile/theme.dart' as educationSystemsTheme;

import 'core/security/auth_provider.dart';
import 'core/security/education_systems_auth.dart';

void main() async{
  var delegate = await LocalizationDelegate.create(fallbackLocale: 'tr', supportedLocales: ['tr', 'en']);
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [ConsoleHandler()]);

  ApiProvider apiProvider = await ApiProvider.create();
  Catcher(
      rootWidget: LocalizedApp(
          delegate,
          EducationSystems(
            apiProvider: apiProvider,
          )),
    debugConfig: debugOptions
  );

}

class EducationSystems extends StatelessWidget {
  EducationSystems({this.apiProvider});
  final ApiProvider apiProvider;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.get(apiProvider: apiProvider),
      child: _initAuthProvider(context, apiProvider),
    );
  }

  void _setLocale(BuildContext context, LocalizationDelegate localizationDelegate) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentLocale = localizationDelegate.currentLocale.languageCode;
    String savedLocale = preferences.getString("currentLocale");
    if (savedLocale != null && savedLocale != "") {
      if (currentLocale != savedLocale) {
        changeLocale(context, savedLocale);
      }
    } else {
      preferences.setString("currentLocale", currentLocale);
    }
  }

  Widget _initAuthProvider(BuildContext context, ApiProvider apiProvider) {
    return AuthProvider(
      auth: EducationSystemsAuth(authRepository: new AuthRepository(apiProvider: apiProvider)),
      child: _initMaterialApp(context),
    );
  }

  Widget _initMaterialApp(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    _setLocale(context, localizationDelegate);

    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      title: 'EducationSystems',
      localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, localizationDelegate],
      supportedLocales: localizationDelegate.supportedLocales,
      locale: localizationDelegate.currentLocale,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: educationSystemsTheme.Theme.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'OpenSans',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomePage(),
      routes: Routes.get(),
    );
  }
}

