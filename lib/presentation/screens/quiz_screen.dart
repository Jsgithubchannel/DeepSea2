import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/presentation/widgets/navigation_bar.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/data/models/exp_constants.dart';
import 'package:lottie/lottie.dart';

/// 퀴즈 모델 클래스
class Quiz {
  final String id;
  final String title;
  final String description;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final QuizType type;
  final DateTime? releaseDate;
  final DateTime? expiryDate;
  final bool isCompleted;
  final String? imagePath;
  final int points;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.type,
    this.releaseDate,
    this.expiryDate,
    this.isCompleted = false,
    this.imagePath,
    this.points = 0,
  });

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? question,
    List<String>? options,
    int? correctAnswer,
    String? explanation,
    QuizType? type,
    DateTime? releaseDate,
    DateTime? expiryDate,
    bool? isCompleted,
    String? imagePath,
    int? points,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      type: type ?? this.type,
      releaseDate: releaseDate ?? this.releaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isCompleted: isCompleted ?? this.isCompleted,
      imagePath: imagePath ?? this.imagePath,
      points: points ?? this.points,
    );
  }
}

/// 퀴즈 타입 열거형
enum QuizType {
  daily,    // 일일 퀴즈
  emergency // 돌발 퀴즈
}

/// 퀴즈 화면
class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  // 현재 탭 (0: 일일 퀴즈, 1: 돌발 퀴즈, 2: 완료한 퀴즈)
  final RxInt _currentTab = 0.obs;

  // 탭 컨트롤러
  late TabController _tabController;

  // 페이지 컨트롤러
  late PageController _pageController;

  // 점수 관리
  final RxInt _totalScore = 350.obs;

  // 임시 퀴즈 데이터
  final RxList<Quiz> _quizzes = <Quiz>[
    // 일일 퀴즈
    Quiz(
      id: 'daily-1',
      title: '해파리 생존 전략',
      description: '오늘의 해파리 상식 퀴즈',
      question: '해파리는 위험에 처했을 때 주로 어떤 방어 메커니즘을 사용하나요?',
      options: [
        '빠르게 수영하여 도망친다',
        '독성 촉수를 이용해 공격한다',
        '몸을 투명하게 만들어 숨는다',
        '껍질 속으로 몸을 숨긴다'
      ],
      correctAnswer: 1,
      explanation: '해파리는 독성이 있는 촉수를 이용해 자신을 방어합니다. 이 독침은 작은 낭포(nematocysts)에 들어있으며, 위협을 느끼면 촉수를 뻗어 독을 주입합니다.',
      type: QuizType.daily,
      releaseDate: DateTime.now(),
      isCompleted: false,
      imagePath: 'assets/images/quiz/jellyfish_defense.jpg',
      points: 100,
    ),
    Quiz(
      id: 'daily-2',
      title: '해파리 생태계',
      description: '내일의 해파리 상식 퀴즈',
      question: '해파리는 주로 어떤 환경에서 번식하나요?',
      options: [
        '맑고 차가운 물',
        '오염되고 따뜻한 물',
        '깊은 바다',
        '담수(민물)'
      ],
      correctAnswer: 1,
      explanation: '해파리는 오염되고 따뜻한 바다에서 더 잘 번식하는 경향이 있습니다. 기후 변화와 해양 오염은 해파리 개체수 증가의 주요 원인으로 지목됩니다.',
      type: QuizType.daily,
      releaseDate: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
      imagePath: 'assets/images/quiz/jellyfish_bloom.jpg',
      points: 100,
    ),
    
    // 돌발 퀴즈
    Quiz(
      id: 'emergency-1',
      title: '해파리 쏘임 응급처치',
      description: '응급 상황에 꼭 필요한 지식!',
      question: '해파리에 쏘였을 때 가장 먼저 해야 할 올바른 조치는 무엇인가요?',
      options: [
        '상처 부위를 담수(민물)로 씻는다',
        '소변을 상처에 바른다',
        '식초를 상처 부위에 바른다',
        '상처 부위를 문지른다'
      ],
      correctAnswer: 2,
      explanation: '해파리에 쏘였을 때는 식초를 상처 부위에 바르는 것이 가장 효과적입니다. 식초는 아직 발사되지 않은 자상 세포(nematocysts)의 활성화를 막아줍니다. 담수로 씻거나 상처를 문지르는 것은 독이 더 퍼질 수 있어 위험합니다.',
      type: QuizType.emergency,
      expiryDate: DateTime.now().add(const Duration(hours: 3)),
      isCompleted: false,
      imagePath: 'assets/images/quiz/jellyfish_sting.jpg',
      points: 150,
    ),
    // 완료한 돌발 퀴즈 (isCompleted를 false로 변경)
    Quiz(
      id: 'emergency-2',
      title: '해파리 종류 구분',
      description: '긴급! 위험한 해파리를 구분하세요',
      question: '다음 중 가장 독성이 강한 해파리는?',
      options: [
        '문어해파리',
        '작은부레관해파리',
        '상자해파리',
        '보름달물해파리'
      ],
      correctAnswer: 2,
      explanation: '상자해파리(Box jellyfish)는 세계에서 가장 독성이 강한 해양 생물 중 하나로, 그 독은 심각한 통증, 심장 마비, 심지어 사망까지 초래할 수 있습니다.',
      type: QuizType.emergency,
      expiryDate: DateTime.now().subtract(const Duration(hours: 1)),
      isCompleted: false,
      imagePath: 'assets/images/quiz/box_jellyfish.jpg',
      points: 150,
    ),
  ].obs;

  // 타이머 관련 변수
  final RxInt _remainingSeconds = 0.obs;
  final RxDouble _timerProgress = 0.0.obs;

  // 유저 컨트롤러
  final UserController _userController = Get.find<UserController>();

  // 완료된 퀴즈 목록 (RxSet 대신 RxList 사용)
  final RxList<Quiz> _completedQuizzes = <Quiz>[].obs;

  // 경험치 획득 애니메이션 컨트롤러
  late AnimationController _expAnimationController;
  late Animation<double> _expAnimation;
  
  // 축하 애니메이션 컨트롤러
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;
  
  // 현재 퀴즈 결과 상태
  final RxBool _showQuizResult = false.obs;
  final RxBool _isCorrectAnswer = false.obs;
  final Rx<Quiz> _currentQuiz = Quiz(
    id: '',
    title: '',
    description: '',
    question: '',
    options: [],
    correctAnswer: 0,
    explanation: '',
    type: QuizType.daily,
  ).obs;

  @override
  void initState() {
    super.initState();
    
    // 탭 컨트롤러 초기화
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _currentTab.value = _tabController.index;
    });
    
    // 페이지 컨트롤러 초기화
    _pageController = PageController();
    
    // 애니메이션 컨트롤러 초기화
    _expAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _expAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _expAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    
    // 축하 애니메이션 컨트롤러
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 축하 애니메이션 초기화
    _celebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // 비동기로 완료된 퀴즈 초기화
    _initCompletedQuizzesAsync();
    
    // 돌발 퀴즈 타이머 설정
    _updateEmergencyQuizTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _expAnimationController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }
  
  // 돌발 퀴즈 타이머 업데이트
  void _updateEmergencyQuizTimer() {
    final emergencyQuizzes = _quizzes.where((q) => q.type == QuizType.emergency && !q.isCompleted).toList();
    
    if (emergencyQuizzes.isNotEmpty && emergencyQuizzes[0].expiryDate != null) {
      final now = DateTime.now();
      final expiry = emergencyQuizzes[0].expiryDate!;
      
      if (expiry.isAfter(now)) {
        final diff = expiry.difference(now);
        _remainingSeconds.value = diff.inSeconds;
        _timerProgress.value = diff.inSeconds / (3 * 60 * 60); // 3시간 기준
        
        // 1초마다 타이머 업데이트
        Future.delayed(const Duration(seconds: 1), _updateEmergencyQuizTimer);
      } else {
        _remainingSeconds.value = 0;
        _timerProgress.value = 0;
      }
    } else {
      _remainingSeconds.value = 0;
      _timerProgress.value = 0;
    }
  }
  
  String _formatTimeRemaining(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDailyQuizTab(),
                        _buildEmergencyQuizTab(),
                        _buildCompletedQuizTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 경험치 획득 알림 (개선된 애니메이션)
          Obx(() => _userController.showExpNotification
            ? Positioned(
                top: MediaQuery.of(context).padding.top + 60,
                left: 0,
                right: 0,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    onEnd: () {
                      // 끝날 때 약간의 흔들림 효과
                      _expAnimationController.forward(from: 0.0);
                    },
                    child: AnimatedBuilder(
                      animation: _expAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            0,
                            sin(_expAnimation.value * 3 * 3.14) * 5,
                          ),
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 30,
                                ),
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0.5, end: 1.5),
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Opacity(
                                        opacity: 2 - value,
                                        child: const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '경험치 획득!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '+${_userController.recentExp} EXP',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
          ),
          
          // 축하 효과 (파티클 대신 별 아이콘으로 대체)
          Obx(() => _userController.showExpNotification 
            ? _buildCelebrationEffect()
            : SizedBox.shrink()
          ),
          
          // 퀴즈 결과 오버레이
          _buildQuizResultOverlay(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: JellyfishNavigationBar(
        selectedIndex: 2, // 퀴즈 탭 선택
        onTabChanged: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.home);
              break;
            case 1:
              Get.offAllNamed(AppRoutes.collection);
              break;
            case 2:
              // 이미 퀴즈 화면
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

  // 앱바 구현 (사용자 경험치 정보 추가)
  Widget _buildAppBar() {
    final userController = _userController;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 타이틀
          Row(
            children: [
              Icon(Icons.quiz, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                '해파리 퀴즈',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          
          // 유저 레벨 및 경험치 표시
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.profile),
            child: Obx(() => GlassContainer(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: 12,
              child: Row(
                children: [
                  // 레벨 뱃지
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${userController.user.level}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  
                  // 경험치 표시
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 사용자 이름
                      Text(
                        userController.user.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      // 경험치 프로그레스 바
                      SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: Stack(
                          children: [
                            // 배경
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                            
                            // 진행 상태
                            Container(
                              height: 5,
                              width: 80 * userController.user.levelProgress,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  // 탭바 구현
  Widget _buildTabBar() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.blue.withOpacity(0.3),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        tabs: [
          Tab(text: '일일 퀴즈'),
          Tab(text: '돌발 퀴즈'),
          Tab(text: '완료한 퀴즈'),
        ],
      ),
    );
  }

  // 일일 퀴즈 탭
  Widget _buildDailyQuizTab() {
    final dailyQuizzes = _quizzes.where((q) => q.type == QuizType.daily).toList();
    
    if (dailyQuizzes.isEmpty) {
      return _buildEmptyState('아직 퀴즈가 없습니다.', Icons.pending_actions);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '매일 새로운 퀴즈에 도전하세요!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: dailyQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = dailyQuizzes[index];
              // 오늘 퀴즈인지 확인
              final isToday = quiz.releaseDate?.day == DateTime.now().day;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: _buildQuizCard(
                  quiz,
                  isLocked: !isToday && !quiz.isCompleted,
                  isCompleted: quiz.isCompleted,
                  subtitle: isToday ? '오늘의 퀴즈' : '내일의 퀴즈',
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 돌발 퀴즈 탭
  Widget _buildEmergencyQuizTab() {
    final emergencyQuizzes = _quizzes.where((q) => 
      q.type == QuizType.emergency && 
      !q.isCompleted && 
      (q.expiryDate?.isAfter(DateTime.now()) ?? false)
    ).toList();
    
    if (emergencyQuizzes.isEmpty) {
      return _buildEmptyState('현재 진행 중인 돌발 퀴즈가 없습니다.', Icons.warning_amber);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.timer, color: Colors.redAccent, size: 20),
              SizedBox(width: 8),
              Obx(() => Text(
                '남은 시간: ${_formatTimeRemaining(_remainingSeconds.value)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() => LinearProgressIndicator(
            value: _timerProgress.value,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          )),
        ),
        SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: emergencyQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = emergencyQuizzes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: _buildQuizCard(
                  quiz,
                  isEmergency: true,
                  subtitle: '긴급 퀴즈',
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 완료된 퀴즈 탭 빌드
  Widget _buildCompletedQuizTab() {
    print('완료된 퀴즈 탭 빌드: ${_completedQuizzes.length}개');
    
    return Obx(() {
      List<Quiz> completedQuizzes = _completedQuizzes.toList();
      print('표시할 완료된 퀴즈 수: ${completedQuizzes.length}');
      
      if (completedQuizzes.isEmpty) {
        return _buildEmptyState('아직 완료한 퀴즈가 없습니다.', Icons.check_circle_outline);
      }
      
      return ListView.builder(
        itemCount: completedQuizzes.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemBuilder: (context, index) {
          final quiz = completedQuizzes[index];
          print('완료된 퀴즈 표시: ${quiz.id} - ${quiz.title}');
          return _buildCompletedQuizItem(quiz);
        },
      );
    });
  }

  // 퀴즈 카드 위젯
  Widget _buildQuizCard(
    Quiz quiz, {
    bool isLocked = false,
    bool isEmergency = false,
    bool isCompleted = false,
    String? subtitle,
  }) {
    // 카드 클릭 시 동작 정의
    void onCardTap() {
      bool isQuizCompleted = quiz.isCompleted || _completedQuizzes.any((q) => q.id == quiz.id);
      
      if (isLocked) {
        // 잠긴 퀴즈는 정보만 표시
        Get.snackbar(
          '아직 풀 수 없는 퀴즈입니다',
          '해당 퀴즈는 아직 풀 수 없습니다.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (isQuizCompleted) {
        // 완료된 퀴즈는 상세 정보 표시
        _viewCompletedQuizInfo(quiz);
      } else {
        // 풀 수 있는 퀴즈는 시작
        _startQuiz(quiz);
      }
    }

    return GestureDetector(
      onTap: onCardTap,
      child: GlassContainer(
        borderRadius: 20,
        child: Stack(
          children: [
            // 배경 이미지
            if (quiz.imagePath != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      quiz.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ),
            
            // 그라데이션 오버레이
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            
            // 완료 표시 배지
            if (isCompleted)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '완료',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // 콘텐츠
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 정보 (서브타이틀, 타입 배지)
                  Row(
                    children: [
                      if (subtitle != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isEmergency 
                                ? Colors.red.withOpacity(0.3) 
                                : Colors.blue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Spacer(),
                      if (isEmergency)
                        Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.redAccent, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '긴급',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  
                  Spacer(),
                  
                  // 퀴즈 제목
                  Text(
                    quiz.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // 퀴즈 설명
                  Text(
                    quiz.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // 퀴즈 시작 버튼 또는 잠금 표시
                  if (isLocked)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock, color: Colors.white.withOpacity(0.6), size: 20),
                          SizedBox(width: 8),
                          Text(
                            '아직 열리지 않았습니다',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isCompleted)
                    ElevatedButton.icon(
                      onPressed: () => _viewCompletedQuizInfo(quiz),
                      icon: Icon(Icons.info_outline),
                      label: Text('퀴즈 정보 보기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _startQuiz(quiz),
                      icon: Icon(isEmergency ? Icons.warning : Icons.play_arrow),
                      label: Text(isEmergency ? '긴급 퀴즈 풀기' : '퀴즈 시작'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEmergency ? Colors.redAccent : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 완료한 퀴즈 아이템 위젯
  Widget _buildCompletedQuizItem(Quiz quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        borderRadius: 12,
        child: Row(
          children: [
            // 퀴즈 유형 아이콘
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: quiz.type == QuizType.emergency 
                    ? Colors.redAccent.withOpacity(0.2) 
                    : Colors.blue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  quiz.type == QuizType.emergency ? Icons.warning : Icons.calendar_today,
                  color: quiz.type == QuizType.emergency ? Colors.redAccent : Colors.blue,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 12),
            
            // 퀴즈 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    quiz.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // 다시 보기 버튼
            IconButton(
              onPressed: () => _viewQuizDetails(quiz),
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.7), size: 16),
            ),
          ],
        ),
      ),
    );
  }

  // 빈 상태 위젯
  Widget _buildEmptyState(String message, IconData icon) {
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
              icon,
              color: Colors.white.withOpacity(0.5),
              size: 50,
            ),
          ),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 퀴즈 시작 함수 (개선된 UI)
  void _startQuiz(Quiz quiz) {
    print('퀴즈 시작 시도: ${quiz.id} - ${quiz.title}');
    
    // 완료 여부 확인 (두 가지 방법으로 확인)
    bool isQuizCompleted = quiz.isCompleted || _completedQuizzes.any((q) => q.id == quiz.id);
    print('퀴즈 완료 여부: isCompleted=${quiz.isCompleted}, _completedQuizzes에 포함=${_completedQuizzes.any((q) => q.id == quiz.id)}');
    
    // 이미 완료된 퀴즈인 경우 상세 정보 표시
    if (isQuizCompleted) {
      print('완료된 퀴즈이므로 상세 정보 표시');
      _viewCompletedQuizInfo(quiz);
      return;
    }
    
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 퀴즈 유형 배지
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: quiz.type == QuizType.emergency
                  ? Colors.redAccent.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                quiz.type == QuizType.emergency ? '긴급 퀴즈' : '일일 퀴즈',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: quiz.type == QuizType.emergency ? Colors.redAccent : Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // 퀴즈 제목
            Text(
              quiz.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            
            // 퀴즈 설명
            Text(
              quiz.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            
            // 문제
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                quiz.question,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // 보상 포인트 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '정답 보상: ${quiz.type == QuizType.emergency ? 
                      ExpConstants.EMERGENCY_QUIZ_CORRECT :
                      ExpConstants.DAILY_QUIZ_CORRECT} EXP',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // 선택지
            ...List.generate(
              quiz.options.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    _showQuizResult.value = true;
                    _currentQuiz.value = quiz;
                    
                    final String answer = quiz.options[index];
                    final int answerIndex = quiz.options.indexOf(answer);
                    _isCorrectAnswer.value = answerIndex == quiz.correctAnswer;
                    
                    // 정답 처리
                    if (_isCorrectAnswer.value) {
                      // 애니메이션 준비
                      Future.delayed(Duration(milliseconds: 1800), () {
                        _processQuizAnswer(quiz, answer);
                      });
                    } else {
                      // 오답 처리
                      Future.delayed(Duration(milliseconds: 1800), () {
                        _showQuizResult.value = false;
                        Get.snackbar(
                          '오답입니다!',
                          '다시 시도해보세요.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    quiz.options[index],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// 퀴즈 ID 문자열에서 유형을 포함한 고유 ID 생성
  String _getUniqueQuizId(String idString) {
    // 형식: 'daily-1', 'emergency-2' 등에서 유형과 번호를 추출하여 고유 ID 생성
    final typeRegex = RegExp(r'^([a-z]+)-(\d+)$');
    final match = typeRegex.firstMatch(idString);
    
    if (match != null && match.groupCount >= 2) {
      final type = match.group(1); // 'daily' 또는 'emergency'
      final number = match.group(2); // 숫자 부분
      return '${type}_${number}'; // 예: 'daily_1', 'emergency_1'
    }
    
    // 기본값 반환
    return idString;
  }

  /// 퀴즈 답변 처리
  void _processQuizAnswer(Quiz quiz, String answer) {
    final uniqueId = _getUniqueQuizId(quiz.id);
    print('퀴즈 답변 처리 시작: ${quiz.id} (고유ID: $uniqueId) - ${quiz.title} - 타입: ${quiz.type}');
    
    // 이미 완료된 퀴즈인 경우 처리하지 않음
    if (_completedQuizzes.any((q) => q.id == quiz.id)) {
      print('이미 완료된 퀴즈입니다: ${quiz.id}');
      _showQuizResult.value = false;
      return;
    }
    
    // 정답 체크: answer 문자열이 어떤 인덱스의 옵션인지 확인
    final int answerIndex = quiz.options.indexOf(answer);
    if (answerIndex == -1) {
      // 유효하지 않은 답변
      Get.snackbar(
        '오류',
        '유효하지 않은 답변입니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      _showQuizResult.value = false;
      return;
    }
    
    final isCorrect = answerIndex == quiz.correctAnswer;
    print('정답 여부: $isCorrect');
    
    if (isCorrect) {
      try {
        // 이전 레벨 저장
        final prevLevel = _userController.user.level;
        
        // 고유 퀴즈 ID 문자열 생성
        final uniqueQuizId = _getUniqueQuizId(quiz.id);
        print('고유 퀴즈 ID: $uniqueQuizId');
        
        // 정답인 경우 포인트 추가 (퀴즈 타입에 따라 다른 함수 호출)
        if (quiz.type == QuizType.emergency) {
          print('긴급 퀴즈 경험치 추가: ${ExpConstants.EMERGENCY_QUIZ_CORRECT}');
          _userController.addEmergencyQuizExp();
        } else {
          print('일일 퀴즈 경험치 추가: ${ExpConstants.DAILY_QUIZ_CORRECT}');
          _userController.addDailyQuizExp();
        }
        
        // 문자열 ID로만 완료 목록 업데이트 (숫자 ID는 더 이상 사용하지 않음)
        _userController.addCompletedQuizString(uniqueQuizId);
        print('사용자 완료 퀴즈 목록에 추가됨: $uniqueQuizId');
        
        // 업데이트 후 사용자 완료 퀴즈 목록 확인
        _userController.getCompletedQuizStringsAsync().then((ids) {
          print('현재 완료된 퀴즈 문자열 ID: $ids');
        });
        
        // 정답 처리 및 UI 업데이트 - 인덱스 대신 ID로 찾기
        final index = _quizzes.indexWhere((q) => q.id == quiz.id);
        if (index != -1) {
          // 완료된 퀴즈로 표시
          final updatedQuiz = quiz.copyWith(isCompleted: true);
          print('퀴즈 완료 상태 업데이트: ${updatedQuiz.id} - isCompleted: ${updatedQuiz.isCompleted}');
          
          // 퀴즈 목록 업데이트 (직접 인덱스로 접근)
          _quizzes[index] = updatedQuiz;
          
          // 완료된 퀴즈 목록에 추가
          if (!_completedQuizzes.any((q) => q.id == updatedQuiz.id)) {
            _completedQuizzes.add(updatedQuiz);
            print('완료된 퀴즈 목록에 추가됨: ${updatedQuiz.id}');
          }
          
          // 목록 갱신 강제
          _quizzes.refresh();
          _completedQuizzes.refresh();
          
          print('완료된 퀴즈 수: ${_completedQuizzes.length}');
          
          // 결과 화면 숨기기 (지연 시간 늘림)
          Future.delayed(Duration(milliseconds: 1000), () {
            // 결과 창 먼저 닫기
            _showQuizResult.value = false;
            
            // 잠시 대기 후 탭 전환 및 레벨업 처리
            Future.delayed(Duration(milliseconds: 300), () {
              // 완료된 퀴즈 탭으로 이동
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _tabController.animateTo(2);
              });
              
              // 레벨업 체크 (추가 지연)
              Future.delayed(Duration(milliseconds: 300), () {
                if (_userController.user.level > prevLevel) {
                  _showLevelUpDialog(prevLevel, _userController.user.level);
                }
              });
            });
          });
        } else {
          // 퀴즈를 찾지 못한 경우
          print('퀴즈를 찾을 수 없음: ${quiz.id}');
          Get.snackbar(
            '오류',
            '퀴즈 정보를 업데이트할 수 없습니다.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
          _showQuizResult.value = false;
        }
      } catch (e) {
        // 에러 처리
        print('퀴즈 처리 중 오류 발생: $e');
        Get.snackbar(
          '오류',
          '퀴즈 처리 중 오류가 발생했습니다.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        _showQuizResult.value = false;
      }
    } else {
      // 오답 처리
      Future.delayed(Duration(milliseconds: 1800), () {
        _showQuizResult.value = false;
        Get.snackbar(
          '오답입니다!',
          '다시 시도해보세요.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      });
    }
  }
  
  // 레벨업 축하 다이얼로그
  void _showLevelUpDialog(int prevLevel, int newLevel) {
    // 애니메이션 컨트롤러 재설정 및 시작
    _celebrationController.reset();
    _celebrationController.forward();
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 레벨업 아이콘 애니메이션
              TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.blue,
                              size: 50,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'LV. $newLevel',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                '레벨 업!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(text: '축하합니다! '),
                    TextSpan(
                      text: 'Lv.$prevLevel → Lv.$newLevel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    TextSpan(text: '로 레벨업 했습니다.'),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                '새로운 칭호: ${ExpConstants.LEVEL_TITLES[newLevel] ?? "해파리 마스터"}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 완료한 퀴즈 정보 보기
  void _viewCompletedQuizInfo(Quiz quiz) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '완료한 퀴즈',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              quiz.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              quiz.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '문제: ${quiz.question}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '정답: ${quiz.options[quiz.correctAnswer]}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '해설: ${quiz.explanation}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '획득한 점수: ${quiz.points}점',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber[800],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('닫기'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 완료한 퀴즈 상세 보기 함수
  void _viewQuizDetails(Quiz quiz) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quiz.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              quiz.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '문제: ${quiz.question}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '정답: ${quiz.options[quiz.correctAnswer]}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '해설: ${quiz.explanation}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('닫기'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 퀴즈 결과 오버레이
  Widget _buildQuizResultOverlay() {
    return Obx(() => _showQuizResult.value
      ? Container(
          color: Colors.black.withOpacity(0.7),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0.1, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                width: 280,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 결과 아이콘 (Lottie 애니메이션이 없을 경우 아이콘으로 대체)
                    _isCorrectAnswer.value
                      ? _buildResultIcon(true)
                      : _buildResultIcon(false),
                    SizedBox(height: 16),
                    
                    // 결과 메시지
                    Text(
                      _isCorrectAnswer.value ? '정답입니다!' : '오답입니다!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isCorrectAnswer.value ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 12),
                    
                    // 정답 및 설명
                    if (!_isCorrectAnswer.value) ...[
                      Text(
                        '정답: ${_currentQuiz.value.options[_currentQuiz.value.correctAnswer]}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                    ],
                    
                    // 설명
                    Text(
                      _currentQuiz.value.explanation,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    
                    // 확인 버튼
                    ElevatedButton(
                      onPressed: () {
                        _showQuizResult.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCorrectAnswer.value ? Colors.green : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('확인'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      : SizedBox.shrink(),
    );
  }

  // 결과 아이콘 위젯 (Lottie 애니메이션 대신 사용)
  Widget _buildResultIcon(bool isCorrect) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 80,
              ),
            );
          },
        ),
      ),
    );
  }

  // 축하 효과 (파티클 대신 별 아이콘으로 대체)
  Widget _buildCelebrationEffect() {
    // 이미 애니메이션이 실행 중인지 확인
    if (!_celebrationController.isAnimating) {
      _celebrationController.reset();
      _celebrationController.forward();
    }
    
    return AnimatedBuilder(
      animation: _celebrationController,
      builder: (context, child) {
        return Stack(
          children: List.generate(20, (index) {
            final random = Random();
            final size = random.nextDouble() * 20 + 10;
            final x = random.nextDouble() * MediaQuery.of(context).size.width;
            final y = random.nextDouble() * MediaQuery.of(context).size.height * 0.6;
            final progress = _celebrationController.value;
            
            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: (1 - progress) * 0.8,
                child: Transform.translate(
                  offset: Offset(
                    0, 
                    progress * 100,
                  ),
                  child: Icon(
                    Icons.star,
                    size: size,
                    color: Colors.primaries[index % Colors.primaries.length],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// 완료된 퀴즈 비동기 초기화
  Future<void> _initCompletedQuizzesAsync() async {
    try {
      // 완료된 퀴즈 목록 비우기
      _completedQuizzes.clear();
      
      // 퀴즈 완료 문자열 ID 목록 (새 방식 - 비동기 호출)
      final completedStrings = await _userController.getCompletedQuizStringsAsync();
      
      print('초기화: 완료된 퀴즈 문자열 ID 목록: $completedStrings');
      
      // 각 퀴즈에 대해 완료 여부 확인
      for (var i = 0; i < _quizzes.length; i++) {
        final quiz = _quizzes[i];
        final uniqueId = _getUniqueQuizId(quiz.id);
        
        // 사용자가 완료한 퀴즈인지 확인 (문자열 ID로)
        if (completedStrings.contains(uniqueId)) {
          print('완료된 퀴즈 찾음 (문자열 ID): ${quiz.id} (고유ID: $uniqueId) - 타입: ${quiz.type}');
          
          // 완료 상태로 퀴즈 업데이트
          final updatedQuiz = quiz.copyWith(isCompleted: true);
          _quizzes[i] = updatedQuiz;
          
          // 완료된 퀴즈 목록에 추가
          _completedQuizzes.add(updatedQuiz);
        }
      }
      
      // UI 갱신
      setState(() {
        // 목록 갱신
        _quizzes.refresh();
        _completedQuizzes.refresh();
      });
      
      print('초기화 완료 - 완료된 퀴즈 수: ${_completedQuizzes.length}');
    } catch (e) {
      print('완료된 퀴즈 초기화 중 오류 발생: $e');
    }
  }
} 