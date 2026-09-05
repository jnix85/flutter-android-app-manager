import 'package:flutter_test/flutter_test.dart';
import 'package:android_app_manager/utils/localization.dart';
import 'package:android_app_manager/utils/config.dart';

void main() {
  group('Localization', () {
    test('translate returns key as fallback when no locale is loaded', () {
      expect(Localization.translate('nonexistent_key'), equals('nonexistent_key'));
    });
  });

  group('ConfigUtils', () {
    test('boolean options default to false', () {
      expect(ConfigUtils.neverUninstallApps, isFalse);
      expect(ConfigUtils.exportAllApps, isFalse);
      expect(ConfigUtils.refreshIcons, isFalse);
      expect(ConfigUtils.alwaysShowIcons, isFalse);
    });

    test('isFirstLaunch defaults to true', () {
      expect(ConfigUtils.isFirstLaunch, isTrue);
    });
  });
}
