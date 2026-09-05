import 'dart:io';
import 'package:android_app_manager/screens/app_manager_page/app_manager_page.dart';
import 'package:android_app_manager/overlays/intro.dart';
import 'package:android_app_manager/utils/config.dart';
import 'package:android_app_manager/utils/localization.dart';
import 'package:android_app_manager/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  final packageInfo = await PackageInfo.fromPlatform();
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigUtils.load();
  ThemeController.init();
  await Localization.loadLanguages();
  await Localization.loadLocale(ConfigUtils.currentLanguage ?? 'en');
  appSupportDir = (await getApplicationSupportDirectory()).path;
  iconsDirPath = '$appSupportDir${Platform.pathSeparator}icons${Platform.pathSeparator}'.replaceAll('\\', '/');
  runApp(const MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(900, 650);
    appWindow
      ..minSize = initialSize
      ..size = initialSize
      ..alignment = Alignment.center
      ..title = 'Android App Manager [${packageInfo.version}]'
      ..show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.notifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Android App Manager',
          locale: const Locale('en'),
          supportedLocales: const [Locale('en')],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          initialRoute: ConfigUtils.isFirstLaunch ? '/setup' : '/home',
          routes: {
            '/setup': (context) => IntroductionOverlay(
                  onContinue: () {
                    Navigator.pushReplacementNamed(context, '/home');
                    ConfigUtils.isFirstLaunch = false;
                    ConfigUtils.save();
                  },
                ),
            '/home': (context) => ValueListenableBuilder<String>(
                  valueListenable: Localization.languageNotifier,
                  builder: (context, languageCode, child) {
                    return const AppManagerPage();
                  },
                ),
          },
        );
      },
    );
  }
}
