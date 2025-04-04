import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
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
      final newCompletedQuizIds = List<int>.from(_user.value.completedQuizIds)
        ..add(quizId);
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

  /// 사용자 정보 전체를 업데이트하고 저장합니다.
  Future<void> updateUser(User newUser) async {
    // Update the reactive state
    _user.value = newUser;
    // Persist the changes
    await _saveUser();
    print("UserRepository: User updated and saved - ${newUser.name}");
  }

  /// 로그아웃 또는 초기화 시 사용자 정보를 기본값으로 리셋합니다.
  Future<void> clearUser() async {
    // Update the reactive state to default
    _user.value = User.defaultUser();
    // Persist the default state
    await _saveUser();
    print("UserRepository: User cleared and default saved.");
  }

  /// Firebase User 정보로 UserRepository 상태 업데이트 (HomeController에서 호출될 메소드)
  /// fb_auth prefix를 사용하기 위해 import 필요
  /// import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
  Future<void> updateUserFromFirebase(fb_auth.User firebaseUser) async {
    User currentUser = _user.value; // Get current custom user

    // 신규 사용자인지 확인 (ID가 기본값과 같은지 비교 등)
    bool isNewUser = currentUser.uid == User.defaultUser().uid;

    User updatedUser = currentUser.copyWith(
      uid: firebaseUser.uid, // Firebase UID 사용
      name:
          firebaseUser.displayName ??
          currentUser.name ??
          '신규 감식반', // Firebase 이름 우선 사용
      lastLoginDate: DateTime.now(),
      // 신규 사용자일 경우 경험치/레벨 초기화, 아니면 기존 값 유지 (정책에 따라 변경)
      exp: isNewUser ? 0 : currentUser.exp,
      level: isNewUser ? 1 : currentUser.level,
      // 신규 사용자일 경우 생성일자도 현재로 설정
      createdAt: isNewUser ? DateTime.now() : currentUser.createdAt,
      // discoveredJellyfishCount, badgeCount, completedQuizIds 등은
      // Firestore 등 별도 DB에서 가져오거나 기존 값을 유지해야 할 수 있음
      // 여기서는 일단 기존 값 유지 예시
      discoveredJellyfishCount: currentUser.discoveredJellyfishCount,
      badgeCount: currentUser.badgeCount,
      completedQuizIds: currentUser.completedQuizIds,
    );
    await updateUser(updatedUser); // 위에서 추가한 updateUser 메소드 호출
  }
}
