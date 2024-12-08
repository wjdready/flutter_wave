import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math' as math;

// fl_chart
class FlChartSinLine extends StatefulWidget {
  const FlChartSinLine({super.key});

  @override
  State<FlChartSinLine> createState() => _FlChartSinLineState();
}

class _FlChartSinLineState extends State<FlChartSinLine> {

  final limitCount = 1000;

  List<LineChartBarData> data = [];
  final sinPoints = <FlSpot>[];
  late Timer timer;

  double xValue = 0;
  double step = 0.05;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 100; i++) {
      sinPoints.add(FlSpot(xValue, math.sin(xValue) * 0.5));
      xValue += step;
    }

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {

      while (sinPoints.length > limitCount) {
        sinPoints.removeRange(0, 100);
      }

      for (var i = 0; i < 100; i++) {
        sinPoints.add(FlSpot(xValue, math.sin(xValue) * 0.5));
        xValue += step;
      }

      setState(() {
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    return LineChart(
      LineChartData(

        // titlesData: const FlTitlesData(show: false),

        // borderData: FlBorderData(show: false),

        // gridData: const FlGridData(
        //   show: true,
        //   drawVerticalLine: false,
        // ),
        
        // clipData: const FlClipData.all(),

        minY: -1,
        maxY: 1,
        minX: sinPoints.first.x,
        maxX: sinPoints.last.x,

        // 鼠标或触摸曲线时显示数据信息
        lineTouchData: const LineTouchData(enabled: false),

        lineBarsData: [
          LineChartBarData(
            spots: sinPoints,
            dotData: const FlDotData(
              show: false,
            ),
            barWidth: 0.9,
            color: Colors.green,
            isCurved: false,
          )
        ]
      )
    );
  }
}
