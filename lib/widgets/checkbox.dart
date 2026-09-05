import 'package:android_app_manager/overlays/tips.dart';
import 'package:android_app_manager/utils/localization.dart';
import 'package:android_app_manager/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final Map<String, dynamic> app;
  final VoidCallback? onChanged;
  final int index;
  final GlobalKey<HintMessageState>? hintKey;

  const AppCheckbox({
    required this.app,
    this.onChanged,
    required this.index,
    this.hintKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Localization.languageNotifier,
      builder: (context, languageCode, child) {
        return index == 0
            ? HintMessage(
                key: hintKey,
                hintKey: 'checkbox_tip',
                message: Localization.translate('checkbox_tip'),
                dismissButtonText: Localization.translate('skip'),
                hintWidth: 300.0,
                child: Checkbox(
                  value: app['isChecked'],
                  onChanged: (value) {
                    app['isChecked'] = value;
                    if (onChanged != null) onChanged!();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  activeColor: Theme.of(context).primaryColor,
                  checkColor: AppColors.of(context).foreground,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              )
            : Checkbox(
                value: app['isChecked'],
                onChanged: (value) {
                  app['isChecked'] = value;
                  if (onChanged != null) onChanged!();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                activeColor: Theme.of(context).primaryColor,
                checkColor: AppColors.of(context).foreground,
                materialTapTargetSize: MaterialTapTargetSize.padded,
              );
      },
    );
  }
}
