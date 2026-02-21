import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';


class BarChartCard extends StatefulWidget {
  const BarChartCard({super.key});

  @override
  State<BarChartCard> createState() => _BarChartCardState();
}

class _BarChartCardState extends State<BarChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;
  List<double> _data = [];
  final Random _random = Random();
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _generateData();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
        parent: _animController, curve: Curves.elasticOut);
    _animController.forward();
  }

  void _generateData() {
    _data = List.generate(6, (_) => 20 + _random.nextDouble() * 70);
  }

  void _refresh() {
    setState(() => _generateData());
    _animController.forward(from: 0);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartHeight = Responsive.chartHeight(context);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, 20, tablet: 24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('USER ACQUISITION',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        letterSpacing: 3,
                        color: Colors.white38,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 4),
                  Text('Monthly growth',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: Responsive.fontSize(context, 16, tablet: 18),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: _refresh,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.refresh_rounded,
                      color: AppColors.pink, size: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 20, tablet: 24)),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) => SizedBox(
              height: chartHeight,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        _touchedIndex =
                            response?.spot?.touchedBarGroupIndex ?? -1;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          if (v.toInt() < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(months[v.toInt()],
                                  style: GoogleFonts.spaceGrotesk(
                                      fontSize: 10,
                                      color: Colors.white38)),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.white.withOpacity(0.05),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _data.asMap().entries.map((e) {
                    final isTouched = e.key == _touchedIndex;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value * _animation.value,
                          color: isTouched
                              ? AppColors.pink
                              : AppColors.pink.withOpacity(0.65),
                          width: 18,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
        swapAnimationDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}