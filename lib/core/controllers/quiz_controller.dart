import 'dart:async';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/data/models/exp_constants.dart';

/// 퀴즈 타입 열거형
enum QuizType {
  daily, // 일일 퀴즈
  emergency, // 돌발 퀴즈
}

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

/// 퀴즈 컨트롤러
class QuizController extends GetxController {
  static QuizController get to => Get.find();

  // 사용자 컨트롤러
  final UserController _userController = Get.find<UserController>();

  // 퀴즈 목록
  final RxList<Quiz> _quizzes = <Quiz>[].obs;
  List<Quiz> get quizzes => _quizzes;

  // 완료된 퀴즈 목록
  final RxList<Quiz> _completedQuizzes = <Quiz>[].obs;
  List<Quiz> get completedQuizzes => _completedQuizzes;

  // 타이머 관련 변수
  final RxInt _remainingSeconds = 0.obs;
  int get remainingSeconds => _remainingSeconds.value;

  final RxDouble _timerProgress = 0.0.obs;
  double get timerProgress => _timerProgress.value;

  // 타이머
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadQuizzes();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// 퀴즈 데이터 로드
  void _loadQuizzes() {
    // 임시 퀴즈 데이터
    _quizzes.assignAll([
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
          '껍질 속으로 몸을 숨긴다',
        ],
        correctAnswer: 1,
        explanation:
            '해파리는 독성이 있는 촉수를 이용해 자신을 방어합니다. 이 독침은 작은 낭포(nematocysts)에 들어있으며, 위협을 느끼면 촉수를 뻗어 독을 주입합니다.',
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
        options: ['맑고 차가운 물', '오염되고 따뜻한 물', '깊은 바다', '담수(민물)'],
        correctAnswer: 1,
        explanation:
            '해파리는 오염되고 따뜻한 바다에서 더 잘 번식하는 경향이 있습니다. 기후 변화와 해양 오염은 해파리 개체수 증가의 주요 원인으로 지목됩니다.',
        type: QuizType.daily,
        releaseDate: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
        imagePath: 'assets/images/quiz/jellyfish_bloom.jpg',
        points: 100,
      ),

      // 돌발 퀴즈 - 해파리 등장 정보
      Quiz(
        id: 'emergency-1',
        title: '해파리 등장 속보',
        description: '긴급 정보: 해파리 대량 출현!',
        question: '최근 부산 해운대 해수욕장에 대량 출현한 해파리는?',
        options: ['보름달물해파리', '노무라입깃해파리', '작은부레관해파리', '커튼원양해파리'],
        correctAnswer: 1,
        explanation:
            '최근 부산 해운대 해수욕장에 노무라입깃해파리가 대량 출현하여 해수욕객들의 주의가 필요합니다. 이 해파리는 크기가 크고 독성이 있어 접촉 시 심한 통증을 유발할 수 있습니다.',
        type: QuizType.emergency,
        expiryDate: DateTime.now().add(const Duration(hours: 3)),
        isCompleted: false,
        imagePath: 'assets/images/quiz/nomura_jellyfish.jpg',
        points: 150,
      ),

      // 돌발 퀴즈 - 해파리 쏘임 응급처치
      Quiz(
        id: 'emergency-2',
        title: '해파리 쏘임 응급처치',
        description: '긴급: 해파리 쏘임 대응법',
        question: '해파리에 쏘였을 때 가장 먼저 해야 할 올바른 조치는?',
        options: [
          '상처 부위를 담수(민물)로 씻는다',
          '소변을 상처에 바른다',
          '식초를 상처 부위에 바른다',
          '상처 부위를 문지른다',
        ],
        correctAnswer: 2,
        explanation:
            '해파리에 쏘였을 때는 식초를 상처 부위에 바르는 것이 가장 효과적입니다. 식초는 아직 발사되지 않은 자상 세포의 활성화를 막아줍니다. 담수로 씻거나 상처를 문지르면 독이 더 퍼질 수 있어 위험합니다.',
        type: QuizType.emergency,
        expiryDate: DateTime.now().subtract(const Duration(hours: 1)),
        isCompleted: false,
        imagePath: 'assets/images/quiz/jellyfish_sting.jpg',
        points: 150,
      ),
    ]);

    // 완료된 퀴즈 초기화
    _initCompletedQuizzes();

    // 상태 업데이트
    update();
  }

  /// 완료된 퀴즈 초기화
  void _initCompletedQuizzes() async {
    try {
      // 유저 컨트롤러에서 완료된 퀴즈 문자열 ID 목록 가져오기
      final completedIds = await _userController.getCompletedQuizStringsAsync();

      // 완료된 퀴즈 목록 초기화
      _completedQuizzes.clear();

      // 각 퀴즈에 대해 완료 여부 확인
      for (final quiz in _quizzes) {
        // 퀴즈 ID에서 타입과 번호 추출하여 고유 ID 생성
        final uniqueId = _getUniqueQuizId(quiz.id);

        // 사용자가 완료한 퀴즈인지 확인
        if (completedIds.contains(uniqueId)) {
          // 완료된 퀴즈로 상태 업데이트
          final updatedQuiz = quiz.copyWith(isCompleted: true);

          // 퀴즈 목록에서 해당 퀴즈 업데이트
          final index = _quizzes.indexWhere((q) => q.id == quiz.id);
          if (index != -1) {
            _quizzes[index] = updatedQuiz;
          }

          // 완료된 퀴즈 목록에 추가
          _completedQuizzes.add(updatedQuiz);
        }
      }

      // 상태 업데이트
      update();
    } catch (e) {
      print('완료된 퀴즈 초기화 오류: $e');
    }
  }

  /// 퀴즈 ID에서 고유 문자열 ID 생성
  String _getUniqueQuizId(String quizId) {
    // 형식: 'daily-1', 'emergency-2' 등에서 유형과 번호를 추출하여 고유 ID 생성
    final RegExp regex = RegExp(r'^([a-z]+)-(\d+)$');
    final match = regex.firstMatch(quizId);

    if (match != null && match.groupCount >= 2) {
      final type = match.group(1); // 'daily' 또는 'emergency'
      final number = match.group(2); // '1', '2' 등

      return '${type}_${number}'; // 예: 'daily_1', 'emergency_1'
    }

    return quizId; // 매치되지 않으면 원래 ID 반환
  }

  /// 타이머 시작
  void _startTimer() {
    // 기존 타이머 취소
    _timer?.cancel();

    // 즉시 첫 업데이트 실행
    _updateEmergencyQuizTimer();

    // 1초마다 타이머 업데이트
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateEmergencyQuizTimer();
    });
  }

  /// 돌발 퀴즈 타이머 업데이트
  void _updateEmergencyQuizTimer() {
    final emergencyQuizzes =
        _quizzes
            .where(
              (q) =>
                  q.type == QuizType.emergency &&
                  !q.isCompleted &&
                  q.expiryDate != null,
            )
            .toList();

    if (emergencyQuizzes.isNotEmpty) {
      final now = DateTime.now();
      final expiry = emergencyQuizzes[0].expiryDate!;

      if (expiry.isAfter(now)) {
        final diff = expiry.difference(now);
        _remainingSeconds.value = diff.inSeconds;
        _timerProgress.value = diff.inSeconds / (3 * 60 * 60); // 3시간 기준
      } else {
        _remainingSeconds.value = 0;
        _timerProgress.value = 0;

        // 시간이 만료된 돌발 퀴즈 처리 (자동으로 만료 표시)
        _markExpiredEmergencyQuizzes();
      }
    } else {
      _remainingSeconds.value = 0;
      _timerProgress.value = 0;
    }

    // 상태 업데이트
    update();
  }

  /// 만료된 돌발 퀴즈 처리
  void _markExpiredEmergencyQuizzes() {
    final now = DateTime.now();
    bool updated = false;

    for (int i = 0; i < _quizzes.length; i++) {
      final quiz = _quizzes[i];

      // 완료되지 않은 돌발 퀴즈 중 만료된 것을 찾음
      if (quiz.type == QuizType.emergency &&
          !quiz.isCompleted &&
          quiz.expiryDate != null &&
          quiz.expiryDate!.isBefore(now)) {
        // 만료됨으로 표시 (완료됨과는 다른 상태)
        // 여기서는 간단히 isCompleted 상태로 표시하지만,
        // 실제로는 다른 상태 필드를 추가할 수 있습니다.
        _quizzes[i] = quiz.copyWith(
          isCompleted: true, // 만료된 것도 완료로 표시
        );

        updated = true;
      }
    }

    if (updated) {
      update();
    }
  }

  /// 남은 시간 포맷팅 (시:분:초)
  String formatTimeRemaining() {
    final seconds = _remainingSeconds.value;

    if (seconds <= 0) {
      return '00:00:00';
    }

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// 간단한 남은 시간 포맷팅 (시간:분)
  String formatTimeRemainingShort() {
    final seconds = _remainingSeconds.value;

    if (seconds <= 0) {
      return '00:00';
    }

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// 사람이 읽기 쉬운 형식의 남은 시간 (시간 분)
  String formatTimeRemainingHumanReadable() {
    final seconds = _remainingSeconds.value;

    if (seconds <= 0) {
      return '만료됨';
    }

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  /// 활성화된 돌발 퀴즈가 있는지 확인
  bool hasActiveEmergencyQuiz() {
    return _quizzes.any(
      (q) =>
          q.type == QuizType.emergency &&
          !q.isCompleted &&
          q.expiryDate != null &&
          q.expiryDate!.isAfter(DateTime.now()),
    );
  }

  /// 활성화된 돌발 퀴즈 가져오기
  Quiz? getActiveEmergencyQuiz() {
    try {
      final activeQuizzes =
          _quizzes
              .where(
                (q) =>
                    q.type == QuizType.emergency &&
                    !q.isCompleted &&
                    q.expiryDate != null &&
                    q.expiryDate!.isAfter(DateTime.now()),
              )
              .toList();

      if (activeQuizzes.isNotEmpty) {
        return activeQuizzes.first;
      }
    } catch (e) {
      print('활성화된 돌발 퀴즈 조회 오류: $e');
    }

    return null;
  }

  /// 퀴즈 완료 처리
  Future<void> completeQuiz(String quizId) async {
    try {
      // 퀴즈 찾기
      final index = _quizzes.indexWhere((q) => q.id == quizId);

      if (index != -1) {
        final quiz = _quizzes[index];

        // 이미 완료된 퀴즈인지 확인
        if (quiz.isCompleted) return;

        // 고유 퀴즈 ID 생성
        final uniqueQuizId = _getUniqueQuizId(quiz.id);

        // 퀴즈 타입에 따라 경험치 추가
        if (quiz.type == QuizType.emergency) {
          await _userController.addEmergencyQuizExp();
        } else {
          await _userController.addDailyQuizExp();
        }

        // 완료된 퀴즈 목록에 추가
        await _userController.addCompletedQuizString(uniqueQuizId);

        // 퀴즈 완료 상태 업데이트
        final updatedQuiz = quiz.copyWith(isCompleted: true);
        _quizzes[index] = updatedQuiz;

        // 완료된 퀴즈 목록에 추가
        if (!_completedQuizzes.any((q) => q.id == updatedQuiz.id)) {
          _completedQuizzes.add(updatedQuiz);
        }

        // 타이머 업데이트
        _updateEmergencyQuizTimer();

        // 상태 업데이트
        update();
      }
    } catch (e) {
      print('퀴즈 완료 처리 오류: $e');
    }
  }
}
