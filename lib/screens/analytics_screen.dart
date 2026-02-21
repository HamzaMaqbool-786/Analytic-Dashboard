import 'package:flutter/material.dart';
import 'package:flutter_navigation/widgets/bar_chart.dart';
import 'package:flutter_navigation/widgets/pie_chart.dart';


class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        children: const [
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChartCard(),
          ),
          SizedBox(height: 30),
          AspectRatio(
            aspectRatio: 1.3,
            child: BarChartCard(),
          ),
        ],
      ),
    );
  }
}