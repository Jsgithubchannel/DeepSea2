import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 필요한 위젯 및 서비스 import (경로 확인!)
import '../../services/auth_service.dart'; // 상대 경로 예시
import './login_screen.dart'; // 상대 경로 예시
import '../pages/home_page.dart'; // 상대 경로 예시

class AuthWrapper extends StatelessWidget {
  // AuthService 인스턴스 생성
  final AuthService _authService = AuthService();

  AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthService의 authStateChanges 스트림을 구독하여 로그인 상태 변화를 실시간으로 감지
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges, // 로그인/로그아웃 시 User 객체 또는 null 반환
      builder: (context, snapshot) {
        // 상태 1: 스트림 연결 중 (앱 시작 시 또는 상태 변경 시 잠시)
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중임을 나타내는 화면 반환
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // 상태 2: 스트림에 데이터가 있음 (User 객체가 null 아님 -> 로그인 됨)
        else if (snapshot.hasData) {
          // HomePage에 user 파라미터를 전달하지 않고 그냥 생성
          return const HomePage();
        }
        // 상태 3: 스트림에 데이터가 없음 (User 객체가 null -> 로그아웃 됨)
        else {
          return const LoginScreen(); // LoginPage가 StatelessWidget이라면 const 사용 가능
        }
      },
    );
  }
}
