import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';


class LineChartCard extends StatefulWidget {
  const LineChartCard({super.key});

  @override
  State<LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;
  List<FlSpot> _spots = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateData();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
        parent: _animController, curve: Curves.easeInOutCubic);
    _animController.forward();
  }

  void _generateData() {
    _spots = List.generate(
        8, (i) => FlSpot(i.toDouble(), 15 + _random.nextDouble() * 65));
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
          _buildHeader(),
          SizedBox(height: Responsive.spacing(context, 20, tablet: 24)),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) => SizedBox(
              height: chartHeight,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 20,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.white.withOpacity(0.05),
                      strokeWidth: 1,
                    ),
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
                          const weeks = [
                            'W1','W2','W3','W4','W5','W6','W7','W8'
                          ];
                          if (v.toInt() < weeks.length) {
                            return Text(weeks[v.toInt()],
                                style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10, color: Colors.white38));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _spots
                          .map((s) =>
                          FlSpot(s.x, s.y * _animation.value))
                          .toList(),
                      isCurved: true,
                      curveSmoothness: 0.4,
                      color: AppColors.teal,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) =>
                            FlDotCirclePainter(
                              radius: 3,
                              color: AppColors.teal,
                              strokeWidth: 2,
                              strokeColor: AppColors.surface,
                            ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.teal.withOpacity(0.2),
                            AppColors.teal.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REVENUE TREND',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  letterSpacing: 3,
                  color: Colors.white38,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 4),
            Text('Last 8 weeks',
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
              color: AppColors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.refresh_rounded,
                color: AppColors.teal, size: 18),
          ),
        ),
      ],
    );
  }
}