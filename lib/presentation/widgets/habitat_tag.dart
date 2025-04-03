import 'package:flutter/material.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';

/// 해파리 서식지 태그 위젯
class HabitatTag extends StatelessWidget {
  /// 서식지 이름
  final String habitat;
  
  const HabitatTag({
    Key? key,
    required this.habitat,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.azureStart.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.azureStart.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        habitat,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
} 