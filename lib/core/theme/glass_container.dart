import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';

/// 글래스모피즘 스타일의 컨테이너 위젯
class GlassContainer extends StatelessWidget {
  /// 자식 위젯
  final Widget child;
  
  /// 컨테이너 높이
  final double? height;
  
  /// 컨테이너 너비
  final double? width;
  
  /// 패딩
  final EdgeInsetsGeometry padding;
  
  /// 마진
  final EdgeInsetsGeometry margin;
  
  /// 테두리 둥글기
  final double borderRadius;
  
  /// 배경 불투명도 (0.0 ~ 1.0)
  final double opacity;
  
  /// 블러 강도
  final double blur;
  
  /// 배경 색상 - null일 경우 테마의 twilightStart 색상 사용
  final Color? backgroundColor;
  
  /// 테두리 색상 - null일 경우 흰색 10% 불투명도 사용
  final Color? borderColor;
  
  /// 그림자 사용 여부
  final bool hasShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16,
    this.opacity = 0.7,
    this.blur = 10,
    this.backgroundColor,
    this.borderColor,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: hasShadow 
          ? BoxDecoration(
              boxShadow: AppTheme.softShadow,
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (backgroundColor ?? AppTheme.twilightStart).withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 미리 설정된 스타일의 GlassContainer - 상단 카드
class PrimaryGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  
  const PrimaryGlassCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: child,
      opacity: 0.7, 
      blur: 12,
      borderRadius: 16,
      padding: padding,
      margin: margin,
      hasShadow: true,
    );
  }
}

/// 미리 설정된 스타일의 GlassContainer - 작은 요소
class SecondaryGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  
  const SecondaryGlassCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: child,
      opacity: 0.5,
      blur: 8,
      borderRadius: 12,
      padding: padding,
      margin: margin,
      hasShadow: false,
    );
  }
}

/// 미리 설정된 스타일의 GlassContainer - 돌발 이벤트용 카드 (빨간색 계열)
class AlertGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  
  const AlertGlassCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: child,
      opacity: 0.7,
      blur: 10,
      borderRadius: 16,
      padding: padding,
      margin: margin,
      backgroundColor: AppTheme.coralStart,
      borderColor: AppTheme.coralEnd.withOpacity(0.3),
      hasShadow: true,
    );
  }
} 