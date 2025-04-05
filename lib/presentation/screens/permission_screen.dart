import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/app/app_routes.dart';

/// 권한 요청 화면
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러
  late final AnimationController _animationController;
  late final Animation<double> _floatAnimation;

  // 권한 상태
  final RxBool _cameraPermissionGranted = false.obs;
  final RxBool _locationPermissionGranted = false.obs;
  final RxBool _isRequestingPermission = false.obs;

  @override
  void initState() {
    super.initState();

    // 애니메이션 설정
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.azureStart, AppTheme.azureEnd],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 해파리 캐릭터 (애니메이션)
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        // child: Center(
                        //   child: Image.asset(
                        //     'assets/images/jellyfish_character.png',
                        //     width: 150,
                        //     height: 150,
                        //     fit: BoxFit.contain,
                        //     errorBuilder: (context, error, stackTrace) => Icon(
                        //       Icons.water,
                        //       color: Colors.white,
                        //       size: 80,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 메시지
                    const Text(
                      '해파리를 발견하기 위한 준비!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '해파리를 감식하고 위치를 기록하기 위해\n카메라와 위치 권한이 필요해요',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),

                    // 권한 요청 카드
                    GlassContainer(
                      padding: const EdgeInsets.all(24),
                      borderRadius: 24,
                      child: Column(
                        children: [
                          // 카메라 권한
                          _buildPermissionItem(
                            icon: Icons.camera_alt,
                            title: '카메라 접근 권한',
                            description: '해파리를 촬영하고 인식하기 위해 필요해요',
                            isGranted: _cameraPermissionGranted,
                            onRequest: _requestCameraPermission,
                          ),
                          const SizedBox(height: 24),
                          Divider(
                            color: Colors.white.withOpacity(0.2),
                            height: 1,
                          ),
                          const SizedBox(height: 24),

                          // 위치 권한
                          _buildPermissionItem(
                            icon: Icons.location_on,
                            title: '위치 접근 권한',
                            description: '해파리 발견 위치를 기록하기 위해 필요해요',
                            isGranted: _locationPermissionGranted,
                            onRequest: _requestLocationPermission,
                          ),
                          const SizedBox(height: 36),

                          // 권한 부여 버튼
                          _buildContinueButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 나중에 설정하기 버튼
                    TextButton(
                      onPressed: _navigateToHome,
                      child: Text(
                        '나중에 설정하기',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 권한 요청 아이템 위젯
  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required RxBool isGranted,
    required VoidCallback onRequest,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                isGranted.value
                    ? Container(
                      key: const ValueKey('granted'),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                    : IconButton(
                      key: const ValueKey('request'),
                      onPressed: onRequest,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  // 계속하기 버튼
  Widget _buildContinueButton() {
    return Obx(() {
      bool allPermissionsGranted =
          _cameraPermissionGranted.value && _locationPermissionGranted.value;

      return ElevatedButton(
        onPressed:
            _isRequestingPermission.value
                ? null
                : allPermissionsGranted
                ? _navigateToHomeWithConfetti
                : _requestAllPermissions,
        style: ElevatedButton.styleFrom(
          backgroundColor: allPermissionsGranted ? Colors.green : Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child:
            _isRequestingPermission.value
                ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      allPermissionsGranted ? '바다로 출발!' : '권한 부여하기',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      allPermissionsGranted
                          ? Icons.sailing
                          : Icons.arrow_forward,
                      size: 20,
                    ),
                  ],
                ),
      );
    });
  }

  // 카메라 권한 요청
  void _requestCameraPermission() async {
    _isRequestingPermission.value = true;

    // 실제 구현 시 권한 라이브러리 사용 (permission_handler 등)
    await Future.delayed(const Duration(seconds: 1));

    _cameraPermissionGranted.value = true;
    _isRequestingPermission.value = false;
  }

  // 위치 권한 요청
  void _requestLocationPermission() async {
    _isRequestingPermission.value = true;

    // 실제 구현 시 권한 라이브러리 사용 (permission_handler 등)
    await Future.delayed(const Duration(seconds: 1));

    _locationPermissionGranted.value = true;
    _isRequestingPermission.value = false;
  }

  // 모든 권한 요청
  void _requestAllPermissions() async {
    if (!_cameraPermissionGranted.value) {
      _requestCameraPermission();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!_locationPermissionGranted.value) {
      _requestLocationPermission();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // 홈으로 이동 (권한 완료, 축하 효과)
  void _navigateToHomeWithConfetti() {
    // 성공 메시지 표시
    Get.snackbar(
      '준비 완료!',
      '이제 해파리를 발견하고 기록할 준비가 되었어요',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  // 홈으로 이동 (나중에 설정)
  void _navigateToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}
