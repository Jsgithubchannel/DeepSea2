import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/services/identification_service.dart';
import 'dart:math' as math;

/// 해파리 식별 화면
class IdentificationScreen extends StatefulWidget {
  const IdentificationScreen({Key? key}) : super(key: key);

  @override
  _IdentificationScreenState createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen>
    with SingleTickerProviderStateMixin {
  final JellyfishController _jellyfishController =
      Get.find<JellyfishController>();

  // 샘플 이미지 경로 목록
  final List<String> _sampleImages = [
    'assets/images/jellyfish/compass/compass1.jpg',
    'assets/images/jellyfish/lions/lions1.jpg',
    'assets/images/jellyfish/blue/blue1.jpg',
    'assets/images/jellyfish/moon/moon1.jpg',
    'assets/images/jellyfish/mauve/mauve1.jpg',
    'assets/images/jellyfish/barrel/barrel1.jpg',
  ];

  // 현재 선택된 이미지
  String? _selectedImage;

  // 로딩 상태
  final RxBool _isIdentifying = false.obs;

  // 애니메이션 컨트롤러
  late AnimationController _scanAnimationController;

  final IdentificationService _identificationService =
      Get.find<IdentificationService>();

  @override
  void initState() {
    super.initState();

    // 스캔 애니메이션 컨트롤러 초기화
    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.azureStart, AppTheme.azureEnd],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 메인 콘텐츠
              Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child:
                        _selectedImage == null
                            ? _buildSampleSelectionUI()
                            : _buildIdentificationUI(),
                  ),
                ],
              ),

              // 로딩 오버레이
              Obx(
                () =>
                    _isIdentifying.value
                        ? Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(height: 24),
                                Text(
                                  '해파리 식별 중...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '인공지능이 해파리를 분석하고 있습니다',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 앱바 위젯
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Text(
            _selectedImage == null ? '샘플 선택' : '해파리 식별',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  // 샘플 선택 UI
  Widget _buildSampleSelectionUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '샘플 이미지 선택',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '식별할 해파리 이미지를 선택하세요. 실제 앱에서는 카메라로 촬영이 가능합니다.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _sampleImages.length,
              itemBuilder: (context, index) {
                return _buildSampleItem(_sampleImages[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 샘플 아이템
  Widget _buildSampleItem(String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImage = imagePath;
        });
      },
      child: GlassContainer(
        borderRadius: 16,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '샘플 해파리 ${index + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '터치하여 식별하기',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 식별 UI
  Widget _buildIdentificationUI() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 이미지
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),

                // 스캔 애니메이션
                AnimatedBuilder(
                  animation: _scanAnimationController,
                  builder: (context, child) {
                    return Positioned(
                      top:
                          _scanAnimationController.value *
                          MediaQuery.of(context).size.height *
                          0.6,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: Colors.blue.withOpacity(0.8),
                      ),
                    );
                  },
                ),

                // 식별 프레임
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),

                // 코너 마커
                Positioned(top: 0, left: 0, child: _buildCornerMarker()),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.rotate(
                    angle: math.pi / 2,
                    child: _buildCornerMarker(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Transform.rotate(
                    angle: math.pi,
                    child: _buildCornerMarker(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.rotate(
                    angle: 3 * math.pi / 2,
                    child: _buildCornerMarker(),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomButtons(),
      ],
    );
  }

  // 코너 마커
  Widget _buildCornerMarker() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.blue, width: 3),
          left: BorderSide(color: Colors.blue, width: 3),
        ),
      ),
    );
  }

  // 하단 버튼
  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _startIdentification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '식별하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '다른 이미지 선택',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 식별 시작
  void _startIdentification() async {
    if (_selectedImage == null) {
      print("No image selected.");
      Get.snackbar('오류', '식별할 이미지를 선택해주세요.'); // 사용자 피드백 추가
      return;
    }

    // IdentificationService의 모델 로드 상태 확인 (선택적이지만 권장)
    if (!_identificationService.isModelLoaded) {
      print("Model is not ready yet. Trying to load...");
      // 로딩 중임을 알리거나, 다시 로드를 시도할 수 있음
      _isIdentifying.value = true; // 로딩 표시
      await _identificationService.loadModel(); // 다시 로드 시도
      if (!_identificationService.isModelLoaded) {
        _isIdentifying.value = false;
        Get.snackbar(
          '오류',
          '모델을 로드할 수 없습니다. 앱을 재시작하거나 나중에 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      // 로드가 성공했으면 계속 진행
    }

    _isIdentifying.value = true; // 로딩 시작

    try {
      final result = await _identificationService.identifyJellyfish(
        _selectedImage!,
      );

      _isIdentifying.value = false; // 로딩 종료

      if (result != null && result.isNotEmpty) {
        // 결과가 성공적으로 반환된 경우
        final jellyfishId = result.keys.first; // 가장 확률 높은 ID
        final confidence = result.values.first; // 가장 높은 확률 값
        // 결과 화면으로 이동
        Get.toNamed(
          AppRoutes.identificationResult,
          arguments: {
            'jellyfishId': jellyfishId,
            'imagePath': _selectedImage, // 사용자가 선택한 이미지 경로 전달
            'confidenceScore': confidence,
          },
        );
      } else {
        // 식별 실패 또는 결과 없음
        print('Identification failed or returned no results.');
        Get.snackbar(
          '식별 실패',
          '해파리를 식별하지 못했습니다. 이미지를 확인하거나 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      // 오류 발생 시
      _isIdentifying.value = false; // 로딩 종료
      print('Error during identification process: $e');
      Get.snackbar(
        '오류 발생',
        '해파리 식별 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
