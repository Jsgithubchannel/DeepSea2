import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // print 문을 위해 추가 (선택 사항)

class AuthService {
  // Firebase 인증 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Google 로그인 인스턴스
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google 로그인 시도
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Google 로그인 창 띄우기 및 계정 선택
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 사용자가 로그인을 취소한 경우 null 반환
      if (googleUser == null) {
        print('Google 로그인 취소됨');
        return null;
      }

      // 2. Google 로그인 정보로부터 인증 토큰 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Firebase 인증을 위한 크리덴셜(credential) 생성
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. 생성된 크리덴셜을 사용하여 Firebase에 로그인
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (kDebugMode) {
        // 개발 모드에서만 출력
        print('Firebase Google 로그인 성공: ${userCredential.user?.displayName}');
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Firebase 인증 관련 에러 처리
      if (kDebugMode) {
        print('Firebase 인증 에러: ${e.code} - ${e.message}');
      }
      // 실제 앱에서는 사용자에게 에러 메시지를 보여주는 로직 추가 필요
      return null;
    } catch (e) {
      // 기타 에러 처리
      if (kDebugMode) {
        print('Google 로그인 또는 Firebase 인증 중 알 수 없는 에러: $e');
      }
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Google 계정 로그아웃
      await _auth.signOut(); // Firebase 계정 로그아웃
      if (kDebugMode) {
        print('로그아웃 성공');
      }
    } catch (e) {
      if (kDebugMode) {
        print('로그아웃 에러: $e');
      }
      // 실제 앱에서는 에러 처리 로직 추가 필요
    }
  }

  // 현재 로그인된 사용자 정보 가져오기 (사용 예: 초기 로딩 등)
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // 로그인 상태 변경 감지 Stream (AuthWrapper에서 사용)
  // 사용자가 로그인하거나 로그아웃할 때마다 User 객체 또는 null을 전달
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
