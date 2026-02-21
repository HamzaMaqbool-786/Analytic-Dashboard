import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../models/dashboard_models.dart';

class MetricGrid extends StatefulWidget {
  final List<DashboardCard> cards;
  final int columns;

  const MetricGrid({
    super.key,
    required this.cards,
    required this.columns,
  });

  @override
  State<MetricGrid> createState() => _MetricGridState();
}

class _MetricGridState extends State<MetricGrid> {
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    if (widget.columns == 1) {
      return Column(
        children: widget.cards
            .map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _MetricTile(
            card: c,
            expanded: _expandedId == c.id,
            onTap: () => setState(() {
              _expandedId = _expandedId == c.id ? null : c.id;
            }),
          ),
        ))
            .toList(),
      );
    }

    // Grid layout for 2 or 4 cols
    final rows = <Widget>[];
    for (int i = 0; i < widget.cards.length; i += widget.columns) {
      final rowCards = widget.cards.sublist(
        i,
        (i + widget.columns).clamp(0, widget.cards.length),
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: rowCards.asMap().entries.map((e) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: e.key > 0 ? 8 : 0,
                    right: e.key < rowCards.length - 1 ? 8 : 0,
                  ),
                  child: _MetricTile(
                    card: e.value,
                    expanded: _expandedId == e.value.id,
                    onTap: () => setState(() {
                      _expandedId =
                      _expandedId == e.value.id ? null : e.value.id;
                    }),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _MetricTile extends StatelessWidget {
  final DashboardCard card;
  final bool expanded;
  final VoidCallback onTap;

  const _MetricTile({
    required this.card,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(

        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: expanded
                ? card.accentColor.withOpacity(0.4)
                : card.accentColor.withOpacity(0.15),
            width: expanded ? 1.5 : 1,

          ),
          boxShadow: expanded
              ? [
            BoxShadow(
              color: card.accentColor.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 6),

            )
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: card.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(card.icon, color: card.accentColor, size: 18),
                ),
                const Spacer(),
                _TrendChip(
                  trend: card.trend,
                  isPositive: card.isPositive,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              card.value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card.title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: Colors.white54,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 10),
              Divider(color: Colors.white.withOpacity(0.08)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  _MiniStat('Weekly Avg', card.value, card.accentColor),
                  _MiniStat('Peak', '+24%', card.accentColor),
                  _MiniStat('Target', '95%', card.accentColor),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  final String trend;
  final bool isPositive;
  const _TrendChip({required this.trend, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.teal : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
  final String label;
  final String value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            )),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              color: Colors.white38,
            )),
      ],
    );
  }
}