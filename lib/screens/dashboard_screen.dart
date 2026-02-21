import 'package:flutter/material.dart';
import 'package:flutter_navigation/screens/side_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';
import '../models/dashboard_models.dart';

import '../widgets/bar_chart.dart';
import '../widgets/line_chart.dart';
import '../widgets/metric_grid.dart';
import '../widgets/pie_chart.dart';
import '../widgets/swipablecard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  int _selectedNavIndex = 0;
  final List<String> _cardOrder = ['line', 'bar', 'pie'];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  void _reorderCards(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _cardOrder.removeAt(oldIndex);
      _cardOrder.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (isDesktop) {
      return _buildDesktopLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  // ─── MOBILE LAYOUT ────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildMobileHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _sectionLabel('SWIPE METRICS'),
                    const SizedBox(height: 12),
                    SwipeableCardStack(cards: defaultCards),
                    const SizedBox(height: 32),
                    _sectionLabel('DRAG TO REORDER'),
                    const SizedBox(height: 12),
                    _buildReorderableList(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── TABLET LAYOUT ────────────────────────────────────────────────────────
  Widget _buildTabletLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabletHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    _sectionLabel('METRICS'),
                    const SizedBox(height: 16),
                    MetricGrid(cards: defaultCards, columns: 2),
                    const SizedBox(height: 32),
                    _sectionLabel('DRAG TO REORDER CHARTS'),
                    const SizedBox(height: 16),
                    _buildReorderableList(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── DESKTOP LAYOUT ───────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideNav(
            selectedIndex: _selectedNavIndex,
            onTap: (i) => setState(() => _selectedNavIndex = i),
          ),
          Expanded(
            child: Column(
              children: [
                _buildDesktopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(40, 32, 40, 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('KEY METRICS'),
                          const SizedBox(height: 16),
                          MetricGrid(cards: defaultCards, columns: 4),
                          const SizedBox(height: 40),
                          _sectionLabel('CHARTS — DRAG TO REORDER'),
                          const SizedBox(height: 16),
                          _buildDesktopChartGrid(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADERS ──────────────────────────────────────────────────────────────
  Widget _buildMobileHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            bottom: BorderSide(color: AppColors.teal.withOpacity(0.15)),
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PULSE',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      color: AppColors.teal,
                    )),
                Text('Dashboard',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    )),
              ],
            ),
            const Spacer(),
            _iconBtn(Icons.notifications_outlined),
            const SizedBox(width: 8),
            _avatar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            bottom: BorderSide(color: AppColors.teal.withOpacity(0.15)),
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PULSE',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      color: AppColors.teal,
                    )),
                Text('Dashboard',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    )),
              ],
            ),
            const Spacer(),
            _iconBtn(Icons.search_rounded),
            const SizedBox(width: 8),
            _iconBtn(Icons.notifications_outlined),
            const SizedBox(width: 8),
            _iconBtn(Icons.tune_rounded),
            const SizedBox(width: 12),
            _avatar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            bottom: BorderSide(color: AppColors.teal.withOpacity(0.1)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search_rounded,
                        color: Colors.white38, size: 18),
                    const SizedBox(width: 8),
                    Text('Search anything...',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: Colors.white38,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            _iconBtn(Icons.notifications_outlined),
            const SizedBox(width: 8),
            _iconBtn(Icons.tune_rounded),
            const SizedBox(width: 16),
            _avatar(),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin User',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
                Text('admin@pulse.io',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      color: Colors.white38,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── DESKTOP CHART GRID (2 col) ───────────────────────────────────────────
  Widget _buildDesktopChartGrid() {
    final charts = _cardOrder.map((type) {
      switch (type) {
        case 'bar':
          return const BarChartCard();
        case 'pie':
          return const PieChartCard();
        default:
          return const LineChartCard();
      }
    }).toList();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: charts[0]),
            const SizedBox(width: 20),
            Expanded(child: charts.length > 1 ? charts[1] : const SizedBox()),
          ],
        ),
        if (charts.length > 2) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: charts[2]),
              const SizedBox(width: 20),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }

  // ─── REORDERABLE LIST (mobile + tablet) ───────────────────────────────────
  Widget _buildReorderableList() {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: _reorderCards,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (ctx, child) => Transform.scale(
            scale: 1.03,
            child: Material(
              color: Colors.transparent,
              elevation: 20,
              shadowColor: AppColors.teal.withOpacity(0.3),
              child: child,
            ),
          ),
          child: child,
        );
      },
      children: _cardOrder.asMap().entries.map((entry) {
        final type = entry.value;
        Widget card;
        switch (type) {
          case 'bar':
            card = const BarChartCard();
            break;
          case 'pie':
            card = const PieChartCard();
            break;
          default:
            card = const LineChartCard();
        }
        return Padding(
          key: ValueKey(type),
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(child: card),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: const Icon(Icons.drag_indicator_rounded,
                    color: Colors.white24, size: 20),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── BOTTOM NAV (mobile + tablet) ─────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      (Icons.grid_view_rounded, 'Overview'),
      (Icons.bar_chart_rounded, 'Analytics'),
      (Icons.people_outline_rounded, 'Users'),
      (Icons.settings_outlined, 'Settings'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBg,
        border: Border(
            top: BorderSide(color: AppColors.teal.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final selected = _selectedNavIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedNavIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.teal.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.$1,
                          color:
                          selected ? AppColors.teal : Colors.white38,
                          size: 22),
                      const SizedBox(height: 4),
                      Text(item.$2,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? AppColors.teal
                                : Colors.white38,
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── SHARED HELPERS ───────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Text(label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
          color: Colors.white38,
        ));
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Icon(icon, color: Colors.white60, size: 20),
    );
  }

  Widget _avatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.teal, AppColors.purple]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }
}