import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';

class HoldFunc extends StatefulWidget {
  const HoldFunc({
    Key? key,
    required this.color,
    required this.lifespan,
    required this.onHold,
    required this.onRelease,
    required this.cancel,
    required this.width,
    required this.height,
  }) : super(key: key);

  final Color color;
  final Duration lifespan;
  final void Function() onHold;
  final void Function() onRelease;
  final void Function() cancel;
  final double width;
  final double height;

  @override
  State<HoldFunc> createState() => _HoldFuncState();
}

class _HoldFuncState extends State<HoldFunc> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.lifespan,
    );

    _colorAnimation = ColorTween(
      begin: Colors.blueGrey,
      end: widget.color,
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {}); // Redraw widget when animation is updated
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onRelease();
      }
    });

    widget.onHold();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HoldTimeoutDetector(
      onTimerInitiated: widget.onHold,
      onTimeout: widget.onRelease,
      onCancel: widget.cancel,
      holdTimeout: widget.lifespan,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: Colors.black,
                width: 3,),
            ),
          );
        },
      ),
    );
  }
}
