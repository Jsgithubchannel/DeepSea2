import 'package:get/get.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/data/repositories/jellyfish_repository.dart';

/// 해파리 컨트롤러
class JellyfishController extends GetxController {
  final JellyfishRepository _repository = JellyfishRepository();
  
  /// 모든 해파리 리스트
  final RxList<Jellyfish> jellyfishList = <Jellyfish>[].obs;
  
  /// 발견된 해파리 리스트
  final RxList<Jellyfish> discoveredJellyfishList = <Jellyfish>[].obs;
  
  /// 발견되지 않은 해파리 리스트
  final RxList<Jellyfish> undiscoveredJellyfishList = <Jellyfish>[].obs;
  
  /// 발견율 (백분율)
  final RxDouble discoveryRate = 0.0.obs;
  
  /// 로딩 상태
  final RxBool isLoading = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initRepository();
  }
  
  /// 레포지토리 초기화
  Future<void> _initRepository() async {
    try {
      isLoading.value = true;
      await _repository.init();
      _loadJellyfish();
    } catch (e) {
      print('JellyfishController 초기화 오류: $e');
      // 에러가 발생해도 기본 데이터를 로드하도록 시도
      _loadJellyfish();
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 해파리 데이터 로드
  void _loadJellyfish() {
    try {
      jellyfishList.value = _repository.getAllJellyfish();
      _updateLists();
    } catch (e) {
      print('해파리 데이터 로드 오류: $e');
      // 오류 발생 시 기본 데이터로 초기화
      jellyfishList.value = [];
      _updateLists();
    }
  }
  
  /// 리스트 업데이트
  void _updateLists() {
    discoveredJellyfishList.value = _repository.getDiscoveredJellyfish();
    undiscoveredJellyfishList.value = _repository.getUndiscoveredJellyfish();
    _calculateDiscoveryRate();
  }
  
  /// 발견율 계산
  void _calculateDiscoveryRate() {
    if (jellyfishList.isEmpty) {
      discoveryRate.value = 0.0;
      return;
    }
    
    discoveryRate.value = (discoveredJellyfishList.length / jellyfishList.length) * 100;
  }
  
  /// ID로 해파리 찾기
  Jellyfish? getJellyfishById(String id) {
    return _repository.getJellyfishById(id);
  }
  
  /// 해파리 발견 처리
  void discoverJellyfish(String id) {
    _repository.discoverJellyfish(id);
    _updateLists();
  }
  
  /// 랜덤 해파리 발견 처리
  void discoverRandomJellyfish() {
    if (undiscoveredJellyfishList.isEmpty) {
      return;
    }
    
    final random = undiscoveredJellyfishList[0]; // 랜덤으로 선택하는 대신 첫 번째 항목 선택
    discoverJellyfish(random.id);
  }
} 