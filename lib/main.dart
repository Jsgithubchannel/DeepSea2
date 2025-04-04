import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/controllers/quiz_controller.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'presentation/screens/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // flutterfire configure로 생성된 파일

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('앱 초기화 중...');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase 초기화 완료!');

    // Hive 초기화
    await Hive.initFlutter();

    // 모델 어댑터 등록 - 중복 등록 방지를 위한 예외 처리 추가
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(DangerLevelAdapter());
      }

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(JellyfishAdapter());
      }
    } catch (e) {
      print('Hive 어댑터 등록 오류: $e');
      // 어댑터 중복 오류는 무시해도 앱 실행에 문제가 없음
    }

    // 기존 컨트롤러 정리 후 재등록 (중복 인스턴스 방지)
    if (Get.isRegistered<UserController>()) {
      Get.delete<UserController>();
    }

    if (Get.isRegistered<JellyfishController>()) {
      Get.delete<JellyfishController>();
    }

    if (Get.isRegistered<QuizController>()) {
      Get.delete<QuizController>();
    }

    // 컨트롤러 등록 - 영구적(permanent) 옵션 추가
    final userController = Get.put(UserController(), permanent: true);

    // 사용자 컨트롤러가 초기화될 때까지 대기
    await Future.delayed(Duration(milliseconds: 500));

    // 해파리 컨트롤러는 사용자 컨트롤러가 초기화된 후에 등록
    final jellyfishController = Get.put(JellyfishController(), permanent: true);

    // 퀴즈 컨트롤러 등록
    final quizController = Get.put(QuizController(), permanent: true);

    // 컨트롤러 초기화 확인
    print('UserController 상태: ${userController.hashCode}');
    print('JellyfishController 상태: ${jellyfishController.hashCode}');
    print('QuizController 상태: ${quizController.hashCode}');

    print('앱 초기화 완료!');

    runApp(const MyApp());
  } catch (e) {
    print('앱 초기화 중 오류 발생: $e');
    // 오류 정보 자세히 출력
    print('오류 세부 정보: ${e.toString()}');

    // 에러 화면을 표시
    runApp(const ErrorApp());
  }
}

/// 애플리케이션 메인 클래스
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '해파리 알리미',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: AppTheme.primary,
          secondary: AppTheme.secondary,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          displayMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
      home: AuthWrapper(),
    );
  }
}

/// 에러 화면
class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '에러',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.error_outline, color: Colors.red, size: 80),
              SizedBox(height: 16),
              Text(
                '앱 초기화 중 오류가 발생했습니다',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('앱을 다시 시작해주세요.', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
