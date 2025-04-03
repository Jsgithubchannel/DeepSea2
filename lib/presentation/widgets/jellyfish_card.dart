import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 해파리 카드 위젯
class JellyfishCard extends StatelessWidget {
  /// 해파리 데이터
  final Jellyfish jellyfish;
  
  /// 카드 탭 이벤트 콜백
  final Function()? onTap;
  
  /// 해파리가 발견되었는지 여부
  final bool? isDiscovered;
  
  const JellyfishCard({
    super.key,
    required this.jellyfish,
    this.isDiscovered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // isDiscovered 파라미터를 우선 사용하고, 없으면 모델의 isDiscovered 사용
    final discovered = isDiscovered ?? jellyfish.isDiscovered;
    
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(16.0),
        borderRadius: 16.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 해파리 이미지
            Expanded(
              child: discovered
                ? Hero(
                    tag: 'jellyfish_${jellyfish.id}',
                    child: Image.asset(
                      jellyfish.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  )
                : Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.azureStart.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.help_outline,
                        color: AppTheme.azureStart.withOpacity(0.5),
                        size: 50,
                      ),
                    ),
                  ),
            ),
            
            const SizedBox(height: 12),
            
            // 위험도 표시
            if (discovered) ...[
              _buildDangerLevel(),
              const SizedBox(height: 8),
            ],
            
            // 해파리 이름
            Text(
              discovered ? jellyfish.name : '???',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 4),
            
            // 해파리 학명
            Text(
              discovered ? jellyfish.scientificName : '???',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            if (discovered) ...[
              const SizedBox(height: 12),
              
              // 해파리 짧은 설명
              Text(
                jellyfish.shortDescription,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// 위험도 표시 위젯 생성
  Widget _buildDangerLevel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '위험도: ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        _buildDangerIndicator(),
      ],
    );
  }
  
  /// 위험도 인디케이터 생성
  Widget _buildDangerIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: jellyfish.dangerColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: jellyfish.dangerColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        _getDangerText(jellyfish.dangerLevel),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: jellyfish.dangerColor,
        ),
      ),
    );
  }
  
  /// 위험도에 따른 간단한 텍스트 반환
  String _getDangerText(DangerLevel level) {
    switch (level) {
      case DangerLevel.safe:
        return '안전';
      case DangerLevel.mild:
        return '경미';
      case DangerLevel.moderate:
        return '주의';
      case DangerLevel.severe:
        return '위험';
      case DangerLevel.deadly:
        return '치명적';
    }
  }
} 