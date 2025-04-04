import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 해파리 제보 화면
class JellyfishReportScreen extends StatefulWidget {
  const JellyfishReportScreen({Key? key}) : super(key: key);

  @override
  _JellyfishReportScreenState createState() => _JellyfishReportScreenState();
}

class _JellyfishReportScreenState extends State<JellyfishReportScreen> {
  final JellyfishController _jellyfishController = Get.find<JellyfishController>();
  final UserController _userController = Get.find<UserController>();
  
  // 제보 유형
  late String _reportType;
  
  // 해파리 ID
  late String _jellyfishId;
  
  // 이미지 경로
  late String _imagePath;
  
  // 해파리 객체
  Jellyfish? _jellyfish;
  
  // 제보 필드
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final RxBool _isSubmitting = false.obs;
  
  // 잘못된 식별용 필드
  final RxInt _selectedJellyfishIndex = RxInt(-1);
  final RxList<Jellyfish> _jellyfishList = <Jellyfish>[].obs;
  
  @override
  void initState() {
    super.initState();
    _loadArguments();
  }
  
  @override
  void dispose() {
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
  
  // 인자 로드
  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>;
    _jellyfishId = args['jellyfishId'] ?? '';
    _imagePath = args['imagePath'] ?? '';
    _reportType = args['reportType'] ?? 'location';
    
    // 해파리 정보 로드
    _jellyfish = _jellyfishController.getJellyfishById(_jellyfishId);
    
    // 잘못된 식별인 경우 가능한 해파리 목록 로드
    if (_reportType == 'misidentification') {
      _jellyfishList.assignAll(_jellyfishController.jellyfishList);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_jellyfish == null) {
      return Scaffold(
        appBar: AppBar(title: Text('제보하기')),
        body: Center(child: Text('해파리 정보를 찾을 수 없습니다.')),
      );
    }
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.azureStart,
              AppTheme.azureEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        _buildImageSection(),
                        SizedBox(height: 20),
                        _buildReportForm(),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }
  
  // 앱바 위젯
  Widget _buildAppBar() {
    final title = _reportType == 'location'
        ? '위치 제보하기'
        : '잘못된 식별 제보하기';
        
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
            title,
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
  
  // 이미지 섹션
  Widget _buildImageSection() {
    return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '식별된 해파리',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              // 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  child: _imagePath.startsWith('http')
                    ? Image.network(
                        _imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported, size: 30),
                        ),
                      )
                    : Image.asset(
                        _imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported, size: 30),
                        ),
                      ),
                ),
              ),
              SizedBox(width: 16),
              
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _jellyfish!.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _jellyfish!.scientificName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: _jellyfish!.dangerColor,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _getDangerLevelText(_jellyfish!.dangerLevel),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // 제보 폼
  Widget _buildReportForm() {
    return _reportType == 'location'
        ? _buildLocationReportForm()
        : _buildMisidentificationReportForm();
  }
  
  // 위치 제보 폼
  Widget _buildLocationReportForm() {
    return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '위치 정보 제보',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '해파리를 발견한 위치 정보를 제공하면 다른 사용자들에게 도움이 됩니다.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '발견 장소',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _locationController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '예: 부산 해운대 해수욕장',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          SizedBox(height: 16),
          Text(
            '상세 정보 (선택)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _detailsController,
            style: TextStyle(color: Colors.white),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: '추가 정보나 특이사항을 입력하세요',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.cyan, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '제보하신 정보는 검토 후 다른 사용자들에게 공유됩니다.',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // 잘못된 식별 제보 폼
  Widget _buildMisidentificationReportForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassContainer(
          borderRadius: 16,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '잘못된 식별 제보',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '이 해파리의 종류가 잘못 식별되었다고 생각하시면, 아래에서 올바른 종류를 선택하세요.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '올바른 해파리 종류 선택',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        _buildJellyfishSelectionList(),
        SizedBox(height: 16),
        GlassContainer(
          borderRadius: 16,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '상세 정보 (선택)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _detailsController,
                style: TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '잘못된 식별이라고 생각하는 이유나 특이사항을 입력하세요',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.cyan, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '제보하신 정보는 검토 후 반영됩니다. 정확한 식별에 도움을 주셔서 감사합니다.',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // 해파리 선택 목록
  Widget _buildJellyfishSelectionList() {
    return Container(
      height: 320,
      child: ListView.builder(
        itemCount: _jellyfishList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final jellyfish = _jellyfishList[index];
          
          // 현재 식별된 해파리는 제외
          if (jellyfish.id == _jellyfishId) {
            return SizedBox.shrink();
          }
          
          return Obx(() => GestureDetector(
            onTap: () => _selectedJellyfishIndex.value = index,
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: _selectedJellyfishIndex.value == index
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedJellyfishIndex.value == index
                      ? Colors.blue
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        jellyfish.name.substring(0, 1),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jellyfish.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          jellyfish.scientificName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _selectedJellyfishIndex.value == index
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: _selectedJellyfishIndex.value == index
                        ? Colors.blue
                        : Colors.white.withOpacity(0.5),
                    size: 24,
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
  
  // 제출 버튼
  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() => ElevatedButton(
        onPressed: _isSubmitting.value ? null : _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: _isSubmitting.value
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  '제보하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      )),
    );
  }
  
  // 제보 제출
  void _submitReport() async {
    // 유효성 검사
    if (_reportType == 'location' && _locationController.text.trim().isEmpty) {
      Get.snackbar(
        '입력 오류',
        '발견 장소를 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    if (_reportType == 'misidentification' && _selectedJellyfishIndex.value == -1) {
      Get.snackbar(
        '선택 오류',
        '올바른 해파리 종류를 선택해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    // 제출 시작
    _isSubmitting.value = true;
    
    try {
      if (_reportType == 'location') {
        // 위치 제보 처리
        await _jellyfishController.reportJellyfish(_jellyfishId);
        
        // 실제 구현에서는 여기에 위치 정보 저장 로직 추가
        print('위치 제보: ${_locationController.text}');
        print('상세 정보: ${_detailsController.text}');
      } else {
        // 잘못된 식별 제보 처리
        if (_selectedJellyfishIndex.value >= 0 && _selectedJellyfishIndex.value < _jellyfishList.length) {
          final correctJellyfish = _jellyfishList[_selectedJellyfishIndex.value];
          
          // 실제 구현에서는 여기에 잘못된 식별 정보 저장 로직 추가
          print('잘못된 식별 제보: ${_jellyfish!.name} -> ${correctJellyfish.name}');
          print('상세 정보: ${_detailsController.text}');
          
          // 사용자 경험치 추가 (제보 보상)
          await _userController.incrementReportedJellyfish();
        }
      }
      
      // 성공 메시지 표시
      Get.snackbar(
        '제보 완료',
        '소중한 제보 감사합니다. 검토 후 반영됩니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
      // 딜레이 후 이전 화면으로 돌아가기
      Future.delayed(Duration(seconds: 2), () {
        Get.back();
      });
      
    } catch (e) {
      print('제보 에러: $e');
      Get.snackbar(
        '제보 오류',
        '제보 중 오류가 발생했습니다. 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      _isSubmitting.value = false;
    }
  }
  
  // 위험도 텍스트 반환
  String _getDangerLevelText(DangerLevel level) {
    switch (level) {
      case DangerLevel.safe:
        return '안전';
      case DangerLevel.mild:
        return '경미';
      case DangerLevel.moderate:
        return '보통';
      case DangerLevel.severe:
        return '위험';
      case DangerLevel.deadly:
        return '치명적';
    }
  }
} 