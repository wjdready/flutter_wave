import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

import 'dart:math' as math;

class MyLineChart2 extends StatefulWidget {
  const MyLineChart2({super.key});

  @override
  State<MyLineChart2> createState() => _MyLineChart2State();
}

class _MyLineChart2State extends State<MyLineChart2> {
  final limitCount = 4000;
  late Timer timer;

  final sinPoints = <LineDataType>[];

  double xValue = 0;
  double step = 0.05;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < limitCount; i++) {
      sinPoints.add(LineDataType(xValue, math.sin(xValue) * 100));
      xValue += step;
    }

    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeRange(0, 1000);
      }

      for (var i = 0; i < 1000; i++) {
        sinPoints.add(LineDataType(xValue, math.sin(xValue) * 100));
        xValue += step;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("sinPoints ${sinPoints.length}");
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: 'Half yearly sales analysis'),
        // Enable legend
        legend: Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<LineDataType, double>>[
          LineSeries<LineDataType, double>(
              dataSource: sinPoints,
              xValueMapper: (LineDataType da, _) => da.x,
              yValueMapper: (LineDataType da, _) => da.y,
              name: 'Sales',
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: true))
        ]);
  }
}

class LineDataType {
  LineDataType(this.x, this.y);
  final double y;
  final double x;
}
