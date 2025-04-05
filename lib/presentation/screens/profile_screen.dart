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
  final JellyfishController _jellyfishController =
      Get.find<JellyfishController>();

  // 이름 편집 관련
  final TextEditingController _nameController = TextEditingController();
  final RxBool _isEditingName = false.obs;
  final RxString _nameError = ''.obs;

  @override
  void initState() {
    super.initState();
    _nameController.text = _userController.user.name;

    // 화면 로드 시 컨트롤러 데이터 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  /// 데이터 새로고침
  Future<void> _refreshData() async {
    try {
      // 해파리 모델 로드
      _jellyfishController.update();

      // 상태 업데이트
      setState(() {});
    } catch (e) {
      print('데이터 로드 중 오류: $e');
      setState(() {});
    }
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
            colors: [AppTheme.azureStart, AppTheme.azureEnd],
          ),
        ),
        child: SafeArea(
          child: GetBuilder<UserController>(
            builder: (_) {
              if (_userController.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final user = _userController.user;

              return Column(
                children: [
                  // 상단 앱바
                  _buildAppBar(),

                  // 내용
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // 페이지 새로고침 시 강제로 컨트롤러 업데이트
                        _refreshData();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                              _buildStatisticsCard(),
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
                  ),
                ],
              );
            },
          ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black54,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
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
          // 상단 부분: 레벨 뱃지와 유저 정보
          Row(
            children: [
              // 레벨 뱃지
              Stack(
                alignment: Alignment.center,
                children: [
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
                        ),
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
                      ],
                    ),
                  ),

                  // 레벨업 효과 (선택적 애니메이션)
                  if (user.level > 1)
                    Positioned(
                      right: -5,
                      top: -5,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),

              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름 편집 모드
                    Obx(
                      () =>
                          _isEditingName.value
                              ? _buildNameEditField()
                              : Row(
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.black38,
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
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

                    // 사용자 칭호
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.cyanAccent, Colors.blue],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            user.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          user.createdAt != null
                              ? "가입일: ${_formatDate(user.createdAt)}"
                              : "",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black38,
                                offset: Offset(0.5, 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 뱃지 컨테이너
                    _buildBadgesRow(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 경험치 바
          _buildExpBar(user),
        ],
      ),
    );
  }

  /// 경험치 바 위젯
  Widget _buildExpBar(user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '다음 레벨까지',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black38,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '${user.exp % user.expToNextLevel}/${user.expToNextLevel} XP',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black38,
                      offset: Offset(0.5, 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 프로그래스 바
          Stack(
            children: [
              // 배경
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // 진행바
              FractionallySizedBox(
                widthFactor: user.levelProgress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                ),
              ),

              // 경험치 퍼센트 표시
              Positioned.fill(
                child: Center(
                  child: Text(
                    '${(user.levelProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black54,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 뱃지 행 위젯
  Widget _buildBadgesRow() {
    return Container(
      height: 90,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _userController.getQuizCompletionSummary(),
        builder: (context, snapshot) {
          // 데이터 로딩 중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          // 오류 처리
          if (!snapshot.hasData) {
            return const Text(
              '뱃지 데이터를 불러올 수 없습니다',
              style: TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black38,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
            );
          }

          // 퀴즈 완료 수 가져오기
          final quizCount = snapshot.data!['total'];

          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildBadge(
                title: '해파리 발견',
                count: _jellyfishController.discoveredJellyfishList.length,
                total: _jellyfishController.jellyfishList.length,
                color: Colors.blue,
                icon: Icons.search,
              ),
              const SizedBox(width: 15),
              _buildBadge(
                title: '퀴즈 완료',
                count: quizCount,
                total: 20, // 전체 퀴즈 수 (더미)
                color: Colors.green,
                icon: Icons.quiz,
              ),
              const SizedBox(width: 15),
              _buildBadge(
                title: '신고 횟수',
                count: _userController.user.reportedJellyfishCount,
                total: 10, // 신고 목표치 (더미)
                color: Colors.red,
                icon: Icons.report_problem,
              ),
            ],
          );
        },
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
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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
              icon: const Icon(Icons.check, color: Colors.greenAccent),
              onPressed: _saveName,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.redAccent),
              onPressed: () {
                _isEditingName.value = false;
                _nameError.value = '';
              },
            ),
          ],
        ),
        // 오류 메시지
        Obx(
          () =>
              _nameError.value.isNotEmpty
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
    required String title,
    required int count,
    int? total,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            total != null ? "$count/$total" : "$count",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }

  /// 통계 카드 위젯
  Widget _buildStatisticsCard() {
    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '활동 통계',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black38,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 퀴즈 완료 통계 - 개선된 방식
          FutureBuilder<Map<String, dynamic>>(
            future: _userController.getQuizCompletionSummary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Text(
                  '데이터를 불러올 수 없습니다',
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black38,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                );
              }

              final total = snapshot.data!['total'];
              final dailyCount = snapshot.data!['daily'];
              final emergencyCount = snapshot.data!['emergency'];

              return Column(
                children: [
                  _buildStatItem(
                    icon: Icons.quiz,
                    title: '완료한 퀴즈',
                    value: '$total개',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  _buildStatItem(
                    icon: Icons.calendar_today,
                    title: '일일 퀴즈',
                    value: '$dailyCount개',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _buildStatItem(
                    icon: Icons.warning_amber_rounded,
                    title: '돌발 퀴즈',
                    value: '$emergencyCount개',
                    color: Colors.amber,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 10),

          // 발견 및 신고 통계
          _buildStatItem(
            icon: Icons.visibility,
            title: '발견한 해파리',
            value: '${_jellyfishController.discoveredJellyfishList.length}종',
            color: Colors.purple,
          ),
          const SizedBox(height: 10),
          _buildStatItem(
            icon: Icons.report_problem,
            title: '신고한 해파리',
            value: '${_userController.user.reportedJellyfishCount}회',
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  /// 통계 항목 위젯 (글래스모피즘 스타일)
  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black38,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: Colors.black26,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 1.0,
                  color: Colors.black26,
                  offset: Offset(0.5, 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 날짜 포맷 함수
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return '오늘';
    } else if (difference == 1) {
      return '어제';
    } else {
      return '${date.year}/${date.month}/${date.day}';
    }
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
          Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
          _buildSettingItem(
            icon: Icons.lock,
            title: '개인정보 처리방침',
            onTap: () {
              // 개인정보 처리방침 화면으로 이동
            },
          ),
          Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
          _buildSettingItem(
            icon: Icons.info,
            title: '앱 정보',
            onTap: () {
              // 앱 정보 화면으로 이동
            },
          ),
          Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
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
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (textColor ?? Colors.white).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: textColor ?? Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black26,
                      offset: Offset(0.5, 0.5),
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: (textColor ?? Colors.white).withOpacity(0.8),
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
      await _userController.updateUsername(name);
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
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.white70),
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
