import 'package:get/get.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/data/models/jellyfish_data.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/data/repositories/jellyfish_repository.dart';

/// 해파리 데이터 관리 컨트롤러
class JellyfishController extends GetxController {
  static JellyfishController get to => Get.find();

  // 필드
  final RxList<Jellyfish> _jellyfishList = <Jellyfish>[].obs;
  final RxList<Jellyfish> _discoveredJellyfishList = <Jellyfish>[].obs;
  final RxList<Jellyfish> _undiscoveredJellyfishList = <Jellyfish>[].obs;
  final RxDouble _discoveryRate = 0.0.obs;
  final RxBool _isLoading = true.obs;

  // 게터
  List<Jellyfish> get jellyfishList => _jellyfishList;
  List<Jellyfish> get discoveredJellyfishList => _discoveredJellyfishList;
  List<Jellyfish> get undiscoveredJellyfishList => _undiscoveredJellyfishList;
  double get discoveryRate => _discoveryRate.value;
  bool get isLoading => _isLoading.value;

  // 저장소
  late JellyfishRepository _repository;

  // 사용자 컨트롤러
  final UserController _userController = Get.find<UserController>();

  // 사용자가 발견한 해파리 목록
  final RxList<String> _discoveredJellyfishIds = <String>[].obs;
  List<String> get discoveredJellyfishIds => _discoveredJellyfishIds;

  @override
  void onInit() {
    super.onInit();
    _initRepository();
    _loadJellyfishData();
  }

  /// 저장소 초기화 및 데이터 로드
  Future<void> _initRepository() async {
    try {
      _isLoading.value = true;
      _repository = JellyfishRepository();
      await _repository.init();
      _loadJellyfish();
    } catch (e) {
      print('해파리 데이터 초기화 오류: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 해파리 데이터 로드
  void _loadJellyfish() {
    try {
      _updateLists();
    } catch (e) {
      print('해파리 데이터 로드 오류: $e');
    }
  }

  /// 해파리 데이터 로드 (실제 앱에서는 API나 DB에서 가져옴)
  void _loadJellyfishData() {
    try {
      // 샘플 데이터 로드
      final mockData = JellyfishData.getAllJellyfish();
      _jellyfishList.assignAll(mockData);

      print('해파리 데이터 ${_jellyfishList.length}개 로드 완료');
    } catch (e) {
      print('해파리 데이터 로드 중 오류 발생: $e');
    }
  }

  /// 목록 업데이트
  void _updateLists() {
    // 전체 목록 가져오기
    _jellyfishList.assignAll(_repository.getAllJellyfish());

    // 발견/미발견 목록 분류
    _discoveredJellyfishList.assignAll(_repository.getDiscoveredJellyfish());
    _undiscoveredJellyfishList.assignAll(
      _repository.getUndiscoveredJellyfish(),
    );

    // 발견율 계산 (0.0 ~ 1.0)
    _discoveryRate.value = _repository.getDiscoveryRate();

    // 갱신
    update();
  }

  /// ID로 해파리 찾기
  Jellyfish? getJellyfishById(String id) {
    return _repository.getJellyfishById(id);
  }

  /// 해파리 발견 처리
  Future<bool> discoverJellyfish(String id) async {
    try {
      final jellyfish = await _repository.discoverJellyfish(id);
      if (jellyfish != null) {
        _updateLists();

        // 사용자 발견 해파리 수 증가 및 경험치 추가
        await _userController.incrementDiscoveredJellyfish();

        return true;
      }
      return false;
    } catch (e) {
      print('해파리 발견 처리 오류: $e');
      return false;
    }
  }

  /// 무작위 해파리 발견 처리 (개발용)
  Future<bool> discoverRandomJellyfish() async {
    try {
      if (_undiscoveredJellyfishList.isEmpty) return false;

      // 무작위 미발견 해파리 선택
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch %
          _undiscoveredJellyfishList.length;
      final jellyfish = _undiscoveredJellyfishList[randomIndex];

      return await discoverJellyfish(jellyfish.id);
    } catch (e) {
      print('랜덤 해파리 발견 처리 오류: $e');
      return false;
    }
  }

  /// 해파리 제보 처리
  Future<bool> reportJellyfish(String id) async {
    try {
      final jellyfish = getJellyfishById(id);
      if (jellyfish == null) return false;

      // 사용자 제보 해파리 수 증가 및 경험치 추가
      await _userController.incrementReportedJellyfish();

      return true;
    } catch (e) {
      print('해파리 제보 처리 오류: $e');
      return false;
    }
  }
}
