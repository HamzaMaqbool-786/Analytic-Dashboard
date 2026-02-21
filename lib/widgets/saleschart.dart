import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  final List<double> data;

  const SalesChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: data
                .asMap()
                .entries
                .map((e) =>
                FlSpot(e.key.toDouble(), e.value))
                .toList(),
          )
        ],
      ),
      duration: const Duration(milliseconds: 800),
    );
  }
}