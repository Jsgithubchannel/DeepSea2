import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/presentation/widgets/jellyfish_card.dart';
import 'package:jellyfish_test/presentation/widgets/navigation_bar.dart';

/// 도감 화면
class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> with TickerProviderStateMixin {
  final JellyfishController _jellyfishController = Get.find<JellyfishController>();
  
  // 보기 모드 (0: 카드형, 1: 격자형)
  final RxInt _viewMode = 0.obs;
  
  // 필터 (0: 전체, 1: 발견, 2: 미발견)
  final RxInt _filter = 0.obs;
  
  // 현재 페이지 인덱스
  final RxInt _currentPage = 0.obs;
  
  // 탭 컨트롤러
  late TabController _tabController;
  
  // 페이지 뷰 컨트롤러
  late PageController _pageController;
  
  // 애니메이션 컨트롤러
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(viewportFraction: 0.85);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // 페이지 변경 리스너 추가
    _pageController.addListener(_onPageChanged);
    
    // 초기에는 카드형 뷰 (애니메이션이 닫힌 상태)
    _animationController.value = 0.0;
  }
  
  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  // 페이지 변경 감지
  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (_currentPage.value != page) {
      _currentPage.value = page;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
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
          child: Column(
            children: [
              _buildAppBar(),
              _buildFilterChips(),
              Expanded(
                child: Obx(() {
                  // 필터에 따라 다른 리스트 반환
                  final jellyfishList = _getFilteredList();
                  
                  // 뷰 모드에 따라 다른 UI 보여주기
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return _viewMode.value == 0
                          ? _buildCardView(jellyfishList)
                          : _buildGridView(jellyfishList);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: JellyfishNavigationBar(
        selectedIndex: 1, // 도감 탭 선택
        onTabChanged: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.home);
              break;
            case 1:
              // 이미 도감 화면
              break;
            case 2:
              Get.offAllNamed(AppRoutes.quiz);
              break;
            case 3:
              Get.offAllNamed(AppRoutes.profile);
              break;
          }
        },
        onIdentifyTap: () {
          Get.toNamed(AppRoutes.identification);
        },
      ),
    );
  }
  
  // 앱바 구현
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 타이틀
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                '해파리 도감',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          // 뷰 모드 토글 버튼
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            borderRadius: 12,
            child: Row(
              children: [
                // 카드형 버튼
                _buildViewToggleButton(
                  icon: Icons.view_carousel,
                  isSelected: _viewMode.value == 0,
                  onTap: () {
                    _viewMode.value = 0;
                    _animationController.reverse();
                  },
                ),
                
                // 그리드형 버튼
                _buildViewToggleButton(
                  icon: Icons.grid_view,
                  isSelected: _viewMode.value == 1,
                  onTap: () {
                    _viewMode.value = 1;
                    _animationController.forward();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 필터 칩 구현
  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            label: '전체',
            isSelected: _filter.value == 0,
            onTap: () => _filter.value = 0,
            count: _jellyfishController.jellyfishList.length,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: '발견',
            isSelected: _filter.value == 1,
            onTap: () => _filter.value = 1,
            count: _jellyfishController.discoveredJellyfishList.length,
            iconColor: Colors.green,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: '미발견',
            isSelected: _filter.value == 2,
            onTap: () => _filter.value = 2,
            count: _jellyfishController.undiscoveredJellyfishList.length,
            iconColor: Colors.grey,
          ),
        ],
      ),
    );
  }
  
  // 개별 필터 칩 위젯
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required int count,
    Color iconColor = Colors.blue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.blue : iconColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 뷰 모드 토글 버튼
  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          size: 20,
        ),
      ),
    );
  }
  
  // 카드형 뷰 구현
  Widget _buildCardView(List<Jellyfish> jellyfishList) {
    if (jellyfishList.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      children: [
        // 메인 카드 뷰어
        Expanded(
          flex: 3,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: jellyfishList.length,
            onPageChanged: (index) {
              _currentPage.value = index;
            },
            itemBuilder: (context, index) {
              final jellyfish = jellyfishList[index];
              return _buildDetailCard(jellyfish, index);
            },
          ),
        ),
        
        // 하단 미니 카드 리스트
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: jellyfishList.length,
            itemBuilder: (context, index) {
              final jellyfish = jellyfishList[index];
              return Obx(() => _buildMiniCard(jellyfish, index, _currentPage.value == index));
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  // 그리드형 뷰 구현
  Widget _buildGridView(List<Jellyfish> jellyfishList) {
    if (jellyfishList.isEmpty) {
      return _buildEmptyState();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: jellyfishList.length,
        itemBuilder: (context, index) {
          final jellyfish = jellyfishList[index];
          return _buildGridCard(jellyfish);
        },
      ),
    );
  }
  
  // 빈 상태 위젯
  Widget _buildEmptyState() {
    String message = '데이터가 없습니다';
    if (_filter.value == 1) {
      message = '아직 발견한 해파리가 없습니다';
    } else if (_filter.value == 2 && _jellyfishController.undiscoveredJellyfishList.isEmpty) {
      message = '모든 해파리를 발견했습니다!';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _filter.value == 1 ? Icons.search_off : Icons.celebration,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (_filter.value == 1) {
                Get.toNamed(AppRoutes.identification);
              } else {
                _filter.value = 0;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: Icon(_filter.value == 1 ? Icons.camera_alt : Icons.refresh),
            label: Text(_filter.value == 1 ? '해파리 찾으러 가기' : '전체 보기'),
          ),
        ],
      ),
    );
  }
  
  // 상세 카드 위젯
  Widget _buildDetailCard(Jellyfish jellyfish, int index) {
    final isDiscovered = jellyfish.isDiscovered;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: GestureDetector(
        onTap: () {
          if (isDiscovered) {
            Get.toNamed(
              AppRoutes.jellyfishDetail,
              arguments: {'jellyfishId': jellyfish.id},
            );
          }
        },
        child: GlassContainer(
          borderRadius: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 영역
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    // 배경 이미지
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: isDiscovered
                            ? DecorationImage(
                                image: AssetImage(jellyfish.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: isDiscovered ? null : Colors.grey.withOpacity(0.3),
                      ),
                      child: !isDiscovered
                          ? Center(
                              child: Icon(
                                Icons.help_outline,
                                size: 80,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            )
                          : null,
                    ),
                    
                    // 위험도 배지
                    if (isDiscovered)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: jellyfish.dangerColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getDangerText(jellyfish.dangerLevel),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                    // 번호 배지
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '#${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 정보 영역
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 이름 및 발견 상태
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isDiscovered ? jellyfish.name : '???',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isDiscovered)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                        ],
                      ),
                      
                      // 학명
                      if (isDiscovered)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            jellyfish.scientificName,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        
                      const Spacer(),
                      
                      // 퀴즈 정보 및 발견 날짜
                      if (isDiscovered)
                        Row(
                          children: [
                            // 퀴즈 진행 상태
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.quiz,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '퀴즈 1/3',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // 발견 날짜
                            Text(
                              '발견: ${jellyfish.discoveredAt?.toIso8601String().substring(0, 10) ?? '2023-04-01'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.white.withOpacity(0.6),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '아직 발견되지 않음',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
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
  
  // 미니 카드 위젯
  Widget _buildMiniCard(Jellyfish jellyfish, int index, bool isSelected) {
    final isDiscovered = jellyfish.isDiscovered;
    
    return GestureDetector(
      onTap: () {
        // 페이지 뷰 이동
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Colors.blue.withOpacity(0.8) 
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          image: isDiscovered
              ? DecorationImage(
                  image: AssetImage(jellyfish.imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
          color: isDiscovered ? null : Colors.grey.withOpacity(0.3),
        ),
        child: !isDiscovered
            ? Center(
                child: Icon(
                  Icons.help_outline,
                  color: Colors.white.withOpacity(0.4),
                ),
              )
            : Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withOpacity(0.8)
                        : Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
  
  // 그리드 카드 위젯
  Widget _buildGridCard(Jellyfish jellyfish) {
    final isDiscovered = jellyfish.isDiscovered;
    
    return GestureDetector(
      onTap: () {
        if (isDiscovered) {
          Get.toNamed(
            AppRoutes.jellyfishDetail,
            arguments: {'jellyfishId': jellyfish.id},
          );
        }
      },
      child: GlassContainer(
        borderRadius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: isDiscovered
                      ? DecorationImage(
                          image: AssetImage(jellyfish.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: isDiscovered ? null : Colors.grey.withOpacity(0.3),
                ),
                child: !isDiscovered
                    ? Center(
                        child: Icon(
                          Icons.help_outline,
                          size: 40,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      )
                    : Stack(
                        children: [
                          // 위험도 배지
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: jellyfish.dangerColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getDangerText(jellyfish.dangerLevel),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            
            // 정보 영역
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름
                    Text(
                      isDiscovered ? jellyfish.name : '???',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (isDiscovered)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          jellyfish.scientificName,
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                    const Spacer(),
                    
                    // 상태 정보
                    Row(
                      children: [
                        if (isDiscovered)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '발견',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '미발견',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                        const Spacer(),
                        
                        // 퀴즈 정보
                        if (isDiscovered)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.quiz,
                                  color: Colors.amber,
                                  size: 10,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '1/3',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.9),
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
            ),
          ],
        ),
      ),
    );
  }
  
  // 필터에 따라 적절한 리스트 반환
  List<Jellyfish> _getFilteredList() {
    switch (_filter.value) {
      case 1:
        return _jellyfishController.discoveredJellyfishList;
      case 2:
        return _jellyfishController.undiscoveredJellyfishList;
      default:
        return _jellyfishController.jellyfishList;
    }
  }
  
  // 위험도 텍스트 반환
  String _getDangerText(DangerLevel level) {
    switch (level) {
      case DangerLevel.safe:
        return '안전';
      case DangerLevel.mild:
        return '경미';
      case DangerLevel.moderate:
        return '보통';
      case DangerLevel.severe:
        return '심각';
      case DangerLevel.deadly:
        return '치명적';
    }
  }
} 