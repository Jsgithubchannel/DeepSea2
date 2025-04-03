import 'package:get/get.dart';
import 'package:jellyfish_test/core/routes/app_routes.dart';
import 'package:jellyfish_test/presentation/screens/home_screen.dart';
import 'package:jellyfish_test/presentation/screens/jellyfish_detail_screen.dart';

/// 앱 페이지 정의
class AppPages {
  /// 앱 라우트 페이지 리스트
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.jellyfishDetail,
      page: () => JellyfishDetailScreen(
        jellyfishId: Get.arguments['jellyfishId'],
      ),
      transition: Transition.rightToLeft,
    ),
    // 추가 페이지는 여기에 등록
  ];
} 