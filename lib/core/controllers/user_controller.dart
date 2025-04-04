import 'dart:convert';
import 'package:get/get.dart';
import 'package:jellyfish_test/data/models/exp_constants.dart';
import 'package:jellyfish_test/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// 사용자 프로필 컨트롤러
class UserController extends GetxController {
  static UserController get to => Get.find();
  
  // 사용자 데이터
  final Rx<User> _user = User.defaultUser().obs;
  User get user => _user.value;
  
  // 로딩 상태
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  // 경험치 추가 알림 상태
  final RxBool _showExpNotification = false.obs;
  bool get showExpNotification => _showExpNotification.value;
  
  // 최근 획득 경험치
  final RxInt _recentExp = 0.obs;
  int get recentExp => _recentExp.value;
  
  // SharedPreferences 키
  static const String _userKey = 'user_data';
  
  // 문자열 기반 퀴즈 완료 목록 저장 키
  static const String _completedQuizStringsKey = 'completed_quiz_strings';
  
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }
  
  /// 사용자 데이터 로드
  Future<void> _loadUserData() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        final decoded = jsonDecode(userData);
        _user.value = User.fromJson(decoded);
      } else {
        _user.value = User.defaultUser();
        await _saveUserData();
      }
    } catch (e) {
      print('사용자 데이터 로드 중 오류 발생: $e');
      _user.value = User.defaultUser();
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 사용자 데이터 저장
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(_user.value.toJson());
      await prefs.setString('user_data', userData);
    } catch (e) {
      print('사용자 데이터 저장 중 오류 발생: $e');
    }
  }
  
  /// 사용자 이름 변경
  Future<void> updateUsername(String name) async {
    if (name.isEmpty) return;
    
    _user.value = _user.value.copyWith(name: name);
    await _saveUserData();
    update();
  }
  
  /// 경험치 추가 (일반)
  Future<void> addExp(int amount) async {
    _showExpNotification.value = true;
    _recentExp.value = amount;
    
    final prevLevel = _user.value.level;
    _user.value = _user.value.addExp(amount);
    
    // 레벨업 감지 및 로그 개선
    if (_user.value.level > prevLevel) {
      // 레벨업 알림 또는 로직 추가
      print('레벨 업! ${prevLevel} -> ${_user.value.level}');
      print('현재 경험치: ${_user.value.exp}/${ExpConstants.requiredExpForLevel(_user.value.level)}');
      print('새로운 칭호: ${_user.value.title}');
      
      // 레벨업 축하 메시지 표시
      Get.snackbar(
        '레벨 업!',
        '축하합니다! 레벨 ${_user.value.level}(${_user.value.title})이 되었습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        icon: Icon(Icons.star, color: Colors.yellow),
      );
    } else {
      // 일반 경험치 획득 로그
      print('경험치 획득: +$amount (총: ${_user.value.exp}/${ExpConstants.requiredExpForLevel(_user.value.level)})');
    }
    
    await _saveUserData();
    update();
    
    // 3초 후 알림 숨기기
    Future.delayed(const Duration(seconds: 3), () {
      _showExpNotification.value = false;
    });
  }
  
  /// 일일 퀴즈 정답 시 경험치 추가
  Future<void> addDailyQuizExp() async {
    await addExp(ExpConstants.DAILY_QUIZ_CORRECT);
  }
  
  /// 긴급 퀴즈 정답 시 경험치 추가
  Future<void> addEmergencyQuizExp() async {
    await addExp(ExpConstants.EMERGENCY_QUIZ_CORRECT);
  }
  
  /// 해파리 발견 시 경험치 추가
  Future<void> addJellyfishDiscoveryExp() async {
    await addExp(ExpConstants.JELLYFISH_DISCOVER);
  }
  
  /// 해파리 제보 시 경험치 추가
  Future<void> addJellyfishReportExp() async {
    await addExp(ExpConstants.JELLYFISH_REPORT);
  }
  
  /// 해파리 발견 수 증가
  Future<void> incrementDiscoveredJellyfish() async {
    _user.value = _user.value.copyWith(
      discoveredJellyfishCount: _user.value.discoveredJellyfishCount + 1
    );
    
    // 해파리 발견 시 경험치 부여
    await addJellyfishDiscoveryExp();
    
    await _saveUserData();
    update();
  }
  
  /// 제보한 해파리 수 증가
  Future<void> incrementReportedJellyfish() async {
    _user.value = _user.value.copyWith(
      reportedJellyfishCount: _user.value.reportedJellyfishCount + 1
    );
    
    // 해파리 제보 시 경험치 부여
    await addJellyfishReportExp();
    
    await _saveUserData();
    update();
  }
  
  /// 퀴즈 완료 추가
  Future<void> addCompletedQuiz(int quizId) async {
    print('퀴즈 완료 추가 시도: $quizId, 현재 목록: ${_user.value.completedQuizIds}');
    
    if (!_user.value.completedQuizIds.contains(quizId)) {
      // 새 목록 생성 (깊은 복사)
      final updatedQuizIds = List<int>.from(_user.value.completedQuizIds);
      
      // 목록에 퀴즈 ID 추가
      updatedQuizIds.add(quizId);
      
      // 사용자 객체 업데이트
      _user.value = _user.value.copyWith(completedQuizIds: updatedQuizIds);
      
      // 데이터 저장
      await _saveUserData();
      
      // 상태 업데이트 알림
      update();
      
      print('퀴즈 완료 추가 성공: $quizId, 업데이트 후 목록: ${_user.value.completedQuizIds}');
    } else {
      print('이미 완료한 퀴즈입니다: $quizId');
    }
  }
  
  /// 완료한 퀴즈 목록 가져오기
  List<int> getCompletedQuizIds() {
    // 깊은 복사를 통해 원본 데이터 보호
    return List<int>.from(_user.value.completedQuizIds);
  }
  
  /// 퀴즈가 완료되었는지 확인
  bool isQuizCompleted(int quizId) {
    return _user.value.completedQuizIds.contains(quizId);
  }
  
  /// 마지막 로그인 날짜 업데이트
  Future<void> updateLastLoginDate() async {
    _user.value = _user.value.copyWith(lastLoginDate: DateTime.now());
    await _saveUserData();
    update();
  }
  
  /// 문자열 ID로 완료된 퀴즈 추가 (개선된 버전)
  Future<void> addCompletedQuizString(String quizId) async {
    print('문자열 퀴즈 완료 추가 시도: $quizId');
    
    // 현재 완료된 퀴즈 문자열 목록 가져오기
    final prefs = await SharedPreferences.getInstance();
    final List<String> completedQuizStrings = prefs.getStringList(_completedQuizStringsKey) ?? [];
    
    if (!completedQuizStrings.contains(quizId)) {
      // 새 목록 생성
      final updatedQuizStrings = List<String>.from(completedQuizStrings);
      
      // 목록에 퀴즈 ID 추가
      updatedQuizStrings.add(quizId);
      
      // 저장
      await prefs.setStringList(_completedQuizStringsKey, updatedQuizStrings);
      
      // 더 이상 숫자 ID는 추가하지 않음
      
      // 상태 업데이트
      update();
      
      print('문자열 퀴즈 완료 추가 성공: $quizId');
    } else {
      print('이미 완료한 문자열 퀴즈입니다: $quizId');
    }
  }
  
  /// 완료된 퀴즈 문자열 ID 목록 비동기 조회
  Future<List<String>> getCompletedQuizStringsAsync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedQuizStringsKey) ?? [];
  }
  
  /// 퀴즈 타입별 완료된 퀴즈 목록 조회
  Future<List<String>> getCompletedQuizStringsByType(String type) async {
    final allCompleted = await getCompletedQuizStringsAsync();
    return allCompleted.where((id) => id.startsWith('${type}_')).toList();
  }
  
  /// 일일 퀴즈 완료 수 조회
  Future<int> getDailyQuizCompletedCount() async {
    return (await getCompletedQuizStringsByType('daily')).length;
  }
  
  /// 돌발 퀴즈 완료 수 조회
  Future<int> getEmergencyQuizCompletedCount() async {
    return (await getCompletedQuizStringsByType('emergency')).length;
  }
  
  /// 퀴즈 완료 요약 정보 조회
  Future<Map<String, dynamic>> getQuizCompletionSummary() async {
    final List<String> allCompleted = await getCompletedQuizStringsAsync();
    final int dailyCount = (await getCompletedQuizStringsByType('daily')).length;
    final int emergencyCount = (await getCompletedQuizStringsByType('emergency')).length;
    
    return {
      'total': allCompleted.length,
      'daily': dailyCount,
      'emergency': emergencyCount,
      'quizIds': allCompleted,
    };
  }
} 