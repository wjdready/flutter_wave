import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RotatingCube extends StatefulWidget {
  @override
  _RotatingCubeState createState() => _RotatingCubeState();
}

class _RotatingCubeState extends State<RotatingCube> {
  late Timer timer;
  double rotationX = 0.0; // Rotation angle around X axis
  double rotationY = 0.0; // Rotation angle around Y axis

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        rotationX += 0.02; // Increment rotation around X
        rotationY += 0.03; // Increment rotation around Y
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: ui.Size(double.infinity, 400),
      painter: CubePainter(rotationX, rotationY),
    );
  }
}

class CubePainter extends CustomPainter {
  final double rotationX;
  final double rotationY;

  CubePainter(this.rotationX, this.rotationY);

  @override
  void paint(Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Define the vertices of the cube in 3D space
    List<ui.Offset> vertices = [];
    List<List<double>> cubeVertices = [
      [-1, -1, -1],
      [1, -1, -1],
      [1, 1, -1],
      [-1, 1, -1],
      [-1, -1, 1],
      [1, -1, 1],
      [1, 1, 1],
      [-1, 1, 1],
    ];

    // Apply rotation and projection
    for (var vertex in cubeVertices) {
      double x = vertex[0];
      double y = vertex[1];
      double z = vertex[2];

      // Rotate around X
      double rotatedY = y * math.cos(rotationX) - z * math.sin(rotationX);
      double rotatedZ = y * math.sin(rotationX) + z * math.cos(rotationX);
      y = rotatedY;
      z = rotatedZ;

      // Rotate around Y
      double rotatedX = x * math.cos(rotationY) + z * math.sin(rotationY);
      rotatedZ = -x * math.sin(rotationY) + z * math.cos(rotationY);
      x = rotatedX;
      z = rotatedZ;

      // Project to 2D
      double scale = 100; // Scale factor for the projection
      double projectedX = x * scale + size.width / 2;
      double projectedY = -y * scale + size.height / 2; // Invert Y for canvas

      vertices.add(Offset(projectedX, projectedY));
    }

    // Draw the edges of the cube
    drawCubeEdges(canvas, paint, vertices);
  }

  void drawCubeEdges(Canvas canvas, Paint paint, List<ui.Offset> vertices) {
    // Define the edges of the cube (pairs of vertex indices)
    List<List<int>> edges = [
      [0, 1], [1, 2], [2, 3], [3, 0], // Back face
      [4, 5], [5, 6], [6, 7], [7, 4], // Front face
      [0, 4], [1, 5], [2, 6], [3, 7], // Connecting edges
    ];

    // Draw the edges
    for (var edge in edges) {
      canvas.drawLine(vertices[edge[0]], vertices[edge[1]], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
