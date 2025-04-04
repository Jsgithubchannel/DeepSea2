import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/presentation/screens/collection_screen.dart';
import 'package:jellyfish_test/presentation/screens/home_screen.dart';
import 'package:jellyfish_test/presentation/screens/jellyfish_detail_screen.dart';
import 'package:jellyfish_test/presentation/screens/login_screen.dart';
import 'package:jellyfish_test/presentation/screens/onboarding_screen.dart';
import 'package:jellyfish_test/presentation/screens/permission_screen.dart';
import 'package:jellyfish_test/presentation/screens/profile_screen.dart';
import 'package:jellyfish_test/presentation/screens/quiz_screen.dart';
import 'package:jellyfish_test/presentation/screens/identification_result_screen.dart';
import 'package:jellyfish_test/presentation/screens/jellyfish_report_screen.dart';
import 'package:jellyfish_test/presentation/screens/jellyfish_sting_report_screen.dart';
import 'package:jellyfish_test/presentation/screens/identification_screen.dart';

/// 앱 라우트 정의
class AppRoutes {
  // 라우트 이름 정의
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const permission = '/permission';
  static const home = '/home';
  static const collection = '/collection';
  static const identification = '/identification';
  static const identificationResult = '/identification_result';
  static const quiz = '/quiz';
  static const profile = '/profile';
  static const jellyfishDetail = '/jellyfish_detail';
  static const jellyfishReport = '/jellyfish_report';
  static const jellyfishStingReport = '/jellyfish_sting_report';
  
  // 라우트 설정
  static final routes = [
    GetPage(
      name: splash,
      page: () => const _PlaceholderPage(title: '스플래시 화면'),
      transition: Transition.fade,
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: permission,
      page: () => const PermissionScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: collection,
      page: () => const CollectionScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: identification,
      page: () => const IdentificationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: identificationResult,
      page: () => IdentificationResultScreen(
        jellyfishId: Get.arguments?['jellyfishId'] ?? '',
        imagePath: Get.arguments?['imagePath'] ?? '',
        confidenceScore: Get.arguments?['confidenceScore'] ?? 0.9,
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: quiz,
      page: () => const QuizScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: jellyfishDetail,
      page: () => JellyfishDetailScreen(
        jellyfishId: Get.arguments?['jellyfishId'] ?? '',
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: jellyfishReport,
      page: () => JellyfishReportScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: jellyfishStingReport,
      page: () => JellyfishStingReportScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 350),
    ),
  ];

  // 초기 라우트
  static const initial = login;
}

/// 임시 플레이스홀더 페이지
class _PlaceholderPage extends StatelessWidget {
  final String title;
  
  const _PlaceholderPage({
    Key? key,
    required this.title,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.amber,
            ),
            SizedBox(height: 24),
            Text(
              '준비 중입니다',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$title이 곧 준비됩니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('돌아가기'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 