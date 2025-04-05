import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 해파리 쏘임 신고 화면
class JellyfishStingReportScreen extends StatefulWidget {
  const JellyfishStingReportScreen({Key? key}) : super(key: key);

  @override
  _JellyfishStingReportScreenState createState() =>
      _JellyfishStingReportScreenState();
}

class _JellyfishStingReportScreenState
    extends State<JellyfishStingReportScreen> {
  final JellyfishController _jellyfishController =
      Get.find<JellyfishController>();
  final UserController _userController = Get.find<UserController>();

  // 신고 필드
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  // 날짜 및 시간
  DateTime _stingDate = DateTime.now();
  TimeOfDay _stingTime = TimeOfDay.now();

  // 로딩 상태
  final RxBool _isSubmitting = false.obs;

  // 해파리 ID 및 이미지 경로
  String? _jellyfishId;
  String? _imagePath;
  Jellyfish? _jellyfish;

  // 증상 체크리스트
  final RxList<String> _selectedSymptoms = <String>[].obs;

  // 증상 목록
  final List<String> _symptomsList = [
    '통증',
    '붓기',
    '발진',
    '가려움',
    '호흡 곤란',
    '메스꺼움',
    '두통',
    '어지러움',
    '의식 저하',
    '기타',
  ];

  @override
  void initState() {
    super.initState();
    _loadArguments();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _symptomsController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // 인자 로드
  void _loadArguments() {
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      _jellyfishId = args['jellyfishId'];
      _imagePath = args['imagePath'];

      if (_jellyfishId != null) {
        _jellyfish = _jellyfishController.getJellyfishById(_jellyfishId!);
      }
    }
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
            colors: [AppTheme.dangerStart, AppTheme.dangerEnd],
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
                        SizedBox(height: 8),
                        _buildWarningBanner(),
                        SizedBox(height: 16),
                        if (_jellyfish != null) _buildJellyfishInfo(),
                        SizedBox(height: 16),
                        _buildReportForm(),
                        SizedBox(height: 16),
                        _buildFirstAidInfo(),
                        SizedBox(height: 16),
                        _buildNearbyHospitalsSection(),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
              _buildSubmitButton(),
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
            '해파리 쏘임 신고',
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

  // 경고 배너
  Widget _buildWarningBanner() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '긴급 상황이라면 119에 먼저 신고하세요!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '심각한 증상(호흡 곤란, 심한 통증, 의식 변화 등)이 있다면 즉시 응급 의료 서비스를 이용하세요.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 해파리 정보 섹션
  Widget _buildJellyfishInfo() {
    return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '관련 해파리 정보',
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
                  child:
                      _imagePath != null && _imagePath!.startsWith('http')
                          ? Image.network(
                            _imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                  ),
                                ),
                          )
                          : _imagePath != null
                          ? Image.asset(
                            _imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                  ),
                                ),
                          )
                          : Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.help_outline, size: 30),
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
                      _jellyfish?.name ?? '알 수 없는 해파리',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _jellyfish?.scientificName ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (_jellyfish != null) ...[
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '위의 해파리가 아니라면 "알 수 없음"으로 신고해 주세요.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // 신고 폼
  Widget _buildReportForm() {
    return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '쏘임 신고 정보',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // 위치 정보
          Text(
            '위치',
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: _getCurrentLocation,
              ),
            ),
          ),
          SizedBox(height: 16),

          // 날짜 및 시간
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '날짜',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white.withOpacity(0.7),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${_stingDate.year}/${_stingDate.month}/${_stingDate.day}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '시간',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectTime,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white.withOpacity(0.7),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${_stingTime.hour}:${_stingTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // 증상 체크리스트
          Text(
            '증상 (해당하는 항목 모두 선택)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          _buildSymptomsCheckList(),
          SizedBox(height: 16),

          // 기타 증상
          Text(
            '증상 설명',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _symptomsController,
            style: TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '증상에 대해 자세히 설명해주세요',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          SizedBox(height: 16),

          // 기타 정보
          Text(
            '추가 정보 (선택)',
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
            maxLines: 2,
            decoration: InputDecoration(
              hintText: '추가 정보가 있다면 입력해주세요',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.cyan, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '신고하신 정보는 국립수산과학원에 전달되며, 해파리 관리 및 연구에 활용됩니다.',
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

  // 증상 체크리스트
  Widget _buildSymptomsCheckList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _symptomsList.map((symptom) {
            return Obx(
              () => GestureDetector(
                onTap: () => _toggleSymptom(symptom),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        _selectedSymptoms.contains(symptom)
                            ? Colors.red.withOpacity(0.4)
                            : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          _selectedSymptoms.contains(symptom)
                              ? Colors.red
                              : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _selectedSymptoms.contains(symptom)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color:
                            _selectedSymptoms.contains(symptom)
                                ? Colors.white
                                : Colors.white.withOpacity(0.6),
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        symptom,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight:
                              _selectedSymptoms.contains(symptom)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  // 응급 처치 정보
  Widget _buildFirstAidInfo() {
    return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '응급 처치 정보',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildFirstAidStep(
            icon: Icons.water_drop_outlined,
            title: '바닷물로 씻어내기',
            description: '상처 부위를 깨끗한 바닷물로 씻어냅니다. 담수나 수돗물은 사용하지 마세요.',
          ),
          _buildFirstAidStep(
            icon: Icons.do_not_touch,
            title: '독침 제거',
            description:
                '남아있는 독침은 카드나 플라스틱 카드로 조심스럽게 긁어냅니다. 직접 손으로 만지거나 문지르지 마세요.',
            isWarning: true,
          ),
          _buildFirstAidStep(
            icon: Icons.heat_pump_outlined,
            title: '온/냉 찜질',
            description:
                '대부분의 해파리 쏘임은 온찜질(40-45°C)이 효과적입니다. 상자해파리 쏘임은 냉찜질이 필요합니다.',
          ),
          _buildFirstAidStep(
            icon: Icons.health_and_safety_outlined,
            title: '의료기관 방문',
            description: '심한 통증, 알레르기 반응, 호흡 곤란 등의 증상이 있으면 즉시 병원을 방문하세요.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  // 응급 처치 단계
  Widget _buildFirstAidStep({
    required IconData icon,
    required String title,
    required String description,
    bool isWarning = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color:
                isWarning
                    ? Colors.red.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              if (!isLast)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 20,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // 주변 병원 섹션
  Widget _buildNearbyHospitalsSection() {
    return GestureDetector(
      onTap: _openNearbyHospitals,
      child: GlassContainer(
        borderRadius: 16,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.local_hospital, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주변 병원 찾기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '현재 위치 주변의 병원을 확인합니다',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // 제출 버튼
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(
        () => ElevatedButton(
          onPressed: _isSubmitting.value ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade800,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child:
                _isSubmitting.value
                    ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      '국립수산과학원에 신고하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  // 증상 토글
  void _toggleSymptom(String symptom) {
    if (_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.remove(symptom);
    } else {
      _selectedSymptoms.add(symptom);
    }
  }

  // 날짜 선택
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _stingDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.grey[800]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _stingDate) {
      setState(() {
        _stingDate = picked;
      });
    }
  }

  // 시간 선택
  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _stingTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.grey[800]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _stingTime) {
      setState(() {
        _stingTime = picked;
      });
    }
  }

  // 현재 위치 가져오기
  void _getCurrentLocation() {
    // TODO: 실제 구현에서는 위치 정보 API 활용
    _locationController.text = '현재 위치 정보를 가져오는 중...';

    // 임시 구현: 딜레이 후 더미 데이터
    Future.delayed(Duration(seconds: 1), () {
      _locationController.text = '부산 해운대구 해운대해수욕장';
    });
  }

  // 주변 병원 열기
  void _openNearbyHospitals() {
    // TODO: 실제 구현에서는 지도 앱이나 내부 지도 화면으로 이동
    Get.snackbar(
      '주변 병원',
      '주변 병원 정보를 불러오는 중입니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // 신고 제출
  void _submitReport() async {
    // 유효성 검사
    if (_locationController.text.trim().isEmpty) {
      Get.snackbar(
        '입력 오류',
        '위치 정보를 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedSymptoms.isEmpty) {
      Get.snackbar(
        '입력 오류',
        '적어도 하나의 증상을 선택해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // 제출 시작
    _isSubmitting.value = true;

    try {
      // 쏘임 신고 데이터 구성
      Map<String, dynamic> reportData = {
        'jellyfishId': _jellyfishId,
        'location': _locationController.text,
        'date': _stingDate.toString().split(' ')[0],
        'time': '${_stingTime.hour}:${_stingTime.minute}',
        'symptoms': _selectedSymptoms.toList(),
        'symptomsDetail': _symptomsController.text,
        'additionalInfo': _detailsController.text,
      };

      // 로그 출력 (실제 구현에서는 API 호출)
      print('쏘임 신고 데이터: $reportData');

      // 사용자 경험치 추가 (제보 보상)
      if (_userController != null) {
        await _userController.incrementReportedJellyfish();
      }

      // 성공 메시지
      Get.snackbar(
        '신고 완료',
        '신고가 접수되었습니다. 소중한 정보 제공에 감사드립니다.',
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
      print('신고 에러: $e');
      Get.snackbar(
        '신고 오류',
        '신고 중 오류가 발생했습니다. 다시 시도해주세요.',
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
