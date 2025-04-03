import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 해파리 식별 결과 화면
class IdentificationResultScreen extends StatefulWidget {
  final String jellyfishId;
  final String imagePath;
  final double confidenceScore;
  
  const IdentificationResultScreen({
    Key? key,
    required this.jellyfishId,
    required this.imagePath,
    required this.confidenceScore,
  }) : super(key: key);

  @override
  _IdentificationResultScreenState createState() => _IdentificationResultScreenState();
}

class _IdentificationResultScreenState extends State<IdentificationResultScreen> with SingleTickerProviderStateMixin {
  final JellyfishController _jellyfishController = Get.find<JellyfishController>();
  final UserController _userController = Get.find<UserController>();
  
  late Jellyfish _jellyfish;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  bool _isLoading = true;
  int _gainedExp = 0;
  bool _isNewDiscovery = false;
  
  @override
  void initState() {
    super.initState();
    
    // 애니메이션 컨트롤러 초기화
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 페이드 애니메이션
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    // 슬라이드 애니메이션
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    // 데이터 로드
    _loadJellyfishData();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  /// 해파리 데이터 로드
  Future<void> _loadJellyfishData() async {
    try {
      // 해파리 데이터 가져오기
      _jellyfish = _jellyfishController.getJellyfishById(widget.jellyfishId)!;
      
      // 발견 처리
      if (!_jellyfish.isDiscovered) {
        _isNewDiscovery = true;
        _gainedExp = 50; // 새로운 발견은 50 경험치
        
        // 해파리 발견 처리
        await _jellyfishController.discoverJellyfish(widget.jellyfishId);
        
        // 사용자 발견 카운트 증가
        await _userController.incrementDiscoveredJellyfish();
      } else {
        _gainedExp = 10; // 이미 발견한 해파리는 10 경험치
      }
      
      // 경험치 추가
      await _userController.addExp(_gainedExp);
      
      setState(() {
        _isLoading = false;
      });
      
      // 애니메이션 시작
      _animationController.forward();
    } catch (e) {
      print('데이터 로드 오류: $e');
      setState(() {
        _isLoading = false;
      });
      
      Get.snackbar(
        '오류',
        '데이터를 불러오는 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // 로딩 상태
    if (_isLoading) {
      return Scaffold(
        body: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '결과를 불러오는 중...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
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
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          _buildImageSection(),
                          SizedBox(height: 24),
                          _buildResultSection(),
                          SizedBox(height: 24),
                          _buildActionButtons(),
                          SizedBox(height: 24),
                          _buildDangerSection(),
                          SizedBox(height: 24),
                          _buildAdditionalInfo(),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 앱바 구성
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
            '식별 결과',
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
    return Stack(
      children: [
        // 이미지 컨테이너
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: widget.imagePath.startsWith('http')
              ? Image.network(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                )
              : Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
          ),
        ),
        
        // 신뢰도 배지
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  '신뢰도: ${(widget.confidenceScore * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // 새 발견 배지
        if (_isNewDiscovery)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.new_releases_outlined, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '새 발견!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        // 위험도 배지
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getDangerBackgroundColor(_jellyfish.dangerLevel),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  _getDangerLevelText(_jellyfish.dangerLevel),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // 결과 섹션
  Widget _buildResultSection() {
    return GlassContainer(
      borderRadius: 20,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _jellyfish.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _jellyfish.scientificName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              _buildExpGained(),
            ],
          ),
          SizedBox(height: 16),
          Text(
            _jellyfish.shortDescription,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          if (_jellyfish.funFact.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _jellyfish.funFact,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  // 경험치 표시
  Widget _buildExpGained() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 4),
          Text(
            '+$_gainedExp EXP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  // 액션 버튼
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            '다음 작업',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.place_outlined,
                label: '위치 제보',
                color: Colors.green,
                onTap: _reportLocation,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.report_problem_outlined,
                label: '잘못된 식별 제보',
                color: Colors.orange,
                onTap: _reportMisidentification,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.warning_amber_rounded,
          label: '해파리 쏘임 신고 (국립수산과학원)',
          color: Colors.red,
          onTap: _reportSting,
          isFullWidth: true,
        ),
      ],
    );
  }
  
  // 액션 버튼 위젯
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 위험 섹션
  Widget _buildDangerSection() {
    return GlassContainer(
      borderRadius: 20,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: _jellyfish.dangerColor, size: 20),
              SizedBox(width: 8),
              Text(
                '위험 정보',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDangerLevelIndicator(
                  level: _jellyfish.dangerLevel,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDangerDescription(_jellyfish.dangerLevel),
        ],
      ),
    );
  }
  
  // 위험도 표시기
  Widget _buildDangerLevelIndicator({required DangerLevel level}) {
    final int levelIndex = level.index;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            final isActive = index <= levelIndex;
            return Expanded(
              child: Container(
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? _getDangerColor(DangerLevel.values[index])
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '안전',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            Text(
              '치명적',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // 위험 설명
  Widget _buildDangerDescription(DangerLevel level) {
    String description;
    
    switch (level) {
      case DangerLevel.safe:
        description = '이 해파리는 사람에게 해를 끼치지 않으며, 접촉해도 안전합니다.';
        break;
      case DangerLevel.mild:
        description = '가벼운 자극이나 통증을 유발할 수 있지만, 심각한 위험은 없습니다.';
        break;
      case DangerLevel.moderate:
        description = '쏘이면 통증과 발진을 유발할 수 있으며, 의료적 처치가 필요할 수 있습니다.';
        break;
      case DangerLevel.severe:
        description = '강한 통증, 심한 발진, 알레르기 반응 등 심각한 증상을 유발할 수 있습니다. 즉시 의료 조치가 필요합니다.';
        break;
      case DangerLevel.deadly:
        description = '극도로 위험하며, 생명을 위협할 수 있습니다. 접촉 시 즉시 응급 처치와 의료 조치가 필요합니다.';
        break;
    }
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getDangerBackgroundColor(level),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 추가 정보
  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            '추가 정보',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.straighten,
                title: '크기',
                value: _jellyfish.size,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.water,
                title: '서식지',
                value: _jellyfish.habitats.join(', '),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.palette_outlined,
          title: '색상',
          value: _jellyfish.colors.join(', '),
          isFullWidth: true,
        ),
      ],
    );
  }
  
  // 정보 카드
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isFullWidth = false,
  }) {
    return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 위치 제보하기
  void _reportLocation() {
    Get.toNamed(
      AppRoutes.jellyfishReport,
      arguments: {
        'jellyfishId': _jellyfish.id,
        'imagePath': widget.imagePath,
        'reportType': 'location',
      },
    );
  }
  
  // 잘못된 식별 제보하기
  void _reportMisidentification() {
    Get.toNamed(
      AppRoutes.jellyfishReport,
      arguments: {
        'jellyfishId': _jellyfish.id,
        'imagePath': widget.imagePath,
        'reportType': 'misidentification',
      },
    );
  }
  
  // 쏘임 신고하기
  void _reportSting() {
    Get.toNamed(
      AppRoutes.jellyfishStingReport,
      arguments: {
        'jellyfishId': _jellyfish.id,
        'imagePath': widget.imagePath,
      },
    );
  }
  
  // 위험 수준 텍스트
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
  
  // 위험 색상
  Color _getDangerColor(DangerLevel level) {
    switch (level) {
      case DangerLevel.safe:
        return Colors.green;
      case DangerLevel.mild:
        return Colors.lightGreen;
      case DangerLevel.moderate:
        return Colors.orange;
      case DangerLevel.severe:
        return Colors.deepOrange;
      case DangerLevel.deadly:
        return Colors.red;
    }
  }
  
  // 위험 배경색
  Color _getDangerBackgroundColor(DangerLevel level) {
    switch (level) {
      case DangerLevel.safe:
        return Colors.green.withOpacity(0.2);
      case DangerLevel.mild:
        return Colors.lightGreen.withOpacity(0.2);
      case DangerLevel.moderate:
        return Colors.orange.withOpacity(0.2);
      case DangerLevel.severe:
        return Colors.deepOrange.withOpacity(0.2);
      case DangerLevel.deadly:
        return Colors.red.withOpacity(0.2);
    }
  }
} 