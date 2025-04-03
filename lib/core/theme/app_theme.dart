import 'package:flutter/material.dart';

/// 해파리 앱의 테마를 정의하는 클래스입니다.
/// 글래스모피즘 스타일과 해양 테마 컬러를 사용합니다.
class AppTheme {
  // 싱글톤 패턴 구현
  static final AppTheme _instance = AppTheme._internal();
  factory AppTheme() => _instance;
  AppTheme._internal();

  // 메인 컬러 테마
  static const primary = Color(0xFF2F80ED);
  static const secondary = Color(0xFF2D9CDB);
  static const accent = Color(0xFF56CCF2);
  
  // 그라데이션 색상
  static const azureStart = Color(0xFF1A2980);
  static const azureEnd = Color(0xFF26D0CE);
  
  // 텍스트 색상
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textLight = Color(0xFF999999);
  
  // 배경 색상
  static const background = Color(0xFFF5F5F5);
  static const cardBackground = Color(0xFFFFFFFF);
  
  // 상태 색상
  static const success = Color(0xFF27AE60);
  static const warning = Color(0xFFF2C94C);
  static const error = Color(0xFFEB5757);
  static const info = Color(0xFF56CCF2);
  
  // 해파리 위험도 색상
  static const dangerHigh = Color(0xFFEB5757);
  static const dangerMedium = Color(0xFFF2994A);
  static const dangerLow = Color(0xFFF2C94C);
  static const dangerNone = Color(0xFF27AE60);

  // 글래스 효과 테마
  static const glassTint = Color.fromRGBO(255, 255, 255, 0.1);
  static const glassBorder = Color.fromRGBO(255, 255, 255, 0.2);
  static const glassOpacity = 0.8;
  static const glassBlur = 10.0;
  
  // 그림자 테마
  static const shadowColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const shadowSpread = 0.0;
  static const shadowBlur = 10.0;
  static const shadowOffset = Offset(0, 4);

  // 주요 색상 정의
  static const Color deepOceanStart = Color(0xFF0F172A);
  static const Color deepOceanEnd = Color(0xFF1E293B);
  static const Color twilightStart = Color(0xFF1E293B);
  static const Color twilightEnd = Color(0xFF334155);
  static const Color tealStart = Color(0xFF0D9488);
  static const Color tealEnd = Color(0xFF0F766E);
  static const Color moonlight = Color(0xFFF8FAFC);
  static const Color seafoam = Color(0xFF94A3B8);
  static const Color coralStart = Color(0xFFEF4444);
  static const Color coralEnd = Color(0xFFDC2626);

  // 텍스트 색상
  static const Color textMuted = Color(0xFF64748B);
  
  // 배경 그라데이션
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepOceanStart, deepOceanEnd],
  );
  
  // 요소 그라데이션
  static const LinearGradient elementGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [twilightStart, twilightEnd],
  );
  
  // 강조 그라데이션
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [azureStart, azureEnd],
  );
  
  // 보조 강조 그라데이션
  static const LinearGradient secondaryAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tealStart, tealEnd],
  );
  
  // 경고 그라데이션
  static const LinearGradient alertGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [coralStart, coralEnd],
  );

  // 그림자 스타일
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 5,
      offset: const Offset(0, 2),
    ),
  ];
  
  // 앱 테마 생성
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: deepOceanStart,
    colorScheme: const ColorScheme.dark(
      primary: azureStart,
      secondary: tealStart,
      surface: twilightStart,
      background: deepOceanStart,
      error: coralStart,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.2,
      ),
    ),
    iconTheme: const IconThemeData(
      color: moonlight,
      size: 24,
    ),
    cardTheme: CardTheme(
      color: twilightStart.withOpacity(0.7),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(0.1),
      thickness: 1,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: deepOceanStart.withOpacity(0.95),
      indicatorColor: azureStart.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: azureStart,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        );
      }),
    ),
  );
} 