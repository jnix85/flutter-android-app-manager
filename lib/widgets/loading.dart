import 'package:app_manager/utils/localization.dart';
import 'package:app_manager/utils/app_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool isLoadingApps;
  final bool loadIcons;
  final bool iconsReady;
  final bool isFilteredDataEmpty;

  const Loading({
    super.key,
    required this.isLoadingApps,
    required this.loadIcons,
    required this.iconsReady,
    required this.isFilteredDataEmpty,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ValueListenableBuilder<String>(
      valueListenable: Localization.languageNotifier,
      builder: (context, languageCode, child) {
        if (isLoadingApps || (loadIcons && !iconsReady)) {
          return FadeIn(
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Theme.of(context).primaryColor,
                backgroundColor: colors.foreground.withOpacity(0.1),
              ),
            ),
          );
        } else if (isFilteredDataEmpty) {
          return FadeIn(
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                Localization.translate('no_matches'),
                style: TextStyle(
                  color: colors.foregroundMuted,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
