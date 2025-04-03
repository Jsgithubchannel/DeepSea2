import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:jellyfish_test/core/theme/app_theme.dart';
import 'package:jellyfish_test/core/utils/gradient_animation.dart';

/// 커스텀 네비게이션 바 위젯
class JellyfishNavigationBar extends StatelessWidget {
  /// 현재 선택된 인덱스
  final int selectedIndex;
  
  /// 탭 변경 콜백
  final Function(int) onTabChanged;
  
  /// 감식 버튼 탭 콜백
  final VoidCallback onIdentifyTap;
  
  const JellyfishNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.onIdentifyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // 메인 네비게이션 바
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -5),
              ),
            ],
            // 유리 효과
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 홈 버튼
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: '홈',
                    index: 0,
                  ),
                  // 도감 버튼
                  _buildNavItem(
                    icon: Icons.collections_bookmark_rounded,
                    label: '도감',
                    index: 1,
                  ),
                  // 중앙 카메라 버튼을 위한 공간
                  const SizedBox(width: 60),
                  // 퀴즈 버튼
                  _buildNavItem(
                    icon: Icons.quiz_rounded,
                    label: '퀴즈',
                    index: 2,
                  ),
                  // 프로필 버튼
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: '프로필',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // 중앙 카메라 버튼
        Positioned(
          top: -26,
          child: _buildCameraButton(),
        ),
      ],
    );
  }
  
  /// 네비게이션 아이템 위젯 생성
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    
    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.white.withOpacity(0.7),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 중앙 카메라 버튼 위젯 생성
  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: onIdentifyTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.cyan],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 반짝이는 효과
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 28,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 