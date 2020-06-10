import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math show sin, pi;

class SpinFadingCircle extends StatefulWidget {
  final Color color;
  final double size;

  const SpinFadingCircle({
    Key key,
    @required this.color,
    this.size = 50.0,
  }) : super(key: key);

  @override
  _SpinKitFadingCircleState createState() => new _SpinKitFadingCircleState();
}

class _SpinKitFadingCircleState extends State<SpinFadingCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Opacity(
          opacity: 0.7,
          child: const ModalBarrier(dismissible: false, color: Colors.black87),
        ),
    Center(
    child: SizedBox.fromSize(
    size: Size.square(widget.size),
    child: Stack(
    children: [
    _circle(1, .0),
    _circle(2, -1.1),
    _circle(3, -1.0),
    _circle(4, -0.9),
    _circle(5, -0.8),
    _circle(6, -0.7),
    _circle(7, -0.6),
    _circle(8, -0.5),
    _circle(9, -0.4),
    _circle(10, -0.3),
    _circle(11, -0.2),
    _circle(12, -0.1),
    ],
    ),
    ),
    )
      ],
    );
  }

  Widget _circle(int i, [double delay]) {
    final _size = widget.size * 0.15, _position = widget.size * .5;

    return Positioned.fill(
      left: _position,
      top: _position,
      child: Transform(
        transform: Matrix4.rotationZ(30.0 * (i - 1) * 0.0174533),
        child: Align(
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: new DelayTween(begin: 0.0, end: 1.0, delay: delay)
                .animate(_controller),
            child: Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class AngleDelayTween extends Tween<double> {
  final double delay;

  AngleDelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) => super.lerp(math.sin((t - delay) * math.pi * 0.5));

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
