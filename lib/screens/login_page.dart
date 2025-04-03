import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // UserCredential 사용을 위해 필요할 수 있음
// import 'package:deepsea2/services/auth_service.dart'; // 경로는 실제 프로젝트 이름에 맞게 확인/수정
import '../services/auth_service.dart'; // 같은 lib 폴더 내의 상위 폴더 참조

class LoginPage extends StatelessWidget {
  // AuthService 인스턴스 생성
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Google 계정으로 로그인'),
          onPressed: () async {
            // 버튼 클릭 시 Google 로그인 시도
            // 로딩 인디케이터 등을 표시하는 로직 추가 가능
            UserCredential? userCredential =
                await _authService.signInWithGoogle();

            // 로그인 성공 여부에 따른 처리 (AuthWrapper가 화면 전환을 처리하므로 여기서는 추가 작업 없음)
            if (userCredential != null) {
              // 성공 시 (AuthWrapper가 HomePage로 전환)
              // 필요한 경우 여기서 추가 로직 수행 (예: 사용자 정보 저장)
            } else {
              // 실패 시 (사용자 취소 또는 에러)
              // 사용자에게 피드백 제공 (예: SnackBar)
              if (context.mounted) {
                // 위젯이 여전히 마운트되어 있는지 확인 (비동기 작업 후)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Google 로그인을 취소했거나 실패했습니다.')),
                );
              }
            }
            // 로딩 인디케이터 숨기는 로직 추가 가능
          },
        ),
      ),
    );
  }
}
