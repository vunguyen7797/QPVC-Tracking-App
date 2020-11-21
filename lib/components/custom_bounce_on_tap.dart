import 'package:flutter/material.dart';

class CustomBounceAnimation extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final bool initialState;
  final Function onLongPress;
  const CustomBounceAnimation(
      {Key key,
      @required this.child,
      this.onLongPress,
      @required this.onTap,
      this.initialState})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CustomBounceAnimationState();
}

class _CustomBounceAnimationState extends State<CustomBounceAnimation>
    with TickerProviderStateMixin<CustomBounceAnimation> {
  AnimationController controller;
  Animation<double> easeInAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 200,
        ),
        value: 5.0);
    easeInAnimation = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ),
    );
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          controller.forward().then((val) {});
        });
      },
      onTapCancel: () {
        controller.reverse().then((val) {});
      },
      onTap: () {
        if (widget.onTap == null) {
          return;
        }
        widget.onTap();
        controller.reverse().then((val) {});
      },
      onLongPress: () {
        if (widget.onLongPress != null) {
          widget.onLongPress();
          controller.reverse().then((val) {});
        }
      },
      child: widget.initialState == true
          ? widget.child
          : ScaleTransition(
              scale: easeInAnimation,
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
