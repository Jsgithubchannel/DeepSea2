import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jellyfish_test/data/models/user_model.dart';

/// 사용자 프로필 컨트롤러
class UserController extends GetxController {
  // 사용자 데이터
  final Rx<User> user = User.defaultUser().obs;
  
  // 로딩 상태
  final RxBool isLoading = true.obs;
  
  // SharedPreferences 키
  static const String _userKey = 'user_data';
  
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }
  
  /// 사용자 데이터 로드
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      
      // SharedPreferences에서 사용자 데이터 로드
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        // JSON 데이터가 있으면 역직렬화
        final Map<String, dynamic> userMap = Map<String, dynamic>.from(
          Map.castFrom(
            prefs.getString(_userKey)! as Map<dynamic, dynamic>,
          ),
        );
        user.value = User.fromJson(userMap);
      } else {
        // 기본 사용자 생성
        user.value = User.defaultUser();
        await _saveUserData();
      }
    } catch (e) {
      print('사용자 데이터 로드 오류: $e');
      // 오류 발생 시 기본 사용자로 초기화
      user.value = User.defaultUser();
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 사용자 데이터 저장
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, user.value.toJson().toString());
    } catch (e) {
      print('사용자 데이터 저장 오류: $e');
    }
  }
  
  /// 사용자 이름 변경
  Future<void> updateUserName(String name) async {
    if (name.isEmpty) return;
    
    user.value = user.value.copyWith(name: name);
    user.refresh(); // UI 갱신
    await _saveUserData();
  }
  
  /// 경험치 추가
  Future<void> addExp(int amount) async {
    if (amount <= 0) return;
    
    final updatedUser = user.value.addExp(amount);
    user.value = updatedUser;
    user.refresh(); // UI 갱신
    await _saveUserData();
  }
  
  /// 해파리 발견 수 증가
  Future<void> incrementDiscoveredJellyfish() async {
    user.value = user.value.copyWith(
      discoveredJellyfishCount: user.value.discoveredJellyfishCount + 1,
    );
    user.refresh(); // UI 갱신
    await _saveUserData();
  }
  
  /// 퀴즈 완료 추가
  Future<void> addCompletedQuiz(int quizId) async {
    if (user.value.completedQuizIds.contains(quizId)) return;
    
    final updatedQuizIds = List<int>.from(user.value.completedQuizIds)..add(quizId);
    user.value = user.value.copyWith(completedQuizIds: updatedQuizIds);
    user.refresh(); // UI 갱신
    await _saveUserData();
  }
  
  /// 마지막 로그인 날짜 업데이트
  Future<void> updateLastLoginDate() async {
    user.value = user.value.copyWith(lastLoginDate: DateTime.now());
    user.refresh(); // UI 갱신
    await _saveUserData();
  }
} 