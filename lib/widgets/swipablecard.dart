import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';
import '../models/dashboard_models.dart';

class SwipeableCardStack extends StatefulWidget {
  final List<DashboardCard> cards;
  const SwipeableCardStack({super.key, required this.cards});

  @override
  State<SwipeableCardStack> createState() => _SwipeableCardStackState();
}

class _SwipeableCardStackState extends State<SwipeableCardStack> {
  late PageController _pageController;
  int _currentIndex = 0;
  String? _expandedId;
  String? _showContent;

  static const double _collapsedHeight = 200;
  static const double _expandedHeight = 340;
  static const Duration _animDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleExpand(String id) {
    if (_expandedId == id) {
      setState(() => _showContent = null);
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted) setState(() => _expandedId = null);
      });
    } else {
      setState(() {
        _expandedId = id;
        _showContent = null;
      });
      Future.delayed(_animDuration, () {
        if (mounted) setState(() => _showContent = id);
      });
    }
  }

  double _safePage(int index) {
    try {
      if (_pageController.hasClients &&
          _pageController.position.haveDimensions) {
        return _pageController.page ?? index.toDouble();
      }
    } catch (_) {}
    return index.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final bool anyExpanded = _expandedId != null;

    return Column(
      children: [
        AnimatedContainer(
          duration: _animDuration,
          curve: Curves.easeInOutCubic,
          height: anyExpanded
              ? _expandedHeight + 16
              : _collapsedHeight + 16,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() {
              _currentIndex = i;
              _expandedId = null;
              _showContent = null;
            }),
            itemCount: widget.cards.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final card = widget.cards[index];
              final isExpanded = _expandedId == card.id;
              final showContent = _showContent == card.id;
              final isCurrent = _currentIndex == index;

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  final page = _safePage(index);
                  final diff = (index - page).abs();
                  final scale = (1.0 - diff * 0.06).clamp(0.85, 1.0);
                  final opacity = (1.0 - diff * 0.35).clamp(0.4, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: GestureDetector(
                  onTap: () => _toggleExpand(card.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8),
                    child: AnimatedContainer(
                      duration: _animDuration,
                      curve: Curves.easeInOutCubic,
                      height: isExpanded
                          ? _expandedHeight
                          : _collapsedHeight,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isCurrent
                              ? card.accentColor.withOpacity(0.45)
                              : Colors.white.withOpacity(0.06),
                          width: isCurrent ? 1.5 : 1,
                        ),
                        boxShadow: isCurrent
                            ? [
                          BoxShadow(
                            color: card.accentColor.withOpacity(0.18),
                            blurRadius: 32,
                            offset: const Offset(0, 10),
                          )
                        ]
                            : [],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: card.accentColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    card.icon,
                                    color: card.accentColor,
                                    size: 20,
                                  ),
                                ),
                                const Spacer(),
                                _TrendBadge(
                                  trend: card.trend,
                                  isPositive: card.isPositive,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Text(
                              card.subtitle.toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 10,
                                letterSpacing: 2,
                                color: Colors.white38,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              card.value,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: Responsive.fontSize(
                                  context,
                                  26,
                                  tablet: 30,
                                  desktop: 34,
                                ),
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              card.title,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),

                            if (showContent) ...[
                              const SizedBox(height: 14),
                              Divider(
                                color: Colors.white.withOpacity(0.08),
                              ),
                              const SizedBox(height: 12),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final statWidth =
                                      constraints.maxWidth / 3;
                                  return AnimatedOpacity(
                                    opacity: 1.0,
                                    duration:
                                    const Duration(milliseconds: 200),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: statWidth,
                                          child: _MiniStat(
                                            'Avg',
                                            card.value,
                                            card.accentColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: statWidth,
                                          child: _MiniStat(
                                            'Peak',
                                            '+24%',
                                            card.accentColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: statWidth,
                                          child: _MiniStat(
                                            'Target',
                                            '95%',
                                            card.accentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 14),

                              AnimatedOpacity(
                                opacity: 1.0,
                                duration:
                                const Duration(milliseconds: 200),
                                child: Column(
                                  children: [
                                    _DetailRow(
                                      label: 'Last Updated',
                                      value: 'Today, 9:41 AM',
                                      color: card.accentColor,
                                    ),
                                    const SizedBox(height: 6),
                                    _DetailRow(
                                      label: 'Period',
                                      value: 'This month',
                                      color: card.accentColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const Spacer(),

                            Row(
                              children: [
                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0.0,
                                  duration:
                                  const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color:
                                    card.accentColor.withOpacity(0.6),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isExpanded
                                      ? 'Tap to collapse'
                                      : 'Tap for details',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    color:
                                    card.accentColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.cards.length, (i) {
        final active = i == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active
                ? widget.cards[_currentIndex].accentColor
                : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final String trend;
  final bool isPositive;
  const _TrendBadge({required this.trend, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.teal : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            trend,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    // ✅ Column centered inside its fixed SizedBox width
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          // ✅ overflow ellipsis prevents text from pushing width
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _DetailRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ✅ Expanded on label so it never pushes value off screen
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              color: Colors.white38,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}