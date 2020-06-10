import 'dart:math';
import 'package:flutter/widgets.dart';

class SpinningProgressView extends StatefulWidget {
  final Color color;
  final BoxShape shape;
  final double size;

  const SpinningProgressView({
    Key key,
    @required this.color,
    this.shape = BoxShape.circle,
    @required this.size,
  }) : super(key: key);

  @override
  SpinningProgressViewState createState() =>
      new SpinningProgressViewState();
}

class SpinningProgressViewState extends State<SpinningProgressView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation1;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _animation1 = Tween(begin: 0.0, end: 7.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    )..addListener(() => setState(() => <String, void>{}));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Matrix4 transform = new Matrix4.identity()
      ..rotateY((0 - _animation1.value) * pi);
    return Center(
      child: new Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: new Container(
          child: Image.asset('assets/images/progress_icon_01.png'),
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(shape: widget.shape, color: widget.color),
        ),
      ),
    );
  }
}
