import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/data/models/user_model.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/data/repositories/user_repository.dart';
import 'package:jellyfish_test/data/repositories/jellyfish_repository.dart';

/// 홈 화면 컨트롤러
class HomeController extends GetxController {
  // 의존성 주입
  final UserRepository _userRepository = Get.find<UserRepository>();
  final JellyfishRepository _jellyfishRepository = Get.find<JellyfishRepository>();
  
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
    super.onInit();
    
    // 초기 완성도 설정
    discoveryRate.value = _jellyfishRepository.getDiscoveryRate();
    
    // 도감 완성도 변화 감지
    ever(_jellyfishRepository.jellyfishList, (_) {
      discoveryRate.value = _jellyfishRepository.getDiscoveryRate();
    });
    
    // 랜덤 확률로 돌발 이벤트 표시 (25%)
    _checkRandomAlert();
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