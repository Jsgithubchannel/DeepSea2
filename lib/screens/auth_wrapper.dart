import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:deepsea2/services/auth_service.dart'; // 경로는 실제 프로젝트 이름에 맞게 확인/수정
// import 'package:deepsea2/screens/login_page.dart';   // 경로는 실제 프로젝트 이름에 맞게 확인/수정
// import 'package:deepsea2/screens/home_page.dart';    // 경로는 실제 프로젝트 이름에 맞게 확인/수정
import '../services/auth_service.dart'; // 같은 lib 폴더 내의 상위 폴더 참조
import 'login_page.dart';
import 'home_page.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // AuthService의 authStateChanges 스트림을 구독하여 로그인 상태 변화 감지
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // 스트림 연결 중일 때 로딩 인디케이터 표시
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // 스트림 데이터가 있고 (사용자 객체가 존재하면) 로그인 된 상태
        else if (snapshot.hasData) {
          // HomePage로 이동 (사용자 정보를 전달)
          // snapshot.data! 는 User 객체가 null이 아님을 명시적으로 나타냄
          return HomePage(user: snapshot.data!);
        }
        // 스트림 데이터가 없으면 (사용자 객체가 null이면) 로그아웃 상태
        else {
          // LoginPage로 이동
          return LoginPage();
        }
      },
    );
  }
}
