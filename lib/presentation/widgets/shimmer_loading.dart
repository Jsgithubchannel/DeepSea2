import 'package:flutter/material.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

/// 시머 로딩 효과 위젯
class ShimmerLoading extends StatelessWidget {
  /// 위젯 너비
  final double? width;
  
  /// 위젯 높이
  final double? height;
  
  /// 테두리 둥글기
  final double borderRadius;
  
  /// 마진
  final EdgeInsetsGeometry? margin;
  
  const ShimmerLoading({
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.margin,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppTheme.azureStart.withOpacity(0.2),
        highlightColor: AppTheme.azureStart.withOpacity(0.4),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

/// 해파리 카드 로딩 위젯
class JellyfishCardLoading extends StatelessWidget {
  const JellyfishCardLoading({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShimmerLoading(
            width: 100,
            height: 100,
            borderRadius: 50,
          ),
          const SizedBox(height: 16),
          ShimmerLoading(
            width: 100,
            height: 20,
            borderRadius: 4,
          ),
          const SizedBox(height: 8),
          ShimmerLoading(
            width: 80,
            height: 16,
            borderRadius: 4,
          ),
          const SizedBox(height: 8),
          ShimmerLoading(
            width: 60,
            height: 16,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
} 