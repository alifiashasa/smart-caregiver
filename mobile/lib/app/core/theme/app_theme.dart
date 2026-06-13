import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color background = Color(0xFFFDF8F8);
  static const Color backgroundAlt = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF7F3F2);
  static const Color primary = Color(0xFF192126);
  static const Color accent = Color(0xFFBBF246);
  static const Color accentSoft = Color(0xFFF1FFD4);
  static const Color textPrimary = Color(0xFF1C1B1C);
  static const Color textSecondary = Color(0xFF47464B);
  static const Color textTertiary = Color(0xFF77767B);
  static const Color border = Color(0xFFE8E4E2);
  static const Color borderStrong = Color(0xFFC8C5CB);
  static const Color success = Color(0xFF4C9A2A);
  static const Color successSoft = Color(0xFFE6F3E6);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFFEFC7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSoft = Color(0xFFFFE6E6);

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;

  static const Duration motionFast = Duration(milliseconds: 180);
  static const Duration motion = Duration(milliseconds: 240);

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: const Color(0xFF18181B).withValues(alpha: 0.06),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get liftShadow => [
    BoxShadow(
      color: const Color(0xFF18181B).withValues(alpha: 0.10),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
  ];

  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 700) return 32;
    return 20;
  }

  static BoxDecoration cardDecoration({
    Color color = surface,
    Color borderColor = border,
    double radius = radiusLg,
    bool elevated = true,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor),
      boxShadow: elevated ? softShadow : null,
    );
  }

  static InputDecoration inputDecoration({
    required String hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: primary,
        surface: surface,
        onSurface: textPrimary,
        error: error,
        onError: Colors.white,
        outline: border,
        surfaceContainerHighest: surfaceMuted,
      ),
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: textPrimary, displayColor: textPrimary)
        .copyWith(
          displaySmall: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            height: 1.18,
            letterSpacing: -0.8,
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            height: 1.28,
            letterSpacing: -0.35,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            height: 1.35,
            letterSpacing: -0.25,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          bodyLarge: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            height: 1.55,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
          bodyMedium: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 1.50,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
          labelLarge: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 1.35,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          labelMedium: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            height: 1.35,
            fontWeight: FontWeight.w700,
            color: textSecondary,
          ),
        );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface.withValues(alpha: 0.96),
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(fontSize: 19),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
        actionsIconTheme: const IconThemeData(color: textPrimary, size: 22),
        shape: const Border(bottom: BorderSide(color: border, width: 1)),
      ),
      iconTheme: const IconThemeData(color: textPrimary, size: 22),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primary),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: border),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 10,
        focusElevation: 10,
        hoverElevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textTertiary),
        labelStyle: textTheme.labelLarge?.copyWith(color: textSecondary),
        floatingLabelStyle: textTheme.labelLarge?.copyWith(color: primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: error, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: textTertiary.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.80),
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          side: const BorderSide(color: borderStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: accent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium!.copyWith(
            color: selected ? primary : Colors.white.withValues(alpha: 0.76),
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? primary : Colors.white.withValues(alpha: 0.76),
            size: 22,
          );
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: surface,
        showDragHandle: true,
        dragHandleColor: borderStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accent;
          return border;
        }),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: surface,
        surfaceTintColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: surface,
        dialBackgroundColor: surfaceMuted,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
