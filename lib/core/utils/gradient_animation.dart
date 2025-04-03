import 'package:flutter/material.dart';

/// 그라데이션 애니메이션을 적용한 컨테이너
class AnimatedGradientContainer extends StatefulWidget {
  /// 그라데이션 색상 목록
  final List<Color> colors;
  
  /// 애니메이션 지속 시간
  final Duration duration;
  
  /// 자식 위젯
  final Widget child;
  
  /// 시작 정렬
  final Alignment begin;
  
  /// 끝 정렬
  final Alignment end;
  
  const AnimatedGradientContainer({
    Key? key,
    required this.colors,
    this.duration = const Duration(seconds: 3),
    required this.child,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  }) : super(key: key);

  @override
  State<AnimatedGradientContainer> createState() => _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Color> _colors;
  late List<Color> _nextColors;

  @override
  void initState() {
    super.initState();
    
    _colors = List.from(widget.colors);
    _nextColors = List.from(widget.colors);
    _nextColors.add(_nextColors.removeAt(0));
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    
    _controller.addListener(() {
      if (_controller.value >= 0.99) {
        setState(() {
          _colors = List.from(_nextColors);
          _nextColors.add(_nextColors.removeAt(0));
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: _getAnimatedColors(_controller.value),
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  List<Color> _getAnimatedColors(double value) {
    return List.generate(
      _colors.length,
      (index) => Color.lerp(
        _colors[index],
        _nextColors[index],
        value,
      )!,
    );
  }
}

/// 펄스 애니메이션 효과를 주는 위젯
class PulseAnimation extends StatefulWidget {
  /// 최소 스케일
  final double minScale;
  
  /// 최대 스케일
  final double maxScale;
  
  /// 자식 위젯
  final Widget child;
  
  /// 애니메이션 지속 시간
  final Duration duration;
  
  const PulseAnimation({
    Key? key,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// 밝은 효과가 흐르는 그라데이션 버튼
class ShimmerGradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final List<Color> colors;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  
  const ShimmerGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.colors,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  });

  @override
  State<ShimmerGradientButton> createState() => _ShimmerGradientButtonState();
}

class _ShimmerGradientButtonState extends State<ShimmerGradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.colors.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(child: widget.child),
                // 흐르는 빛 효과
                Positioned(
                  left: -100 + (_controller.value * 300),
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 