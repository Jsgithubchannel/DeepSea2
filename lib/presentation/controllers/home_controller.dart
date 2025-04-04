import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/data/models/user_model.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/data/repositories/user_repository.dart';
import 'package:jellyfish_test/data/repositories/jellyfish_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

/// 홈 화면 컨트롤러
class HomeController extends GetxController {
  late final UserRepository _userRepository;
  late final JellyfishRepository _jellyfishRepository;

  // 사용자 정보
  Rx<User> get user => _userRepository.user;

  // 해파리 정보
  RxList<Jellyfish> get jellyfishList => _jellyfishRepository.jellyfishList;

  // 도감 완성도
  final RxDouble discoveryRate = 0.0.obs;

  // 내비게이션 인덱스
  RxInt currentIndex = 0.obs;

  // 돌발 이벤트 표시 여부
  RxBool isAlertVisible = false.obs;

  @override
  void onInit() {
    // --- 수정: super.onInit() 다음에 Get.find() 호출 ---
    super.onInit(); // super.onInit()을 먼저 호출하는 것이 일반적입니다.
    _userRepository = Get.find<UserRepository>();
    _jellyfishRepository = Get.find<JellyfishRepository>();
    // --- 수정 완료 ---

    // 이제 _userRepository와 _jellyfishRepository를 사용 가능
    discoveryRate.value = _jellyfishRepository.getDiscoveryRate();
    ever(_jellyfishRepository.jellyfishList, (_) {
      discoveryRate.value = _jellyfishRepository.getDiscoveryRate();
    });

    _checkRandomAlert();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    // ★★★ 파라미터 타입에 prefix 사용 ★★★
    fb_auth.FirebaseAuth.instance.authStateChanges().listen((
      fb_auth.User? firebaseUser,
    ) {
      if (firebaseUser != null) {
        // 로그인 상태
        print("HomeController: User logged in - ${firebaseUser.uid}");
        // ★★★ prefix가 붙은 fb_auth.User 객체 전달 ★★★
        _updateUserFromFirebase(firebaseUser);
      } else {
        // 로그아웃 상태
        print("HomeController: User logged out");
        // ★★★ UserRepository의 사용자 정보 초기화 필요 ★★★
        // 예: _userRepository.clearUser(); // UserRepository에 이런 메소드가 있다고 가정
      }
    });
  }

  // ★★★ 파라미터 타입에 prefix 사용 + 함수 내용 구현 ★★★
  Future<void> _updateUserFromFirebase(fb_auth.User firebaseUser) async {
    print(
      "Triggering user update in repository for Firebase User: ${firebaseUser.displayName}",
    );
    await _userRepository.updateUserFromFirebase(firebaseUser);
  }

  /// 네비게이션 탭 변경
  void changeTab(int index) {
    currentIndex.value = index;
  }

  /// 해파리 감식 화면으로 이동
  void navigateToIdentification() {
    Get.toNamed(AppRoutes.identification);
  }

  /// 랜덤 돌발 이벤트 체크
  void _checkRandomAlert() {
    // 25% 확률로 돌발 이벤트 표시 (실제 구현에서는 조건 추가)
    final random = (DateTime.now().millisecondsSinceEpoch % 4 == 0);

    if (random) {
      isAlertVisible.value = true;
    }
  }

  /// 돌발 이벤트 처리
  void onAlertTap() {
    // 돌발 이벤트 처리 후 숨김
    isAlertVisible.value = false;

    // 보상 지급 (경험치 +15)
    _userRepository.addExp(15);

    // 식별 화면으로 이동
    navigateToIdentification();
  }

  /// 돌발 이벤트 무시
  void dismissAlert() {
    isAlertVisible.value = false;
  }

  /// 발견된 해파리 목록 반환
  List<Jellyfish> getDiscoveredJellyfish() {
    return _jellyfishRepository.getDiscoveredJellyfish();
  }

  /// 전체 해파리 수 반환
  int get totalJellyfishCount => _jellyfishRepository.getAllJellyfish().length;

  /// 발견된 해파리 수 반환
  int get discoveredJellyfishCount =>
      _jellyfishRepository.getDiscoveredJellyfish().length;
}
