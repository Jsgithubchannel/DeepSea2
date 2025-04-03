import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/controllers/user_controller.dart';
import 'package:jellyfish_test/core/controllers/jellyfish_controller.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/theme/glass_container.dart';
import 'package:jellyfish_test/app/app_routes.dart';
import 'package:jellyfish_test/presentation/widgets/navigation_bar.dart';

/// 프로필 화면
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController _userController = Get.find<UserController>();
  final JellyfishController _jellyfishController = Get.find<JellyfishController>();
  
  // 이름 편집 관련
  final TextEditingController _nameController = TextEditingController();
  final RxBool _isEditingName = false.obs;
  final RxString _nameError = ''.obs;
  
  @override
  void initState() {
    super.initState();
    _nameController.text = _userController.user.value.name;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Obx(() {
            if (_userController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            
            final user = _userController.user.value;
            
            return Column(
              children: [
                // 상단 앱바
                _buildAppBar(),
                
                // 내용
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 프로필 카드
                          _buildProfileCard(user),
                          const SizedBox(height: 24),
                          
                          // 활동 통계 섹션
                          _buildSectionTitle('활동 통계'),
                          const SizedBox(height: 16),
                          _buildStatisticsCard(user),
                          const SizedBox(height: 24),
                          
                          // 설정 섹션
                          _buildSectionTitle('계정 설정'),
                          const SizedBox(height: 16),
                          _buildSettingsCard(),
                          const SizedBox(height: 100), // 네비게이션 바 공간
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: JellyfishNavigationBar(
        selectedIndex: 3,
        onTabChanged: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.home);
              break;
            case 1:
              Get.toNamed(AppRoutes.collection);
              break;
            case 2:
              Get.toNamed(AppRoutes.quiz);
              break;
            case 3:
              // 이미 프로필 화면
              break;
          }
        },
        onIdentifyTap: () {
          Get.toNamed(AppRoutes.identification);
        },
      ),
    );
  }
  
  /// 앱바 위젯
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Text(
            '내 프로필',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 40), // 균형을 위한 빈 공간
        ],
      ),
    );
  }
  
  /// 섹션 제목 위젯
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
  
  /// 프로필 카드 위젯
  Widget _buildProfileCard(user) {
    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 프로필 정보 행
          Row(
            children: [
              // 레벨 뱃지
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.indigo],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    // 반짝이는 효과
                    Positioned(
                      top: -30,
                      left: -30,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                    ),
                    // 레벨 표시
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${user.level}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "레벨",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 하단 장식선
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.cyanAccent, Colors.blue],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              
              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름 편집 모드
                    Obx(() => _isEditingName.value 
                      ? _buildNameEditField()
                      : Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                _isEditingName.value = true;
                                _nameController.text = user.name;
                              },
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.cyanAccent.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 뱃지 컨테이너
                    Row(
                      children: [
                        _buildBadge(
                          icon: "🔍",
                          count: user.discoveredJellyfishCount,
                          total: _jellyfishController.jellyfishList.length,
                          color: Colors.blue,
                          label: "발견",
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          icon: "⭐",
                          count: user.exp,
                          color: Colors.amber,
                          label: "포인트",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 경험치 바
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '다음 레벨까지',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '${user.exp % user.expToNextLevel}/${user.expToNextLevel} XP',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 프로그래스 바
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: user.levelProgress,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 이름 편집 필드
  Widget _buildNameEditField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '이름을 입력하세요',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (value) {
                    if (_nameError.value.isNotEmpty) {
                      _nameError.value = '';
                    }
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
              onPressed: _saveName,
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              onPressed: () {
                _isEditingName.value = false;
                _nameError.value = '';
              },
            ),
          ],
        ),
        // 오류 메시지
        Obx(() => _nameError.value.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _nameError.value,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
              ),
            )
          : const SizedBox.shrink(),
        ),
      ],
    );
  }
  
  /// 뱃지 위젯
  Widget _buildBadge({
    required String icon,
    required int count,
    int? total,
    required Color color,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            total != null ? "$count/$total" : "$count",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 통계 카드 위젯
  Widget _buildStatisticsCard(user) {
    return GlassContainer(
      borderRadius: 16,
      child: Column(
        children: [
          _buildStatItem(
            icon: Icons.search,
            title: '발견한 해파리',
            value: '${user.discoveredJellyfishCount}/${_jellyfishController.jellyfishList.length}',
            color: Colors.blue,
          ),
          const Divider(color: Colors.white12),
          _buildStatItem(
            icon: Icons.quiz,
            title: '완료한 퀴즈',
            value: '${user.completedQuizIds.length}/20',
            color: Colors.amber,
          ),
          const Divider(color: Colors.white12),
          _buildStatItem(
            icon: Icons.emoji_events,
            title: '획득한 경험치',
            value: '${user.exp} XP',
            color: Colors.green,
          ),
        ],
      ),
    );
  }
  
  /// 통계 항목 위젯
  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 설정 카드 위젯
  Widget _buildSettingsCard() {
    return GlassContainer(
      borderRadius: 16,
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.notifications,
            title: '알림 설정',
            onTap: () {
              // 알림 설정 화면으로 이동
            },
          ),
          const Divider(color: Colors.white12),
          _buildSettingItem(
            icon: Icons.lock,
            title: '개인정보 처리방침',
            onTap: () {
              // 개인정보 처리방침 화면으로 이동
            },
          ),
          const Divider(color: Colors.white12),
          _buildSettingItem(
            icon: Icons.info,
            title: '앱 정보',
            onTap: () {
              // 앱 정보 화면으로 이동
            },
          ),
          const Divider(color: Colors.white12),
          _buildSettingItem(
            icon: Icons.logout,
            title: '로그아웃',
            onTap: () {
              _showLogoutConfirmDialog();
            },
            textColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
  
  /// 설정 항목 위젯
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor ?? Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: textColor ?? Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 이름 저장 함수
  void _saveName() async {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      _nameError.value = '이름을 입력해주세요';
      return;
    }
    
    if (name.length < 2) {
      _nameError.value = '이름은 최소 2자 이상이어야 합니다';
      return;
    }
    
    try {
      await _userController.updateUserName(name);
      _isEditingName.value = false;
      Get.snackbar(
        '성공',
        '이름이 변경되었습니다',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      _nameError.value = '이름 변경에 실패했습니다';
      print('이름 변경 오류: $e');
    }
  }
  
  /// 로그아웃 확인 다이얼로그
  void _showLogoutConfirmDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          borderRadius: 16,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '로그아웃 확인',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '정말 로그아웃 하시겠습니까?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed(AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('로그아웃'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 