import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

/// 로그인 화면
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // 로고 애니메이션 컨트롤러
  late final AnimationController _logoAnimationController;
  late final Animation<double> _logoScaleAnimation;

  // 물결 애니메이션 컨트롤러
  late final AnimationController _waveAnimationController;

  // 버튼 애니메이션 컨트롤러
  late final AnimationController _buttonsAnimationController;
  late final Animation<double> _buttonsAnimation;

  // 입장 애니메이션 컨트롤러
  late final AnimationController _entryAnimationController;
  late final Animation<double> _logoEntryAnimation;
  late final Animation<double> _formEntryAnimation;

  // 로그인 중 상태
  final RxBool _isLoggingIn = false.obs;

  // 사용자 컨트롤러
  final UserController _userController = Get.find<UserController>();

  // 사용자 이름 컨트롤러
  final TextEditingController _nameController = TextEditingController();

  // 이름 입력 오류
  final RxString _nameError = ''.obs;

  // 약관 동의 상태
  final RxBool _agreedToTerms = true.obs;

  @override
  void initState() {
    super.initState();

    // 입장 애니메이션 설정
    _entryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoEntryAnimation = CurvedAnimation(
      parent: _entryAnimationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );

    _formEntryAnimation = CurvedAnimation(
      parent: _entryAnimationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    );

    // 로고 애니메이션 설정
    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // 물결 애니메이션 설정
    _waveAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // 버튼 애니메이션 설정
    _buttonsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonsAnimation = CurvedAnimation(
      parent: _buttonsAnimationController,
      curve: Curves.easeInOut,
    );

    // 기존 사용자 이름이 있으면 설정
    _nameController.text = _userController.user.name;

    // 애니메이션 시작
    _entryAnimationController.forward();
    _buttonsAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _waveAnimationController.dispose();
    _buttonsAnimationController.dispose();
    _entryAnimationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

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
        child: Stack(
          children: [
            // 배경 물결 애니메이션 (상단으로 조정)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _waveAnimationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(
                      animationValue: _waveAnimationController.value,
                      waveColor: Colors.white.withOpacity(0.08),
                      isTop: true,
                    ),
                  );
                },
              ),
            ),

            // 메인 콘텐츠
            SafeArea(
              bottom: false,
              child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: isSmallScreen ? 16.0 : 24.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 상단 여백 대폭 증가
                        SizedBox(height: isSmallScreen ? 80 : 120),

                        // 로고 애니메이션 (크기와 상하 여백 조정)
                        ScaleTransition(
                          scale: _logoEntryAnimation,
                          child: AnimatedBuilder(
                            animation: _logoAnimationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoScaleAnimation.value,
                                child: child,
                              );
                            },
                            child: Container(
                              width: isSmallScreen ? 110 : 130,
                              height: isSmallScreen ? 110 : 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // 해파리 모양의 아이콘
                                    Transform.translate(
                                      offset: Offset(0, -2),
                                      child: Icon(
                                        Icons.water,
                                        color: Colors.blue.shade400,
                                        size: isSmallScreen ? 70 : 84,
                                      ),
                                    ),
                                    // 작은 해파리 이미지(또는 아이콘)
                                    Positioned(
                                      bottom: isSmallScreen ? 25 : 30,
                                      right: isSmallScreen ? 22 : 26,
                                      child: Icon(
                                        Icons.spa,
                                        color: Colors.lightBlue.shade300,
                                        size: isSmallScreen ? 24 : 28,
                                      ),
                                    ),
                                    // 경고 표시
                                    Positioned(
                                      top: isSmallScreen ? 20 : 24,
                                      right: isSmallScreen ? 20 : 24,
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          isSmallScreen ? 3 : 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.priority_high,
                                          color: Colors.white,
                                          size: isSmallScreen ? 14 : 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 60 : 80),

                        // 환영 메시지 (애니메이션 추가)
                        FadeTransition(
                          opacity: _logoEntryAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.5),
                              end: Offset.zero,
                            ).animate(_logoEntryAnimation),
                            child: Column(
                              children: [
                                Text(
                                  '감식반에 합류하세요',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 22 : 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '해파리를 기록하고 공유하세요',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 70 : 90),

                        // 로그인 옵션 (애니메이션 추가)
                        FadeTransition(
                          opacity: _formEntryAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(_formEntryAnimation),
                            child: GlassContainer(
                              padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                              borderRadius: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 사용자 이름 입력
                                  _buildNameInputField(isSmallScreen),
                                  SizedBox(height: isSmallScreen ? 24 : 30),

                                  // 소셜 로그인 버튼들
                                  _buildSocialLoginButton(
                                    icon: Icons.g_mobiledata,
                                    text: '구글로 계속하기',
                                    color: Colors.white,
                                    textColor: Colors.black87,
                                    onTap: _handleGoogleLogin,
                                    isLoading: _isLoggingIn,
                                    delay: 0,
                                  ),
                                  SizedBox(height: 12),

                                  // 이용약관 동의
                                  Obx(
                                    () => InkWell(
                                      onTap:
                                          () =>
                                              _agreedToTerms.value =
                                                  !_agreedToTerms.value,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: Checkbox(
                                                value: _agreedToTerms.value,
                                                onChanged:
                                                    (value) =>
                                                        _agreedToTerms.value =
                                                            value ?? true,
                                                fillColor:
                                                    MaterialStateProperty.resolveWith(
                                                      (states) => Colors.blue
                                                          .withOpacity(0.7),
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '이용약관 및 개인정보처리방침에 동의합니다',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 24 : 36),

                        // 게스트 로그인 버튼 (애니메이션 추가)
                        FadeTransition(
                          opacity: _formEntryAnimation,
                          child: TextButton(
                            onPressed: _navigateToHomeAsGuest,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withOpacity(0.8),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              backgroundColor: Colors.white.withOpacity(0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility_outlined, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  '먼저 둘러보기',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 90 : 120),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이름 입력 필드
  Widget _buildNameInputField(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '프로필 이름',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: -5,
              ),
            ],
          ),
          child: TextField(
            controller: _nameController,
            style: TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: '이름을 입력하세요',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              isDense: true,
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
            ),
            onChanged: (value) {
              // 오류 메시지 초기화
              if (_nameError.value.isNotEmpty) {
                _nameError.value = '';
              }
            },
          ),
        ),
        // 오류 메시지
        Obx(
          () =>
              _nameError.value.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _nameError.value,
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // 소셜 로그인 버튼 위젯
  Widget _buildSocialLoginButton({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    required RxBool isLoading,
    required double delay,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _buttonsAnimationController,
          curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.2, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _buttonsAnimationController,
            curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
          ),
        ),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(10),
          elevation: 2,
          shadowColor: color.withOpacity(0.3),
          child: InkWell(
            onTap: isLoading.value ? null : onTap,
            borderRadius: BorderRadius.circular(10),
            splashColor: textColor.withOpacity(0.1),
            highlightColor: textColor.withOpacity(0.05),
            child: Container(
              height: 46,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(icon, color: textColor, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Obx(
                    () =>
                        isLoading.value
                            ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  textColor,
                                ),
                              ),
                            )
                            : Icon(
                              Icons.arrow_forward_ios,
                              color: textColor.withOpacity(0.5),
                              size: 14,
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 이름 검증
  bool _validateName() {
    if (_nameController.text.trim().isEmpty) {
      _nameError.value = '이름을 입력해주세요';
      return false;
    }

    if (_nameController.text.trim().length < 2) {
      _nameError.value = '이름은 최소 2자 이상이어야 합니다';
      return false;
    }

    return true;
  }

  // 사용자 이름 업데이트 및 로그인 진행
  Future<void> _processLogin() async {
    if (!_validateName()) {
      _isLoggingIn.value = false;
      return;
    }

    if (!_agreedToTerms.value) {
      Get.snackbar(
        '약관 동의 필요',
        '서비스 이용을 위해 약관에 동의해주세요',
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
      );
      _isLoggingIn.value = false;
      return;
    }

    try {
      await _userController.updateUsername(_nameController.text.trim());
      await _userController.updateLastLoginDate();
      _navigateToPermission();
    } catch (e) {
      print('로그인 처리 오류: $e');
      _isLoggingIn.value = false;
      Get.snackbar(
        '오류',
        '로그인 중 문제가 발생했습니다. 다시 시도해주세요.',
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 구글 로그인 처리
  void _handleGoogleLogin() async {
    // 1. 약관 동의 먼저 확인
    if (!_agreedToTerms.value) {
      Get.snackbar(
        '약관 동의 필요',
        'Google 로그인을 진행하기 전에 약관에 동의해주세요.',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
      );
      return; // 약관 미동의 시 중단
    }

    // 2. 로딩 상태 시작
    _isLoggingIn.value = true;

    try {
      // 3. UserController를 통해 Google 로그인 시도
      final fb_auth.User? firebaseUser =
          await _userController.signInWithGoogle();

      // 4. 로그인 성공 여부 확인
      if (firebaseUser != null) {
        // Google 로그인 성공
        print('LoginScreen: Google 로그인 성공 확인됨 - UID: ${firebaseUser.uid}');

        // UserController의 _handleAuthStateChanged가 비동기적으로 실행되어
        // _user 상태를 업데이트했을 것입니다.
        // initState의 'ever' 리스너가 _nameController를 업데이트 했을 수 있습니다.
        // 잠시 기다려 상태 반영 시간을 줄 수 있습니다 (선택적).
        // await Future.delayed(Duration(milliseconds: 100));

        // 5. 최종 로그인 처리 (이름 검증, 데이터 업데이트, 화면 전환)
        // _processLogin은 내부적으로 _nameController의 값을 사용하고,
        // 약관 동의를 다시 확인하며, 사용자 이름/로그인 날짜 업데이트 후 화면 전환.
        await _processLogin();
      } else {
        // Google 로그인 실패 또는 취소됨
        // UserController 내부 또는 _handleAuthStateChanged에서
        // 이미 사용자에게 Snackbar 등으로 알렸을 수 있습니다.
        print('LoginScreen: Google 로그인 실패 또는 취소됨.');
        // 여기서 추가적인 실패 메시지를 표시할 수도 있습니다.
        // Get.snackbar('로그인 실패', 'Google 계정으로 로그인하지 못했습니다.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // 예기치 못한 에러 처리 (signInWithGoogle 내부에서 처리되지 않은 경우)
      print('LoginScreen: _handleGoogleLogin 에러: $e');
      Get.snackbar(
        '오류',
        '로그인 중 예기치 않은 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // 6. 로딩 상태 종료 (성공/실패/오류 여부와 관계없이)
      // _processLogin 성공 시 화면 전환이 일어나므로,
      // 실패/취소/오류 시에만 false로 설정되도록 할 수도 있습니다.
      // 하지만 일반적으로는 항상 종료하는 것이 안전합니다.
      if (mounted) {
        // 위젯이 여전히 마운트 상태인지 확인
        _isLoggingIn.value = false;
      }
    }
  }

  // _processLogin 함수는 이름 검증, 약관 재확인,
  // _userController.updateUsername, _userController.updateLastLoginDate 호출,
  // 화면 전환(_navigateToPermission)을 수행합니다.
  // Google 로그인 시 이름이 자동으로 채워졌더라도 _validateName()을 통과해야 합니다.

  // 권한 화면으로 이동
  void _navigateToPermission() {
    Get.offAllNamed(AppRoutes.permission);
  }

  // 게스트로 홈 화면으로 이동
  void _navigateToHomeAsGuest() async {
    // 게스트 이름으로 설정
    if (_nameController.text.trim().isEmpty) {
      await _userController.updateUsername('게스트');
    } else {
      await _userController.updateUsername(_nameController.text.trim());
    }
    await _userController.updateLastLoginDate();
    Get.offAllNamed(AppRoutes.home);
  }
}

/// 배경 물결 애니메이션을 위한 커스텀 페인터
class WavePainter extends CustomPainter {
  final double animationValue;
  final Color waveColor;
  final bool isTop;

  WavePainter({
    required this.animationValue,
    required this.waveColor,
    this.isTop = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()..color = waveColor;

    if (isTop) {
      // 상단 물결 (역방향)
      final path = Path();
      path.moveTo(
        0,
        height * 0.25 - math.sin(animationValue * 2 * 3.14159) * 15,
      );

      for (int i = 0; i < width; i++) {
        double x = i.toDouble();
        double y =
            height * 0.25 -
            math.sin(
                  (animationValue * 2 * 3.14159) + (x / width * 2 * 3.14159),
                ) *
                15 -
            math.sin(
                  (animationValue * 4 * 3.14159) + (x / width * 3 * 3.14159),
                ) *
                8;
        path.lineTo(x, y);
      }

      path.lineTo(width, 0);
      path.lineTo(0, 0);
      path.close();

      canvas.drawPath(path, paint);

      // 두 번째 상단 물결 (역방향)
      final path2 = Path();
      paint.color = waveColor.withOpacity(0.5);
      path2.moveTo(
        0,
        height * 0.2 - math.sin(animationValue * 3 * 3.14159) * 10,
      );

      for (int i = 0; i < width; i++) {
        double x = i.toDouble();
        double y =
            height * 0.2 -
            math.sin(
                  (animationValue * 3 * 3.14159) + (x / width * 4 * 3.14159),
                ) *
                10 -
            math.sin(
                  (animationValue * 5 * 3.14159) + (x / width * 5 * 3.14159),
                ) *
                5;
        path2.lineTo(x, y);
      }

      path2.lineTo(width, 0);
      path2.lineTo(0, 0);
      path2.close();

      canvas.drawPath(path2, paint);
    } else {
      // 하단 물결 (기존 코드)
      final path = Path();
      path.moveTo(
        0,
        height * 0.8 + math.sin(animationValue * 2 * 3.14159) * 10,
      );

      for (int i = 0; i < width; i++) {
        double x = i.toDouble();
        double y =
            height * 0.8 +
            math.sin(
                  (animationValue * 2 * 3.14159) + (x / width * 2 * 3.14159),
                ) *
                10 +
            math.sin(
                  (animationValue * 4 * 3.14159) + (x / width * 4 * 3.14159),
                ) *
                5;
        path.lineTo(x, y);
      }

      path.lineTo(width, height);
      path.lineTo(0, height);
      path.close();

      canvas.drawPath(path, paint);

      // 두 번째 물결 (하단)
      final path2 = Path();
      paint.color = waveColor.withOpacity(0.5);
      path2.moveTo(
        0,
        height * 0.85 + math.sin(animationValue * 3 * 3.14159) * 8,
      );

      for (int i = 0; i < width; i++) {
        double x = i.toDouble();
        double y =
            height * 0.85 +
            math.sin(
                  (animationValue * 3 * 3.14159) + (x / width * 3 * 3.14159),
                ) *
                8 +
            math.sin(
                  (animationValue * 5 * 3.14159) + (x / width * 5 * 3.14159),
                ) *
                4;
        path2.lineTo(x, y);
      }

      path2.lineTo(width, height);
      path2.lineTo(0, height);
      path2.close();

      canvas.drawPath(path2, paint);
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}
