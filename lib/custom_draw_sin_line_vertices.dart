import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomDrawSinLineVertices extends StatefulWidget {
  const CustomDrawSinLineVertices({super.key});

  @override
  _CustomDrawSinLineVerticesState createState() => _CustomDrawSinLineVerticesState();
}

class _CustomDrawSinLineVerticesState extends State<CustomDrawSinLineVertices> {
  final int limitCount = 48000*2;
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
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
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

    // Create a list of vertices
    List<ui.Offset> vertices = [];
    for (int i = 0; i < waveData.length; i++) {
      vertices.add(Offset(i.toDouble() * step, size.height / 2 - waveData[i]));
    }

    // Draw vertices to create the sine wave
    canvas.drawVertices(
      Vertices(VertexMode.triangleFan, vertices),
      BlendMode.srcOver,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}