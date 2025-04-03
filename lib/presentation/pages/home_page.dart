import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/presentation/controllers/home_controller.dart';
import 'package:jellyfish_test/presentation/widgets/alert_event_card.dart';
import 'package:jellyfish_test/presentation/widgets/collection_progress_card.dart';
import 'package:jellyfish_test/presentation/widgets/level_progress_card.dart';
import 'package:jellyfish_test/presentation/widgets/navigation_bar.dart';
import 'package:jellyfish_test/presentation/widgets/profile_header.dart';

/// 앱 홈 화면
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: Stack(
            children: [
              // 배경 그라데이션
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.twilightStart,
                      AppTheme.twilightEnd,
                    ],
                  ),
                ),
              ),
              
              // 배경 물방울 효과
              _buildBubbleBackground(),
              
              // 메인 콘텐츠
              SafeArea(
                child: _buildContent(controller),
              ),
              
              // 알림 이벤트
              Obx(() {
                if (controller.isAlertVisible.value) {
                  return Positioned(
                    bottom: 100,
                    left: 16,
                    right: 16,
                    child: AlertEventCard(
                      title: '해파리 출현!',
                      description: '해안가에 해파리가 나타났어요! 지금 식별하러 가시겠습니까?',
                      remainingSeconds: 30,
                      onTap: controller.onAlertTap,
                      onDismiss: controller.dismissAlert,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
          bottomNavigationBar: JellyfishNavigationBar(
            selectedIndex: controller.currentIndex.value,
            onTabChanged: controller.changeTab,
            onIdentifyTap: controller.navigateToIdentification,
          ),
        );
      },
    );
  }
  
  /// 메인 컨텐츠 빌드
  Widget _buildContent(HomeController controller) {
    return Obx(() {
      // 현재 선택된 탭에 따라 다른 콘텐츠 표시
      switch (controller.currentIndex.value) {
        case 0:
          return _buildHomeTab(controller);
        case 1:
          return _buildCollectionTab(controller);
        case 2:
          return _buildQuizTab(controller);
        case 3:
          return _buildProfileTab(controller);
        default:
          return _buildHomeTab(controller);
      }
    });
  }
  
  /// 홈 탭 콘텐츠
  Widget _buildHomeTab(HomeController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 사용자 프로필 헤더
          Obx(() => ProfileHeader(user: controller.user.value)),
          
          const SizedBox(height: 16),
          
          // 레벨 진행도 카드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => LevelProgressCard(user: controller.user.value)),
          ),
          
          const SizedBox(height: 24),
          
          // 해파리 컬렉션 진행도
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => CollectionProgressCard(jellyfishList: controller.jellyfishList)),
          ),
          
          const SizedBox(height: 24),
          
          // 팁 및 가이드 섹션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTipsSection(),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  /// 컬렉션 탭 콘텐츠
  Widget _buildCollectionTab(HomeController controller) {
    return const Center(
      child: Text(
        '컬렉션 페이지',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// 퀴즈 탭 콘텐츠
  Widget _buildQuizTab(HomeController controller) {
    return const Center(
      child: Text(
        '퀴즈 페이지',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// 프로필 탭 콘텐츠
  Widget _buildProfileTab(HomeController controller) {
    return const Center(
      child: Text(
        '프로필 페이지',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// 팁 및 가이드 섹션
  Widget _buildTipsSection() {
    return PrimaryGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.azureStart.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '해파리 안전 팁',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            '• 해파리를 발견했을 경우 절대 만지지 마세요.\n'
            '• 해변에서 수영할 때는 해파리 경보를 확인하세요.\n'
            '• 해파리에 쏘였을 경우, 즉시 식초를 사용하세요.\n'
            '• 심각한 증상이 나타나면 즉시 의료 도움을 요청하세요.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 배경 버블 효과
  Widget _buildBubbleBackground() {
    return Stack(
      children: List.generate(20, (index) {
        final size = 10.0 + (index % 4 * 20);
        final xPos = (index * 20) % (Get.width - size);
        final yPos = (index * 50) % (Get.height - size);
        
        return Positioned(
          left: xPos,
          top: yPos,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05 + (index % 5) * 0.01),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
} 