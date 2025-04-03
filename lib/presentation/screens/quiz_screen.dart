import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/presentation/widgets/navigation_bar.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _currentTab.value = _tabController.index;
      }
    });
    
    _pageController = PageController(viewportFraction: 0.9);
    
    // 돌발 퀴즈 타이머 설정
    _updateEmergencyQuizTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
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

  // 앱바 구현
  Widget _buildAppBar() {
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
          // 퀴즈 점수 표시
          GlassContainer(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            borderRadius: 12,
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Obx(() => Text(
                  '${_totalScore.value}점',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              ],
            ),
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

  // 완료한 퀴즈 탭
  Widget _buildCompletedQuizTab() {
    final completedQuizzes = _quizzes.where((q) => q.isCompleted).toList();
    
    if (completedQuizzes.isEmpty) {
      return _buildEmptyState('아직 완료한 퀴즈가 없습니다.', Icons.check_circle_outline);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '완료한 퀴즈 ${completedQuizzes.length}개',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: completedQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = completedQuizzes[index];
              return _buildCompletedQuizItem(quiz);
            },
          ),
        ),
      ],
    );
  }

  // 퀴즈 카드 위젯
  Widget _buildQuizCard(
    Quiz quiz, {
    bool isLocked = false,
    bool isEmergency = false,
    bool isCompleted = false,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: isLocked || isCompleted ? () => _viewCompletedQuizInfo(quiz) : () => _startQuiz(quiz),
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

  // 퀴즈 시작 함수
  void _startQuiz(Quiz quiz) {
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
              quiz.question,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            ...List.generate(
              quiz.options.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _answerQuiz(quiz, index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Text(quiz.options[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 퀴즈 응답 처리 함수
  void _answerQuiz(Quiz quiz, int selectedAnswer) {
    bool isCorrect = selectedAnswer == quiz.correctAnswer;
    
    Get.back(); // 퀴즈 시트 닫기
    
    // 답변 결과 표시
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
            // 결과 아이콘
            Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green[100] : Colors.red[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // 결과 텍스트
            Text(
              isCorrect ? '정답입니다!' : '틀렸습니다!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            
            // 정답 표시
            if (!isCorrect)
              Text(
                '정답: ${quiz.options[quiz.correctAnswer]}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 16),
            
            // 해설
            Text(
              '해설: ${quiz.explanation}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            
            // 획득 점수 표시 (정답일 경우에만)
            if (isCorrect)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber[800], size: 20),
                    SizedBox(width: 8),
                    Text(
                      '+${quiz.points} 점',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 24),
            
            // 확인 버튼
            ElevatedButton(
              onPressed: () {
                Get.back();
                
                if (isCorrect) {
                  // 인덱스를 찾아서 직접 퀴즈 객체를 업데이트
                  int index = _quizzes.indexWhere((q) => q.id == quiz.id);
                  if (index != -1) {
                    // 수정된 방법: GetX의 반응형 상태 관리 활용
                    // 1. 새로운 리스트 생성
                    List<Quiz> updatedQuizzes = [..._quizzes];
                    
                    // 2. 새 퀴즈 객체로 교체
                    updatedQuizzes[index] = Quiz(
                      id: quiz.id,
                      title: quiz.title,
                      description: quiz.description,
                      question: quiz.question,
                      options: quiz.options,
                      correctAnswer: quiz.correctAnswer,
                      explanation: quiz.explanation,
                      type: quiz.type,
                      releaseDate: quiz.releaseDate,
                      expiryDate: quiz.expiryDate,
                      isCompleted: true,
                      imagePath: quiz.imagePath,
                      points: quiz.points,
                    );
                    
                    // 3. 리스트 전체를 교체 (GetX에서 더 확실하게 감지됨)
                    _quizzes.value = updatedQuizzes;
                    
                    // 4. 점수 추가
                    _totalScore.value += quiz.points;
                    
                    // 5. 강제 업데이트 호출
                    _quizzes.refresh();
                    
                    // 완료 후 완료된 퀴즈 탭으로 이동
                    _tabController.animateTo(2); // 완료한 퀴즈 탭 인덱스(2)로 이동
                    
                    // 상태 디버깅
                    print('완료된 퀴즈 수: ${_quizzes.where((q) => q.isCompleted).length}');
                    print('퀴즈 ID: ${quiz.id}, isCompleted: true');
                    print('업데이트된 퀴즈 리스트 길이: ${_quizzes.length}');
                    print('총 점수: ${_totalScore.value}');
                    
                    // 성공 메시지 표시
                    Get.snackbar(
                      '완료',
                      '퀴즈 완료! +${quiz.points}점을 획득했습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.withOpacity(0.7),
                      colorText: Colors.white,
                      margin: EdgeInsets.all(16),
                      duration: Duration(seconds: 2),
                    );
                  } else {
                    Get.snackbar(
                      '오류',
                      '퀴즈를 찾을 수 없습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.7),
                      colorText: Colors.white,
                      margin: EdgeInsets.all(16),
                    );
                  }
                } else {
                  // 오답일 경우 메시지만 표시
                  Get.snackbar(
                    '오답',
                    '정답을 확인하고 다시 시도해보세요!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange.withOpacity(0.7),
                    colorText: Colors.white,
                    margin: EdgeInsets.all(16),
                    duration: Duration(seconds: 2),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('확인'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 완료된 퀴즈 정보 보기
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
} 