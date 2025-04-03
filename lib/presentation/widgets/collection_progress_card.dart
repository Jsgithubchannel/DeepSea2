import 'package:flutter/material.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 도감 진행 상태 카드 위젯
class CollectionProgressCard extends StatelessWidget {
  /// 해파리 리스트
  final List<Jellyfish> jellyfishList;
  
  const CollectionProgressCard({
    super.key,
    required this.jellyfishList,
  });

  @override
  Widget build(BuildContext context) {
    // 발견한 해파리 수와 전체 해파리 수
    final discoveredCount = jellyfishList.where((j) => j.isDiscovered).length;
    final totalCount = jellyfishList.length;
    // 진행도 계산
    final progressPercentage = discoveredCount / totalCount;
    
    return PrimaryGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (제목과 "모두 보기" 버튼)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '📚',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '도감 진행도',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  // 도감 페이지로 이동 (필요시 구현)
                },
                child: Row(
                  children: [
                    Text(
                      '모두 보기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '→',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 프로그레스 바 헤더 (텍스트 표시)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '수집 현황',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$discoveredCount',
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
                    '$totalCount',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 프로그레스 바
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
                width: MediaQuery.of(context).size.width * 0.8 * progressPercentage,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.azureStart, AppTheme.tealStart],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 해파리 그리드
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: jellyfishList.length,
            itemBuilder: (context, index) {
              final jellyfish = jellyfishList[index];
              return _buildJellyfishTile(jellyfish);
            },
          ),
        ],
      ),
    );
  }
  
  /// 해파리 타일 위젯 생성
  Widget _buildJellyfishTile(Jellyfish jellyfish) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: jellyfish.isDiscovered
            ? AppTheme.twilightStart
            : Colors.transparent,
        border: Border.all(
          color: jellyfish.isDiscovered
              ? AppTheme.twilightEnd
              : AppTheme.textSecondary.withOpacity(0.3),
          width: 1,
          style: jellyfish.isDiscovered ? BorderStyle.solid : BorderStyle.none,
        ),
      ),
      child: Center(
        child: Text(
          jellyfish.isDiscovered ? '🪼' : '◌',
          style: TextStyle(
            fontSize: 24,
            color: jellyfish.isDiscovered 
                ? Colors.white 
                : AppTheme.textSecondary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
} 