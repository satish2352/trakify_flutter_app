import 'package:flutter/material.dart';
import 'package:trakify/ui_components/text.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({super.key, required this.child, required this.delay, required this.direction});
  final Widget child;
  final double delay;
  final String direction;
  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> animation2;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: (500 * widget.delay).round()), vsync: this);
    animation2 = Tween<double>(begin: _initialOffset(), end: 0).animate(controller)..addListener(() {setState(() {});});
    animation = Tween<double>(begin: 0, end: 1).animate(controller)..addListener(() {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Transform.translate(
      offset: Offset(_horizontalOffset(), _verticalOffset()),
      child: Opacity(
        opacity: animation.value,
        child: widget.child,
      ),
    );
  }

  double _initialOffset() {
    switch (widget.direction) {
      case 'up':return 40;
      case 'down':return -40;
      case 'right':return -40;
      case 'left':return 40;
      default:return 0;
    }
  }

  double _verticalOffset() {
    if (widget.direction == 'up' || widget.direction == 'down') { return animation2.value; }
    return 0;
  }

  double _horizontalOffset() {
    if (widget.direction == 'left' || widget.direction == 'right') { return animation2.value; }
    return 0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AppearAnimation extends StatefulWidget {

  final Widget child;
  final int? delay;
  const AppearAnimation({super.key, required this.child, this.delay});

  @override
  State<AppearAnimation> createState() => _AppearAnimationState();
}

class _AppearAnimationState extends State<AppearAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    int delayDuration = widget.delay ?? 800;
    controller = AnimationController(duration: Duration(milliseconds: (delayDuration)), vsync: this);

    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class InfiniteAnimation extends StatefulWidget {
  final Widget connectedWidget;
  final Widget disconnectedWidget;
  final String textToShow;

  const InfiniteAnimation({
    super.key,
    required this.connectedWidget,
    required this.disconnectedWidget,
    required this.textToShow,
  });

  @override
  InfiniteAnimationState createState() => InfiniteAnimationState();
}

class InfiniteAnimationState extends State<InfiniteAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        setState(() {
          _isConnected = !_isConnected;
        });
        _controller.reverse();
      } else if (_controller.status == AnimationStatus.dismissed) {
        setState(() {
          _isConnected = !_isConnected;
        });
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MySubHeadingText(text: widget.textToShow,),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isConnected
              ? widget.connectedWidget
              : widget.disconnectedWidget,
        ),
      ],
    );
  }
}