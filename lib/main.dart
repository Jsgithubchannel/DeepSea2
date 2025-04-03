import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:deepsea2/screens/auth_wrapper.dart'; // 경로는 실제 프로젝트 이름에 맞게 확인/수정하세요.
import 'screens/auth_wrapper.dart'; // 위 import 대신 이 방식을 사용해도 됩니다 (같은 lib 폴더 내이므로)
import 'firebase_options.dart'; // FlutterFire CLI로 생성된 파일

void main() async {
  // Flutter 엔진과 위젯 바인딩 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 앱 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // firebase_options.dart 사용
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Google Auth', // 앱 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱 테마 색상 (선택 사항)
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 앱 시작 시 로그인 상태에 따라 화면을 분기하는 AuthWrapper를 홈으로 설정
      home: AuthWrapper(),
    );
  }
}
