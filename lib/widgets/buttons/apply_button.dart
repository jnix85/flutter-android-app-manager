import 'package:android_app_manager/utils/localization.dart';
import 'package:android_app_manager/utils/app_theme.dart';
import 'package:android_app_manager/overlays/tips.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ApplyButton extends StatelessWidget {
  final GlobalKey<HintMessageState> hintKey;
  final VoidCallback onPressed;
  const ApplyButton(
      {required this.hintKey, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Localization.languageNotifier,
      builder: (context, languageCode, child) {
        return HintMessage(
          key: hintKey,
          hintKey: 'apply_button_tip',
          message: Localization.translate('apply_button_tip'),
          dismissButtonText: Localization.translate('skip'),
          hintWidth: 350.0,
          child: FadeIn(
            duration: const Duration(milliseconds: 300),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: 300, maxWidth: 300, minHeight: 40),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: AppColors.of(context).foreground,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(Localization.translate('apply_button'),
                    style: TextStyle(
                      color: AppColors.of(context).foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        );
      },
    );
  }
}
