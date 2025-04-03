import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:math' show Random;
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';

/// 온보딩 화면
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  // 페이지 컨트롤러
  late final PageController _pageController;
  
  // 애니메이션 컨트롤러
  late final AnimationController _backgroundAnimationController;
  late final Animation<double> _backgroundAnimation;

  // 현재 페이지
  final RxInt _currentPage = 0.obs;

  // 온보딩 페이지 데이터
  final List<Map<String, dynamic>> _pages = [
    {
      'title': '해파리를 발견하셨나요?',
      'subtitle': '직접 발견한 해파리를 AI가 분석해드립니다',
      'image': 'assets/images/onboarding/onboarding1.png',
      'backgroundColor': const Color(0xFF084C61),
      'backgroundGradientEnd': const Color(0xFF177E89),
      'icon': Icons.search,
    },
    {
      'title': 'AI가 해파리를 감식해드립니다',
      'subtitle': '종류, 위험도, 특징까지 한번에 확인하세요',
      'image': 'assets/images/onboarding/onboarding2.png',
      'backgroundColor': const Color(0xFF177E89),
      'backgroundGradientEnd': const Color(0xFF079992),
      'icon': Icons.auto_awesome,
    },
    {
      'title': '해파리 박사가 되어보세요',
      'subtitle': '발견과 퀴즈로 경험치를 쌓고 레벨업하세요',
      'image': 'assets/images/onboarding/onboarding3.png',
      'backgroundColor': const Color(0xFF079992),
      'backgroundGradientEnd': const Color(0xFF00ADB5),
      'icon': Icons.emoji_events,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // 배경 애니메이션 설정
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.linear,
    );
    
    // 페이지 변경 리스너
    _pageController.addListener(() {
      _currentPage.value = _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              // 현재 페이지와 다음 페이지의 비율 계산
              double page = _pageController.hasClients ? _pageController.page ?? 0 : 0;
              int currentPage = page.floor();
              int nextPage = currentPage + 1;
              double pageFraction = page - currentPage;
              
              // 현재 페이지와 다음 페이지의 색상
              Color currentColor = currentPage < _pages.length 
                  ? _pages[currentPage]['backgroundColor'] as Color 
                  : _pages.last['backgroundColor'] as Color;
              Color nextColor = nextPage < _pages.length 
                  ? _pages[nextPage]['backgroundColor'] as Color 
                  : _pages.last['backgroundColor'] as Color;
              
              Color currentEndColor = currentPage < _pages.length 
                  ? _pages[currentPage]['backgroundGradientEnd'] as Color 
                  : _pages.last['backgroundGradientEnd'] as Color;
              Color nextEndColor = nextPage < _pages.length 
                  ? _pages[nextPage]['backgroundGradientEnd'] as Color 
                  : _pages.last['backgroundGradientEnd'] as Color;
              
              // 페이지 전환에 따른 색상 보간
              Color startColor = Color.lerp(currentColor, nextColor, pageFraction) ?? currentColor;
              Color endColor = Color.lerp(currentEndColor, nextEndColor, pageFraction) ?? currentEndColor;
              
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [startColor, endColor],
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _backgroundAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: MinimalPatternPainter(
                        animation: _backgroundAnimation.value,
                        startColor: startColor,
                        endColor: endColor,
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          
          // 메인 콘텐츠
          SafeArea(
            child: Column(
              children: [
                // 상단 건너뛰기 버튼
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Obx(() => _currentPage.value < _pages.length - 1
                      ? TextButton(
                          onPressed: _navigateToLogin,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white.withOpacity(0.9),
                          ),
                          child: const Text(
                            '건너뛰기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : const SizedBox()
                    ),
                  ),
                ),
                
                // 페이지 뷰
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(index);
                    },
                  ),
                ),
                
                // 하단 페이지 인디케이터 및 버튼
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 페이지 인디케이터
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage.value == index ? 24 : 8,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _currentPage.value == index 
                                  ? Colors.white 
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )),
                        ),
                      ),
                      
                      // 다음 버튼
                      Obx(() => ElevatedButton(
                        onPressed: () {
                          if (_currentPage.value < _pages.length - 1) {
                            _pageController.animateToPage(
                              _currentPage.value + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _navigateToLogin();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _currentPage.value < _pages.length 
                              ? _pages[_currentPage.value]['backgroundColor'] as Color
                              : _pages.last['backgroundColor'] as Color,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage.value < _pages.length - 1 ? '다음' : '시작하기',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 로그인 화면으로 이동
  void _navigateToLogin() {
    // 로그인 화면 구현 후 변경
    Get.toNamed('/login');
  }

  // 페이지 빌드 함수
  Widget _buildPage(int index) {
    final page = _pages[index];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이미지 또는 아이콘
          Expanded(
            flex: 5,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      page['icon'] as IconData,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 텍스트 정보
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuad,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    page['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuad,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    page['subtitle'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 미니멀한 배경 패턴
class MinimalPatternPainter extends CustomPainter {
  final double animation;
  final Color startColor;
  final Color endColor;
  
  MinimalPatternPainter({
    required this.animation,
    required this.startColor,
    required this.endColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final baseOpacity = 0.05;
    
    // 그리드 패턴
    _drawMinimalGrid(canvas, size, baseOpacity);
    
    // 부드러운 형태
    _drawSoftShapes(canvas, size, baseOpacity);
  }
  
  void _drawMinimalGrid(Canvas canvas, Size size, double baseOpacity) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(baseOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    final gridSize = 40.0;
    final offset = animation * gridSize * 0.5;
    
    // 가로선
    for (double y = offset; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y), 
        Offset(size.width, y), 
        paint,
      );
    }
    
    // 세로선
    for (double x = -offset; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0), 
        Offset(x, size.height), 
        paint,
      );
    }
  }
  
  void _drawSoftShapes(Canvas canvas, Size size, double baseOpacity) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(baseOpacity * 2)
      ..style = PaintingStyle.fill;
    
    final random = math.Random(42); // 고정된 시드로 패턴 유지
    
    // 부유하는 원형
    for (int i = 0; i < 5; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double radius = 50 + random.nextDouble() * 100;
      
      // 애니메이션에 따른 위치 조정
      double offsetX = math.sin((animation + i) * math.pi * 2) * 10;
      double offsetY = math.cos((animation + i) * math.pi * 2) * 10;
      
      canvas.drawCircle(
        Offset(x + offsetX, y + offsetY), 
        radius, 
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 