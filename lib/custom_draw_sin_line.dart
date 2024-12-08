
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomDrawSinLine extends StatefulWidget {
  const CustomDrawSinLine({super.key});

  @override
  _CustomDrawSinLineState createState() => _CustomDrawSinLineState();
}

class _CustomDrawSinLineState extends State<CustomDrawSinLine> {
  final int limitCount = 48000*100;
  final List<double> sinPoints = [];
  late Timer timer;
  double xValue = 0;
  double xstep = 0.05; // Step size for the sine wave
  double step = 0.5;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 1000; i++) {
      sinPoints.add(math.sin(xValue) * 100);
      xValue += xstep;
    }
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeRange(0, 1000);
      }
      for (var i = 0; i < 1000; i++) {
        sinPoints.add(math.sin(xValue) * 100);
        xValue += xstep;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      setState(() {
        // Adjust the step based on the scroll delta
        step += notification.scrollDelta! * 0.001; // Adjust sensitivity as needed
        if (step < 0.02) step = 0.02; // Prevent step from becoming too small
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          // Adjust step based on scroll direction
          setState(() {
            print("step $step");
            step += event.scrollDelta.dy > 0 ? 0.01 : -0.01; // Zoom in/out
            if (step < 0.02) step = 0.02; // Prevent step from becoming too small
          });
        }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: CustomPaint(
          size: ui.Size(double.infinity, 200), // Set canvas size using ui.Size
          painter: SineWavePainter(sinPoints, step),
        ),
      ),
    );
  }
}

class SineWavePainter extends CustomPainter {
  final List<double> waveData;
  final double step;

  SineWavePainter(this.waveData, this.step);

  @override
  void paint(Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();

    // 计算可以绘制的最大点数
    int maxPoints = (size.width / step).floor();

    // 确保不超出 waveData 的长度
    maxPoints = maxPoints > waveData.length ? waveData.length : maxPoints;

    path.moveTo(0, waveData[0]);
    for (int i = 1; i < maxPoints; i += 1) {
      path.lineTo(i.toDouble() * step, waveData[i]);
    }
    
    canvas.drawPath(path, paint);
    
    // Offset oldpos = const Offset(0, 0);
    // for (int i = 1; i < waveData.length; i += 1) {
    //   Offset newpos = Offset(i.toDouble() * step, waveData[i]);
    //   canvas.drawLine(oldpos, newpos, paint);
    //   oldpos = newpos;
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}