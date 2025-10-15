import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConfig {
  // Singleton pattern
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // Colors - Light Mode
  static const Color primaryColorLight = Color(0xFF6C63FF);
  static const Color secondaryColorLight = Color(0xFF00D4FF);
  static const Color backgroundLight = Color(0xFFF8F9FD);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color successLight = Color(0xFF10B981);

  // Colors - Dark Mode
  static const Color primaryColorDark = Color(0xFF8B83FF);
  static const Color secondaryColorDark = Color(0xFF00E5FF);
  static const Color backgroundDark = Color(0xFF0F0F1E);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color textPrimaryDark = Color(0xFFF8F9FD);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color errorDark = Color(0xFFF87171);
  static const Color successDark = Color(0xFF34D399);

  // Gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradientAlt = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFC564FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glass Effect Colors
  static Color glassLight = Colors.white.withValues(alpha: 0.2);
  static Color glassDark = Colors.black.withValues(alpha: 0.3);

  // Font Sizes (Responsive with ScreenUtil)
  static double get fontSizeCaption => 12.sp;
  static double get fontSizeBody => 14.sp;
  static double get fontSizeSubtitle => 16.sp;
  static double get fontSizeTitle => 18.sp;
  static double get fontSizeHeading => 20.sp;
  static double get fontSizeLargeHeading => 20.sp;

  // Icon Sizes
  static double get iconSizeSmall => 16.sp;
  static double get iconSizeMedium => 24.sp;
  static double get iconSizeLarge => 32.sp;
  static double get iconSizeXLarge => 48.sp;

  // Spacing
  static double get spacingXSmall => 4.w;
  static double get spacingSmall => 8.w;
  static double get spacingMedium => 16.w;
  static double get spacingLarge => 24.w;
  static double get spacingXLarge => 32.w;

  // Corner Radius
  static double get cornerRadiusSmall => 8.r;
  static double get cornerRadiusMedium => 12.r;
  static double get cornerRadiusLarge => 16.r;
  static double get cornerRadiusXLarge => 24.r;
  static double get cornerRadiusCircle => 100.r;

  // Default Padding
  static double get defaultPadding => 18.w;
  static double get defaultPaddingLarge => 26.w;

  // Elevation
  static double get elevationLow => 2.5;
  static double get elevationMedium => 5.0;
  static double get elevationHigh => 8.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 100);
  static const Duration animationMedium = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 300);

  // Border
  static double get borderWidthThin => 1.w;
  static double get borderWidthMedium => 2.w;

  // App Bar Height
  static double get appBarHeight => 56.h;

  // Bottom Nav Height
  static double get bottomNavHeight => 70.h;

  // Category Place Icons
  static const Map<String, IconData> categoryIcons = {
    'Coffee': Icons.coffee,
    'Gym': Icons.fitness_center,
    'Library': Icons.local_library,
    'Restaurant': Icons.restaurant,
    'Supermarket': Icons.shopping_cart,
    'Hospital': Icons.local_hospital,
    'Park': Icons.park,
    'Cinema': Icons.local_movies,
    'Hotel': Icons.hotel,
    'Gas Station': Icons.local_gas_station,
  };

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primaryColorLight,
      secondary: secondaryColorLight,
      surface: surfaceLight,
      error: errorLight,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: fontSizeLargeHeading,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      displayMedium: TextStyle(
        fontSize: fontSizeHeading,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      headlineMedium: TextStyle(
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      bodyLarge: TextStyle(fontSize: fontSizeBody, color: textPrimaryLight),
      bodyMedium: TextStyle(fontSize: fontSizeBody, color: textSecondaryLight),
      labelLarge: TextStyle(
        fontSize: fontSizeSubtitle,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadiusMedium),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight, size: iconSizeMedium),
    ),
  );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColorDark,
      secondary: secondaryColorDark,
      surface: surfaceDark,
      error: errorDark,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: fontSizeLargeHeading,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displayMedium: TextStyle(
        fontSize: fontSizeHeading,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      bodyLarge: TextStyle(fontSize: fontSizeBody, color: textPrimaryDark),
      bodyMedium: TextStyle(fontSize: fontSizeBody, color: textSecondaryDark),
      labelLarge: TextStyle(
        fontSize: fontSizeSubtitle,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadiusMedium),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark, size: iconSizeMedium),
    ),
  );
}
