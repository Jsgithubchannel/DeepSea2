import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/presentation/widgets/fact_card.dart';
import 'package:jellyfish_test/presentation/widgets/habitat_tag.dart';

/// 해파리 상세 화면
class JellyfishDetailScreen extends StatelessWidget {
  /// 해파리 ID
  final String jellyfishId;
  
  final JellyfishController _jellyfishController = Get.find<JellyfishController>();
  
  JellyfishDetailScreen({
    Key? key,
    required this.jellyfishId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final jellyfish = _jellyfishController.getJellyfishById(jellyfishId);
    
    if (jellyfish == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('오류')),
        body: const Center(child: Text('해파리를 찾을 수 없습니다')),
      );
    }
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.azureStart,
              AppTheme.azureEnd,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 해파리 헤더 이미지
              SliverToBoxAdapter(
                child: _buildHeader(jellyfish),
              ),
              
              // 해파리 콘텐츠
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameSection(jellyfish),
                      const SizedBox(height: 16),
                      _buildDescription(jellyfish),
                      const SizedBox(height: 24),
                      _buildHabitatSection(jellyfish),
                      const SizedBox(height: 24),
                      _buildFactCards(jellyfish),
                      const SizedBox(height: 24),
                      if (jellyfish.discoveredAt != null) ...[
                        _buildDiscoveryInfo(jellyfish),
                        const SizedBox(height: 36),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 헤더 이미지 섹션
  Widget _buildHeader(Jellyfish jellyfish) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 그라데이션
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // 해파리 이미지
          Hero(
            tag: 'jellyfish_${jellyfish.id}',
            child: Image.asset(
              jellyfish.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          
          // 위험도 배지
          Positioned(
            top: 16,
            right: 16,
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              borderRadius: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '위험도: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Container(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 이름 섹션 (이름과 학명)
  Widget _buildNameSection(Jellyfish jellyfish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          jellyfish.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          jellyfish.scientificName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
  
  /// 설명 섹션
  Widget _buildDescription(Jellyfish jellyfish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '설명',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          jellyfish.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
        ),
      ],
    );
  }
  
  /// 서식지 섹션
  Widget _buildHabitatSection(Jellyfish jellyfish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '서식지',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: jellyfish.habitats.map((habitat) => HabitatTag(habitat: habitat)).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.straighten,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '크기: ${jellyfish.size}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// 팩트 카드 섹션
  Widget _buildFactCards(Jellyfish jellyfish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '재미있는 사실',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 12),
        FactCard(title: '알고 계셨나요?', content: jellyfish.funFact),
      ],
    );
  }
  
  /// 발견 정보 섹션
  Widget _buildDiscoveryInfo(Jellyfish jellyfish) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '발견 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '발견일: ${_formatDate(jellyfish.discoveredAt!)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 날짜 포맷팅 함수
  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
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