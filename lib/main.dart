import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';

void main() => runApp(MyTimer());

class MyTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Timer',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Nunito',
            letterSpacing: 1.0,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  double percentage; //value of the circular progress
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;

  @override
  void initState() {
    super.initState();
    setState(() {
      percentage = 0.0; //initialize the value
    });

    percentageAnimationController = AnimationController(vsync: this,
      duration: new Duration(milliseconds: 1000)
    )
    ..addListener((){
      setState(() {
        percentage = lerpDouble(percentage, newPercentage, percentageAnimationController.value);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        child: new CustomPaint(
          foregroundPainter: new MyPainter(
              lineColor: Colors.amberAccent,
              completeColor: Colors.blueAccent,
              completePercent: percentage,
              width: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: RaisedButton(
              elevation: 2,
                color: Colors.red[600],
                splashColor: Colors.blueAccent,
                shape: new CircleBorder(),
                child: Text(
                  'Click',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                onPressed: () {
                  setState(() {
                    percentage += 15.0;
                    if (percentage > 100) {
                      percentage = 0.0;
                    }
                  });
                  percentageAnimationController.forward(from:0.0);
                }),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    //Start drawing in the canvas
    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
