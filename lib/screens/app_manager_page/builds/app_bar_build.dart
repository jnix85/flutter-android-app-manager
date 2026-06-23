part of '../app_manager_page.dart';

extension _AppBarBuild on _AppManagerPageState {
  AppBar _buildAppBar() {
    final colors = AppColors.of(context);
    return AppBar(
      title: FadeIn(
        duration: const Duration(milliseconds: 300),
        child: const Text(
          'App Manager',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        color: colors.surface.withOpacity(0.8),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: const _ThemeModeSelector(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: FadeInRight(
            duration: const Duration(milliseconds: 350),
            child: const DonateButton(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ValueListenableBuilder<String>(
            valueListenable: Localization.languageNotifier,
            builder: (context, languageCode, child) {
              final c = AppColors.of(context);
              return FadeInRight(
                duration: const Duration(milliseconds: 300),
                child: Tooltip(
                  message: Localization.translate('view_source'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => UrlUtils.launchUrlOrShow(
                          context, 'https://github.com/BlassGO/AppManager-GUI'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: c.foreground.withOpacity(0.2)),
                        ),
                        child: Text(
                          '@BlassGO',
                          style: TextStyle(
                            color: c.foreground,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.notifier,
      builder: (context, themeMode, _) {
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.foreground.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _segment(context, colors, themeMode, ThemeMode.light,
                  Icons.light_mode, 'theme_light'),
              _segment(context, colors, themeMode, ThemeMode.dark,
                  Icons.dark_mode, 'theme_dark'),
              _segment(context, colors, themeMode, ThemeMode.system,
                  Icons.desktop_windows, 'theme_system'),
            ],
          ),
        );
      },
    );
  }

  Widget _segment(
    BuildContext context,
    AppColors colors,
    ThemeMode current,
    ThemeMode mode,
    IconData icon,
    String tooltipKey,
  ) {
    final selected = current == mode;
    return Tooltip(
      message: Localization.translate(tooltipKey),
      child: GestureDetector(
        onTap: () => ThemeController.set(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 30,
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            size: 16,
            color: selected ? colors.foreground : colors.foregroundMuted,
          ),
        ),
      ),
    );
  }
}
