import 'package:flutter/material.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/user_model.dart';

/// 레벨 프로그레스 카드 위젯
class LevelProgressCard extends StatelessWidget {
  /// 사용자 데이터
  final User user;
  
  const LevelProgressCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      borderRadius: 16,
      opacity: 0.7,
      blur: 10,
      padding: const EdgeInsets.all(16),
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 레벨과 XP 정보 행
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '레벨 업까지',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${user.exp}',
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w600,
                      color: AppTheme.tealStart,
                    ),
                  ),
                  Text(
                    '/',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '${user.expToNextLevel}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    ' XP',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 진행 바
          Stack(
            children: [
              // 배경 바
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.deepOceanEnd.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              
              // 진행 바
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 8,
                width: MediaQuery.of(context).size.width * 
                    0.9 * user.levelProgress, // 화면 너비 기준 비율 계산
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _buildShimmerEffect(),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 쉬머 효과 빌드
  Widget _buildShimmerEffect() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              right: -constraints.maxWidth * 0.6,
              top: 0,
              bottom: 0,
              width: constraints.maxWidth * 0.6,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 