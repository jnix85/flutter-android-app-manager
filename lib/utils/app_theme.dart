import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_app_manager/utils/config.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceMuted;
  final Color buttonSurface;
  final Color buttonSurfaceVariant;
  final Color foreground;
  final Color foregroundMuted;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceMuted,
    required this.buttonSurface,
    required this.buttonSurfaceVariant,
    required this.foreground,
    required this.foregroundMuted,
  });

  static const AppColors dark = AppColors(
    background: Color(0xFF212121),
    surface: Color(0xFF303030),
    surfaceVariant: Color(0xFF424242),
    surfaceMuted: Color(0xFF616161),
    buttonSurface: Color(0xFF263238),
    buttonSurfaceVariant: Color(0xFF37474F),
    foreground: Color(0xFFFFFFFF),
    foregroundMuted: Color(0xB3FFFFFF),
  );

  static const AppColors light = AppColors(
    background: Color(0xFFF3F0E9),
    surface: Color(0xFFE8E3D8),
    surfaceVariant: Color(0xFFDBD4C7),
    surfaceMuted: Color(0xFFC2BAAC),
    buttonSurface: Color(0xFFE0D8C9),
    buttonSurfaceVariant: Color(0xFFD1C8B6),
    foreground: Color(0xFF33312E),
    foregroundMuted: Color(0x9933312E),
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? dark;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceMuted,
    Color? buttonSurface,
    Color? buttonSurfaceVariant,
    Color? foreground,
    Color? foregroundMuted,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      buttonSurface: buttonSurface ?? this.buttonSurface,
      buttonSurfaceVariant: buttonSurfaceVariant ?? this.buttonSurfaceVariant,
      foreground: foreground ?? this.foreground,
      foregroundMuted: foregroundMuted ?? this.foregroundMuted,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      buttonSurface: Color.lerp(buttonSurface, other.buttonSurface, t)!,
      buttonSurfaceVariant:
          Color.lerp(buttonSurfaceVariant, other.buttonSurfaceVariant, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      foregroundMuted: Color.lerp(foregroundMuted, other.foregroundMuted, t)!,
    );
  }
}

class AppTheme {
  static ThemeData _build(Brightness brightness, AppColors colors) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark()
        : ThemeData.light();
    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[colors],
      primaryColor: brightness == Brightness.dark ? Colors.blueAccent : const Color(0xFFD4A373),
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      cardColor: colors.surface,
      dialogBackgroundColor: colors.background,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: colors.foreground,
        displayColor: colors.foreground,
      ),
      iconTheme: IconThemeData(color: colors.foregroundMuted, size: 20),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colors.surface,
      ),
      checkboxTheme: CheckboxThemeData(
        side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: brightness == Brightness.dark ? Colors.blueAccent : const Color(0xFFD4A373), width: 1.5);
          }
          return BorderSide(color: colors.foregroundMuted, width: 1.5);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brightness == Brightness.dark ? Colors.blueAccent : const Color(0xFFD4A373),
          foregroundColor: colors.foreground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.foreground.withOpacity(0.05),
        hintStyle: TextStyle(color: colors.foregroundMuted),
        labelStyle: TextStyle(color: colors.foregroundMuted),
        prefixIconColor: colors.foregroundMuted,
        suffixIconColor: colors.foregroundMuted,
        iconColor: colors.foregroundMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: brightness == Brightness.dark ? Colors.blueAccent : const Color(0xFFD4A373),
        selectionColor: (brightness == Brightness.dark ? Colors.blueAccent : const Color(0xFFD4A373)).withOpacity(0.3),
        selectionHandleColor: brightness == Brightness.dark ? Colors.blueAccent : const Color(0xFFD4A373),
      ),
      colorScheme: (brightness == Brightness.dark
              ? const ColorScheme.dark()
              : const ColorScheme.light())
          .copyWith(
        primary: brightness == Brightness.dark ? Colors.blueAccent : const Color(0xFFD4A373),
        surface: colors.surface,
        onSurface: colors.foreground,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(Colors.transparent),
        dataRowColor: WidgetStateProperty.all(Colors.transparent),
        dividerThickness: 1,
        horizontalMargin: 12,
        columnSpacing: 24,
        headingTextStyle: base.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.foreground,
          fontSize: 13,
        ),
        dataTextStyle: base.textTheme.bodySmall?.copyWith(
          color: colors.foreground,
          fontSize: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.foreground.withOpacity(0.1),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);
  static ThemeData get light => _build(Brightness.light, AppColors.light);
}

class ThemeController {
  static final ValueNotifier<ThemeMode> notifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static void init() {
    notifier.value = _fromString(ConfigUtils.themeMode);
  }

  static Future<void> set(ThemeMode mode) async {
    if (notifier.value == mode) return;
    notifier.value = mode;
    ConfigUtils.themeMode = _toString(mode);
    await ConfigUtils.save();
  }

  static ThemeMode _fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
