import 'dart:convert';
import 'package:get/get.dart';
import 'package:jellyfish_test/data/models/exp_constants.dart';
import 'package:jellyfish_test/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';

/// 사용자 프로필 컨트롤러
class UserController extends GetxController {
  static UserController get to => Get.find();

  // Firebase & Google Sign In 인스턴스
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Firebase 인증 상태 (반응형)
  // 앱 로드 시 현재 로그인된 Firebase 사용자 정보를 바로 가져옴
  final Rx<fb_auth.User?> firebaseUser = Rx<fb_auth.User?>(null);

  // 앱 내부 사용자 데이터 (기존 로직 유지 + uid, email 필드 추가 필요)
  final Rx<User> _user = User.defaultUser().obs; // User 모델에 uid, email 추가 필요
  User get user => _user.value;

  // 로딩 상태
  final RxBool _isLoading = true.obs; // 초기 로딩 상태 true
  bool get isLoading => _isLoading.value;

  // 경험치 관련 상태 (기존 코드 유지)
  final RxBool _showExpNotification = false.obs;
  bool get showExpNotification => _showExpNotification.value;
  final RxInt _recentExp = 0.obs;
  int get recentExp => _recentExp.value;

  // SharedPreferences 키 (로그인 상태에 따라 다르게 사용 가능)
  static const String _guestUserKey = 'guest_user_data';
  static const String _firebaseUserPrefix = 'user_data_'; // UID 기반 키 접두사

  // 문자열 기반 퀴즈 완료 목록 저장 키 (기존 코드 유지)
  static const String _completedQuizStringsKey = 'completed_quiz_strings';

  @override
  void onInit() {
    super.onInit();
    // Firebase 인증 상태 스트림 구독
    firebaseUser.bindStream(_auth.authStateChanges());

    // 인증 상태 변경 시 사용자 데이터 로드/갱신 리스너 설정
    ever(firebaseUser, _handleAuthStateChanged);

    // 초기 앱 로드 시 현재 인증 상태 확인 및 데이터 로드
    _handleAuthStateChanged(_auth.currentUser);
  }

  /// Firebase 인증 상태 변경 처리
  Future<void> _handleAuthStateChanged(fb_auth.User? fbUser) async {
    print("Firebase Auth State Changed: ${fbUser?.uid}");
    _isLoading.value = true; // 데이터 로드 시작
    if (fbUser != null) {
      // Firebase 로그인 상태
      final currentLocalUser = _user.value; // 현재 로컬 User 객체 가져오기
      String updatedName = currentLocalUser.name; // 기본값은 현재 이름

      // 게스트였거나 이름이 비어있으면 Firebase 이름 사용
      if (updatedName == '게스트' || updatedName.isEmpty) {
        updatedName = fbUser.displayName ?? '탐험가'; // Firebase 이름 또는 기본값
      }

      // copyWith를 사용하여 새 User 객체 생성
      _user.value = currentLocalUser.copyWith(
        uid: fbUser.uid, // Firebase uid 설정
        email: fbUser.email, // Firebase email 설정
        name: updatedName, // 결정된 이름 설정
      );

      // 2. SharedPreferences에서 해당 UID의 데이터 로드 시도
      await _loadUserData(fbUser.uid);
      // 3. 로드된 데이터가 없다면 Firebase 정보 기반으로 기본값 저장
      if (_user.value.uid != fbUser.uid) {
        // 로드 실패 또는 첫 로그인
        _user.value = User.defaultUser().copyWith(
          // User 모델에 uid, email 반영
          uid: fbUser.uid,
          email: fbUser.email,
          name: fbUser.displayName ?? _user.value.name, // 기존 이름 또는 Google 이름
        );
        await _saveUserData(); // 새 정보 저장
      }
    } else {
      // 로그아웃 상태 (게스트)
      await _loadUserData(null); // 게스트 데이터 로드
    }
    _isLoading.value = false; // 데이터 로드 완료
  }

  /// 사용자 데이터 로드 (UID 기반 또는 게스트)
  Future<void> _loadUserData(String? uid) async {
    // _isLoading 조작은 _handleAuthStateChanged 에서 관리
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = uid != null ? '$_firebaseUserPrefix$uid' : _guestUserKey;
      final userData = prefs.getString(key);

      if (userData != null) {
        final decoded = jsonDecode(userData);
        final loadedUser = User.fromJson(
          decoded,
        ); // User.fromJson 수정 필요 (uid, email 처리)
        // 로드된 데이터가 현재 로그인 상태와 일치하는지 확인 (선택적이지만 권장)
        if ((uid != null && loadedUser.uid == uid) ||
            (uid == null &&
                (loadedUser.uid == null || loadedUser.uid!.isEmpty))) {
          _user.value = loadedUser;
          print("User data loaded for key: $key");
        } else {
          print(
            "Loaded data UID mismatch. Key: $key, Loaded UID: ${loadedUser.uid}, Current Auth UID: $uid",
          );
          // 상태 불일치 시, 기본값 또는 현재 인증 정보 기반으로 재설정
          _resetUserData(uid);
        }
      } else {
        // 해당 키에 데이터가 없음 -> 기본값 설정
        print("No user data found for key: $key. Setting default.");
        _resetUserData(uid);
        await _saveUserData(); // 기본값 저장
      }
    } catch (e) {
      print('사용자 데이터 로드 중 오류 발생: $e');
      _resetUserData(uid); // 오류 발생 시 기본값으로 리셋
    }
  }

  /// 사용자 데이터 리셋 (기본값 설정)
  void _resetUserData(String? uid) {
    if (uid != null) {
      // 로그인 상태의 기본값
      final currentUser = _auth.currentUser; // 최신 Firebase 유저 정보
      _user.value = User.defaultUser().copyWith(
        uid: uid,
        email: currentUser?.email,
        name: currentUser?.displayName ?? '사용자',
      );
    } else {
      // 게스트 상태의 기본값
      _user.value = User.defaultUser(); // uid, email이 비어있는 기본값
    }
  }

  /// 사용자 데이터 저장
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 현재 _user 값에 uid가 있으면 Firebase 사용자 키, 없으면 게스트 키 사용
      final key =
          (_user.value.uid != null && _user.value.uid!.isNotEmpty)
              ? '$_firebaseUserPrefix${_user.value.uid}'
              : _guestUserKey;

      // User.toJson에 uid, email 포함 필요
      final userData = jsonEncode(_user.value.toJson());
      await prefs.setString(key, userData);
    } catch (e) {
      print('사용자 데이터 저장 중 오류 발생: $e');
    }
  }

  // --- Google 로그인 메서드 ---
  Future<fb_auth.User?> signInWithGoogle() async {
    _isLoading.value = true; // 로그인 프로세스 시작
    try {
      // Google 로그인 창 트리거
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google 로그인 취소됨');
        _isLoading.value = false;
        return null; // 사용자가 취소
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase용 자격 증명 생성
      final fb_auth.AuthCredential credential = fb_auth
          .GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      final fb_auth.UserCredential userCredential = await _auth
          .signInWithCredential(credential);
      final fb_auth.User? loggedInUser = userCredential.user;

      // _handleAuthStateChanged 리스너가 자동으로 호출되어 데이터 처리
      // 여기서 별도로 _user 상태를 직접 업데이트할 필요는 없음

      print('Google 로그인 성공');
      // 로딩 상태는 _handleAuthStateChanged 에서 최종적으로 false 처리됨
      return loggedInUser;
    } on fb_auth.FirebaseAuthException catch (e) {
      print('Firebase Auth 에러: ${e.code} - ${e.message}');
      Get.snackbar(
        '로그인 오류',
        'Google 로그인 중 오류가 발생했습니다: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
      );
      _isLoading.value = false;
      return null;
    } catch (e) {
      print('Google 로그인 중 일반 에러: $e');
      Get.snackbar(
        '로그인 오류',
        'Google 로그인 중 알 수 없는 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
      _isLoading.value = false;
      return null;
    }
  }

  // --- 로그아웃 메서드 ---
  Future<void> signOut() async {
    _isLoading.value = true;
    try {
      print("Signing out...");
      await _googleSignIn.signOut(); // Google 로그아웃
      await _auth.signOut(); // Firebase 로그아웃
      // _handleAuthStateChanged 리스너가 호출되어 _user 상태를 게스트로 변경하고 게스트 데이터 로드
      print("Sign out successful.");
    } catch (e) {
      print("Sign out error: $e");
      Get.snackbar(
        '로그아웃 오류',
        '로그아웃 중 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
      // 오류 발생 시 수동으로 상태 초기화 (선택적)
      // _resetUserData(null);
      // _isLoading.value = false;
    }
    // 로딩 상태는 _handleAuthStateChanged 에서 최종적으로 false 처리됨
  }

  /// 사용자 이름 변경 (Firebase 프로필 업데이트 추가)
  Future<void> updateUsername(String name) async {
    if (name.isEmpty || name == _user.value.name) return;

    final originalName = _user.value.name;
    _user.value = _user.value.copyWith(name: name); // User 모델에 name 필드 있다고 가정

    // Firebase 로그인 상태이면 Firebase 프로필도 업데이트 시도
    if (firebaseUser.value != null) {
      try {
        await firebaseUser.value?.updateDisplayName(name);
        print("Firebase display name updated to: $name");
      } catch (e) {
        print("Failed to update Firebase display name: $e");
        // 오류 발생 시 로컬 이름 롤백 또는 사용자에게 알림
        _user.value = _user.value.copyWith(name: originalName);
        Get.snackbar(
          '오류',
          '프로필 이름 변경 중 오류가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return; // 저장 로직 중단
      }
    }

    await _saveUserData(); // 로컬 저장
    update(); // GetX UI 업데이트 알림
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
      print(
        '현재 경험치: ${_user.value.exp}/${ExpConstants.requiredExpForLevel(_user.value.level)}',
      );
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
      print(
        '경험치 획득: +$amount (총: ${_user.value.exp}/${ExpConstants.requiredExpForLevel(_user.value.level)})',
      );
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
      discoveredJellyfishCount: _user.value.discoveredJellyfishCount + 1,
    );

    // 해파리 발견 시 경험치 부여
    await addJellyfishDiscoveryExp();

    await _saveUserData();
    update();
  }

  /// 제보한 해파리 수 증가
  Future<void> incrementReportedJellyfish() async {
    _user.value = _user.value.copyWith(
      reportedJellyfishCount: _user.value.reportedJellyfishCount + 1,
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
    final List<String> completedQuizStrings =
        prefs.getStringList(_completedQuizStringsKey) ?? [];

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
    final int dailyCount =
        (await getCompletedQuizStringsByType('daily')).length;
    final int emergencyCount =
        (await getCompletedQuizStringsByType('emergency')).length;

    return {
      'total': allCompleted.length,
      'daily': dailyCount,
      'emergency': emergencyCount,
      'quizIds': allCompleted,
    };
  }
}
