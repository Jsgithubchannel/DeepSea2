import 'package:get/get.dart';
import 'package:jellyfish_test/data/repositories/jellyfish_repository.dart';
import 'package:jellyfish_test/data/repositories/user_repository.dart';
import 'package:jellyfish_test/presentation/controllers/home_controller.dart';

/// 앱 초기화 시 필요한 의존성 주입을 설정하는 클래스
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // 리포지토리 등록 (싱글톤)
    Get.putAsync<UserRepository>(() => UserRepository().init());
    Get.putAsync<JellyfishRepository>(() => JellyfishRepository().init());
    
    // 컨트롤러 등록 (레이지 로딩)
    Get.lazyPut<HomeController>(() => HomeController());
  }
} 