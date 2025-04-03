import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jellyfish_test/data/models/user_model.dart';

/// 사용자 데이터 관리를 위한 리포지토리 클래스
class UserRepository extends GetxService {
  static const _userKey = 'user_data';
  
  late SharedPreferences _prefs;
  late Rx<User> _user;
  
  /// 사용자 데이터 Rx
  Rx<User> get user => _user;
  
  /// 사용자 데이터 초기화
  Future<UserRepository> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadUser();
    return this;
  }
  
  /// 저장된 사용자 데이터를 불러옵니다.
  void _loadUser() {
    final userJson = _prefs.getString(_userKey);
    
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        _user = User.fromJson(userData).obs;
      } catch (e) {
        // 오류 발생 시 기본 사용자 생성
        _user = User.defaultUser().obs;
        _saveUser();
      }
    } else {
      // 저장된 데이터가 없으면 기본 사용자 생성
      _user = User.defaultUser().obs;
      _saveUser();
    }
  }
  
  /// 사용자 데이터를 저장합니다.
  Future<void> _saveUser() async {
    final userJson = jsonEncode(_user.value.toJson());
    await _prefs.setString(_userKey, userJson);
  }
  
  /// 사용자 이름을 업데이트합니다.
  Future<void> updateName(String name) async {
    _user.value = _user.value.copyWith(name: name);
    await _saveUser();
  }
  
  /// 경험치를 추가합니다.
  Future<void> addExp(int amount) async {
    final previousLevel = _user.value.level;
    _user.value = _user.value.addExp(amount);
    
    // 레벨업 확인
    if (_user.value.level != previousLevel) {
      // 레벨업 이벤트 트리거
      // TODO: 레벨업 이벤트 처리
    }
    
    await _saveUser();
  }
  
  /// 해파리 발견 정보를 업데이트합니다.
  Future<void> updateDiscoveredJellyfish(int count) async {
    _user.value = _user.value.copyWith(discoveredJellyfishCount: count);
    await _saveUser();
  }
  
  /// 완료한 퀴즈 ID를 추가합니다.
  Future<void> addCompletedQuiz(int quizId) async {
    if (!_user.value.completedQuizIds.contains(quizId)) {
      final newCompletedQuizIds = List<int>.from(_user.value.completedQuizIds)..add(quizId);
      _user.value = _user.value.copyWith(completedQuizIds: newCompletedQuizIds);
      await _saveUser();
    }
  }
  
  /// 배지 수를 업데이트합니다.
  Future<void> updateBadgeCount(int count) async {
    _user.value = _user.value.copyWith(badgeCount: count);
    await _saveUser();
  }
  
  /// 마지막 로그인 시간을 업데이트합니다.
  Future<void> updateLastLogin() async {
    _user.value = _user.value.copyWith(lastLoginDate: DateTime.now());
    await _saveUser();
  }
} 