import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/app/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('앱 초기화 중...');
    
    // Hive 초기화
    await Hive.initFlutter();
    
    // 모델 어댑터 등록
    Hive.registerAdapter(DangerLevelAdapter());
    Hive.registerAdapter(JellyfishAdapter());
    
    // 컨트롤러 등록
    Get.put(JellyfishController());
    Get.put(UserController());
    
    // onInit 메서드가 자동으로 호출되어 초기화가 진행됩니다
    // onInit에서 isLoading 상태가 관리되며 HomeScreen에서 이를 관찰합니다
    
    print('앱 초기화 완료!');
    
    runApp(const MyApp());
  } catch (e) {
    print('앱 초기화 중 오류 발생: $e');
    // 에러 화면을 표시하거나 재시도 로직을 구현할 수 있습니다
    runApp(const ErrorApp());
  }
}

/// 앱의 진입점 클래스
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '해파리 감식반 GO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
    );
  }
}

/// 에러 발생 시 표시할 앱
class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '해파리 도감 - 오류',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
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
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  '앱 초기화 중 오류가 발생했습니다',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 앱 재시작
                    main();
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
