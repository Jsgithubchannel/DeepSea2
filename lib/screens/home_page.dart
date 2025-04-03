import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:deepsea2/services/auth_service.dart'; // 경로는 실제 프로젝트 이름에 맞게 확인/수정
import '../services/auth_service.dart'; // 같은 lib 폴더 내의 상위 폴더 참조

class HomePage extends StatelessWidget {
  // AuthWrapper로부터 전달받은 사용자 정보
  final User user;
  // AuthService 인스턴스 생성
  final AuthService _authService = AuthService();

  // 생성자: 사용자 정보를 필수로 받음
  HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
        actions: [
          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
            onPressed: () async {
              // 버튼 클릭 시 로그아웃 시도
              await _authService.signOut();
              // 로그아웃 성공 시 AuthWrapper가 자동으로 LoginPage로 전환
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 사용자 프로필 이미지 (있다면)
            if (user.photoURL != null)
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL!),
                radius: 40,
              ),
            const SizedBox(height: 16),
            // 사용자 이름 또는 이메일 표시
            Text(
              '환영합니다, ${user.displayName ?? user.email ?? '사용자'}님!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Firebase UID: ${user.uid}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
