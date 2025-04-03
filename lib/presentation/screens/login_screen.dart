import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // 로그인 중 상태
  final RxBool _isLoggingIn = false.obs;

  // AuthService 인스턴스 추가
  final AuthService _authService = AuthService();

  // 사용자 컨트롤러
  final UserController _userController = Get.find<UserController>();

  // 사용자 이름 컨트롤러
  final TextEditingController _nameController = TextEditingController();

  // 이름 입력 오류
  final RxString _nameError = ''.obs;

  @override
  void initState() {
    super.initState();

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

    // 기존 사용자 이름이 있으면 설정
    _nameController.text = _userController.user.value.name;
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2980), Color(0xFF0E1648)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 로고 애니메이션
                    AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.healing,
                                  color: Color(0xFF1A2980),
                                  size: 50,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 환영 메시지
                    const Text(
                      '감식반에 합류하세요',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '해파리를 기록하고 공유하세요',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // 로그인 옵션
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // 사용자 이름 입력
                          _buildNameInputField(),
                          const SizedBox(height: 20),

                          // 구글 로그인 버튼
                          _buildSocialLoginButton(
                            // icon: Icons.g_mobiledata, // 아이콘은 적절히 변경
                            icon: Icons.login,
                            text: 'Google 계정으로 계속하기',
                            color: Colors.white,
                            textColor: Colors.black87,
                            onTap: _handleGoogleLogin, // ★ Google 로그인 함수 연결
                            isLoading: _isLoggingIn, // ★ 로딩 상태 연결
                          ),
                          const SizedBox(height: 12),

                          // 카카오 로그인 버튼
                          _buildSocialLoginButton(
                            icon: Icons.chat_bubble,
                            text: '카카오로 계속하기',
                            color: const Color(0xFFFEE500),
                            textColor: Colors.black87,
                            onTap: _handleKakaoLogin,
                            isLoading: _isLoggingIn,
                          ),
                          const SizedBox(height: 12),

                          // 네이버 로그인 버튼
                          _buildSocialLoginButton(
                            icon: Icons.north_east,
                            text: '네이버로 계속하기',
                            color: const Color(0xFF03C75A),
                            textColor: Colors.white,
                            onTap: _handleNaverLogin,
                            isLoading: _isLoggingIn,
                          ),
                          const SizedBox(height: 16),

                          // 이용약관 동의
                          Row(
                            children: [
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: Checkbox(
                                  value: true,
                                  onChanged: (value) {},
                                  fillColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.blue.withOpacity(0.7),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '이용약관 및 개인정보처리방침에 동의합니다',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 회원가입 없이 계속하기
                    TextButton(
                      onPressed: _navigateToHomeAsGuest,
                      child: Text(
                        '먼저 둘러보기',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
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

  // 이름 입력 필드
  Widget _buildNameInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '프로필 이름',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: '이름을 입력하세요',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              isDense: true,
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
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
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
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: isLoading.value ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(
                () =>
                    isLoading.value
                        ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              textColor,
                            ),
                          ),
                        )
                        : const SizedBox(width: 0),
              ),
            ],
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
    if (!_validateName()) return;

    try {
      await _userController.updateUserName(_nameController.text.trim());
      await _userController.updateLastLoginDate();
      _navigateToPermission();
    } catch (e) {
      print('로그인 처리 오류: $e');
      _isLoggingIn.value = false;
    }
  }

  // 구글 로그인 처리
  void _handleGoogleLogin() async {
    _isLoggingIn.value = true; // 로딩 시작
    try {
      // AuthService를 통해 Google 로그인 시도
      UserCredential? userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        // 로그인 성공!
        print(
          "Google 로그인 및 Firebase 인증 성공: ${userCredential.user?.displayName}",
        );

        // 중요: AuthWrapper가 로그인 상태 변화를 감지하고 자동으로
        // HomePage 등으로 화면을 전환해주므로, 여기서 별도의 화면 전환 코드는
        // 필요 없을 수 있습니다. (AuthWrapper를 사용하고 있다는 가정 하에)
      } else {
        // 로그인 실패 또는 사용자가 취소
        Get.snackbar(
          '로그인 실패',
          'Google 로그인을 취소했거나 오류가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // 예외 처리
      print("Google 로그인 중 예외 발생: $e");
      Get.snackbar(
        '로그인 오류',
        '로그인 처리 중 문제가 발생했습니다. 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      _isLoggingIn.value = false; // 로딩 종료 (성공/실패/예외 모두)
    }
  }

  // 카카오 로그인 처리
  void _handleKakaoLogin() async {
    _isLoggingIn.value = true;

    // 실제 구현에서는 카카오 로그인 API 호출
    Future.delayed(const Duration(seconds: 1), () async {
      await _processLogin();
    });
  }

  // 네이버 로그인 처리
  void _handleNaverLogin() async {
    _isLoggingIn.value = true;

    // 실제 구현에서는 네이버 로그인 API 호출
    Future.delayed(const Duration(seconds: 1), () async {
      await _processLogin();
    });
  }

  // 권한 화면으로 이동
  void _navigateToPermission() {
    Get.offAllNamed(AppRoutes.permission);
  }

  // 게스트로 홈 화면으로 이동
  void _navigateToHomeAsGuest() async {
    // 게스트 이름으로 설정
    if (_nameController.text.trim().isEmpty) {
      await _userController.updateUserName('게스트');
    } else {
      await _userController.updateUserName(_nameController.text.trim());
    }
    await _userController.updateLastLoginDate();
    Get.offAllNamed(AppRoutes.home);
  }
}
