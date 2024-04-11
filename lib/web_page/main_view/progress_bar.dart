import 'package:browser01/web_page/color/colors.dart';
import 'package:flutter/cupertino.dart';

class ProgressBarAnimate extends StatefulWidget {
  final double end;

  const ProgressBarAnimate({super.key, required this.end});

  @override
  State<StatefulWidget> createState() => ProgressBarState();
}

class ProgressBarState extends State<ProgressBarAnimate>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  double start = 0;
  var isFinish = false;
  var nextAnimation = false;
  var isShow = false;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation =
        Tween<double>(begin: start, end: widget.end).animate(controller);
    controller.addListener(animationEnd);
    super.initState();
    startAnimation();
  }

  void animationEnd() {
    if (animation.isCompleted) {
      start = animation.value;
      isFinish = true;
      if (start == 100) {
        start = 0;
        setState(() {
          isShow = false;
        });
      }
      if (nextAnimation && isShow) {
        startAnimation();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ProgressBarAnimate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.end != oldWidget.end && widget.end - oldWidget.end >= 20) {
      if (widget.end != 100 && isShow == false) {
        setState(() {
          isShow = true;
        });
      }
      if (isFinish) {
        startAnimation();
      } else {
        nextAnimation = true;
      }
    }
  }

  void startAnimation() {
    setState(() {
      controller.reset();
      animation =
          Tween<double>(begin: start, end: widget.end).animate(controller);
      if (start <= widget.end) controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isShow
        ? AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return SizedBox(
                height: 3,
                width: double.infinity,
                child: FractionallySizedBox(
                    widthFactor: animation.value.toDouble() / 100.0,
                    alignment: Alignment.centerLeft,
                    heightFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        ThemeColors.progressStartColor,
                        ThemeColors.progressEndColor
                      ])),
                    )),
              );
            })
        : Container();
  }
}
