import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/presentation/widgets/jellyfish_card.dart';
import 'package:jellyfish_test/presentation/widgets/shimmer_loading.dart';
import 'package:jellyfish_test/presentation/widgets/navigation_bar.dart';

/// 홈 화면
class HomeScreen extends StatelessWidget {
  final JellyfishController _jellyfishController = Get.find<JellyfishController>();
  final UserController _userController = Get.find<UserController>();
  
  // 임시 이벤트 데이터
  final RxBool _hasEvent = true.obs;
  
  HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('HomeScreen 빌드 중...');
    return Obx(() {
      // 로딩 상태 확인
      if (_jellyfishController.isLoading.value || _userController.isLoading.value) {
        return Scaffold(
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
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      
      return Scaffold(
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
          child: Stack(
            children: [
              // 장식용 해파리 배경 효과
              Positioned(
                top: 100,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                right: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              
              // 메인 컨텐츠
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildProfileSection(context),
                            const SizedBox(height: 16),
                            _buildXpProgressBar(context),
                            const SizedBox(height: 24),
                            _buildDiscoveryProgress(context),
                            const SizedBox(height: 20),
                            if (_hasEvent.value) _buildEventBanner(context),
                            const SizedBox(height: 20),
                            _buildSectionTitle('최근 발견한 해파리'),
                            const SizedBox(height: 16),
                            _buildRecentlyDiscoveredSection(),
                            const SizedBox(height: 100), // 네비게이션 바 공간
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        extendBody: true, // 네비게이션 바 아래 바디 확장
        bottomNavigationBar: JellyfishNavigationBar(
          selectedIndex: 0,
          onTabChanged: (index) {
            switch (index) {
              case 0:
                // 이미 홈 화면
                break;
              case 1:
                Get.toNamed(AppRoutes.collection);
                break;
              case 2:
                Get.toNamed(AppRoutes.quiz);
                break;
              case 3:
                Get.toNamed(AppRoutes.profile);
                break;
            }
          },
          onIdentifyTap: () {
            Get.toNamed(AppRoutes.identification);
          },
        ),
      );
    });
  }
  
  /// 프로필 섹션
  Widget _buildProfileSection(BuildContext context) {
    return Obx(() {
      final user = _userController.user.value;
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            // 레벨 뱃지
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.indigo],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Stack(
                children: [
                  // 반짝이는 효과
                  Positioned(
                    top: -30,
                    left: -30,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                  // 레벨 표시
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${user.level}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "레벨",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 하단 장식선
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.cyanAccent, Colors.blue],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 사용자 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.cyanAccent, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyanAccent.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 뱃지 컨테이너
                  Row(
                    children: [
                      _buildBadge(
                        icon: "🔍",
                        count: user.discoveredJellyfishCount,
                        total: _jellyfishController.jellyfishList.length,
                        color: Colors.blue,
                        label: "발견",
                      ),
                      const SizedBox(width: 8),
                      _buildBadge(
                        icon: "⭐",
                        count: user.exp,
                        color: Colors.amber,
                        label: "포인트",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 설정 아이콘
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 24),
              onPressed: () => Get.toNamed(AppRoutes.profile),
            ),
          ],
        ),
      );
    });
  }
  
  /// 뱃지 위젯
  Widget _buildBadge({
    required String icon,
    required int count,
    int? total,
    required Color color,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            total != null ? "$count/$total" : "$count",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 경험치 바
  Widget _buildXpProgressBar(BuildContext context) {
    return Obx(() {
      final user = _userController.user.value;
      final xpPercentage = user.levelProgress * 100;
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 12,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '레벨 업까지',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '${user.exp % user.expToNextLevel}/${user.expToNextLevel} XP',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 경험치 진행 바
              Stack(
                children: [
                  // 배경 바
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // 진행 바
                  Container(
                    height: 8,
                    width: (MediaQuery.of(context).size.width * (xpPercentage / 100) - 64).clamp(0.0, double.infinity),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan, Colors.blue, Colors.indigo],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 빛나는 효과
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 20,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(0.5),
                                  Colors.white.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
  
  /// 돌발 이벤트 배너
  Widget _buildEventBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          // 이벤트 처리 로직
          Get.toNamed(AppRoutes.quiz);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.red.shade900.withOpacity(0.8),
                Colors.deepOrange.shade900.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 경고 아이콘
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 28,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 이벤트 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '돌발 이벤트: 쏘였다 속보!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '전문가의 응급처치법을 맞춰보세요',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // 타이머
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade800.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red.shade700.withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  '19:23',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 발견 진행도 위젯
  Widget _buildDiscoveryProgress(BuildContext context) {
    return Obx(() {
      final discoveryRate = _jellyfishController.discoveryRate.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                      SizedBox(width: 6),
                      Text(
                        '도감 진행도',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${discoveryRate.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: (MediaQuery.of(context).size.width * (discoveryRate / 100) - 32).clamp(0.0, double.infinity),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan, Colors.lightBlue, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 발견 정보
                  _buildDiscoveryInfoBadge(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    label: '발견',
                    count: _jellyfishController.discoveredJellyfishList.length,
                  ),
                  // 미발견 정보
                  _buildDiscoveryInfoBadge(
                    icon: Icons.help_outline,
                    iconColor: Colors.grey,
                    label: '미발견',
                    count: _jellyfishController.undiscoveredJellyfishList.length,
                  ),
                  // 전체 정보
                  _buildDiscoveryInfoBadge(
                    icon: Icons.grid_view,
                    iconColor: Colors.white,
                    label: '전체',
                    count: _jellyfishController.jellyfishList.length,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
  
  /// 발견 정보 배지
  Widget _buildDiscoveryInfoBadge({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 4),
          Text(
            '$label: $count',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 섹션 제목 위젯
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  
  /// 최근 발견한 해파리 섹션
  Widget _buildRecentlyDiscoveredSection() {
    return Obx(() {
      final discoveredJellyfish = _jellyfishController.discoveredJellyfishList;
      
      if (discoveredJellyfish.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search_off,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '아직 발견한 해파리가 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.identification),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '해파리 찾으러 가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      
      return SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          physics: const BouncingScrollPhysics(),
          itemCount: discoveredJellyfish.length,
          itemBuilder: (context, index) {
            final jellyfish = discoveredJellyfish[index];
            return Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              child: JellyfishCard(
                jellyfish: jellyfish,
                onTap: () => Get.toNamed(
                  AppRoutes.jellyfishDetail,
                  arguments: {'jellyfishId': jellyfish.id},
                ),
              ),
            );
          },
        ),
      );
    });
  }
  
} 