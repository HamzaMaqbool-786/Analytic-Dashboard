import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';

class PieChartCard extends StatefulWidget {
  const PieChartCard({super.key});

  @override
  State<PieChartCard> createState() => _PieChartCardState();
}

class _PieChartCardState extends State<PieChartCard>
    with SingleTickerProviderStateMixin {
  int _touchedIndex = -1;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<_Segment> _segments = [
    _Segment('Mobile', 42, AppColors.purple),
    _Segment('Desktop', 31, AppColors.teal),
    _Segment('Tablet', 17, AppColors.pink),
    _Segment('Other', 10, AppColors.yellow),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrDesktop =
    !Responsive.isMobile(context);
    final padding = Responsive.spacing(context, 20, tablet: 24);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TRAFFIC SOURCE',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                letterSpacing: 3,
                color: Colors.white38,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Text('Device breakdown',
              style: GoogleFonts.spaceGrotesk(
                fontSize: Responsive.fontSize(context, 16, tablet: 18),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
          SizedBox(height: Responsive.spacing(context, 20, tablet: 24)),
          isTabletOrDesktop
              ? _buildWideLayout()
              : _buildMobileLayout(),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPieChart(180),
        const SizedBox(width: 24),
        Expanded(child: _buildLegend()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Center(child: _buildPieChart(160)),
        const SizedBox(height: 20),
        _buildLegend(),
      ],
    );
  }

  Widget _buildPieChart(double size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => SizedBox(
        height: size,
        width: size,
        child: PieChart(
          PieChartData(
            sectionsSpace: 3,
            centerSpaceRadius: size * 0.26,
            startDegreeOffset: -90,
            pieTouchData: PieTouchData(
              touchCallback: (event, response) {
                setState(() {
                  _touchedIndex = response
                      ?.touchedSection?.touchedSectionIndex ??
                      -1;
                });
              },
            ),
            sections: _segments.asMap().entries.map((e) {
              final i = e.key;
              final seg = e.value;
              final isTouched = i == _touchedIndex;
              return PieChartSectionData(
                value: seg.value * _animation.value,
                color: seg.color,
                radius: isTouched ? size * 0.32 : size * 0.27,
                title: isTouched ? '${seg.value.toInt()}%' : '',
                titleStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
          swapAnimationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _segments.map((seg) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: seg.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(seg.label,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: Colors.white60,
                    )),
              ),
              Text('${seg.value.toInt()}%',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: seg.color,
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Segment {
  final String label;
  final double value;
  final Color color;
  _Segment(this.label, this.value, this.color);
}