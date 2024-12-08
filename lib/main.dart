import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wave/rotating_cube.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter_wave/custom_draw_sin_line.dart';
import 'package:flutter_wave/custom_draw_sin_line_vertices.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Counter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('模板'),
      ),
      body: Center(
        child: CustomDrawSinLine(),
      )
    );
  }
}

