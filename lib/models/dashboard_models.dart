import 'package:flutter/material.dart';

class DashboardCard {
  final String id;
  final String title;
  final String subtitle;
  final String value;
  final String trend;
  final bool isPositive;
  final Color accentColor;
  final IconData icon;

  const DashboardCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.trend,
    required this.isPositive,
    required this.accentColor,
    required this.icon,
  });
}

enum CardType { metric, lineChart, barChart, pieChart }

const List<DashboardCard> defaultCards = [
  DashboardCard(
    id: '1',
    title: 'Total Revenue',
    subtitle: 'This month',
    value: '\$248,392',
    trend: '+12.4%',
    isPositive: true,
    accentColor: Color(0xFF00F5C4),
    icon: Icons.attach_money_rounded,
  ),
  DashboardCard(
    id: '2',
    title: 'Active Users',
    subtitle: 'Daily active',
    value: '84,721',
    trend: '+8.1%',
    isPositive: true,
    accentColor: Color(0xFFFF3CAC),
    icon: Icons.people_outline_rounded,
  ),
  DashboardCard(
    id: '3',
    title: 'Conversion Rate',
    subtitle: 'vs last month',
    value: '3.62%',
    trend: '-0.3%',
    isPositive: false,
    accentColor: Color(0xFFFFBE0B),
    icon: Icons.loop_rounded,
  ),
  DashboardCard(
    id: '4',
    title: 'Avg Session',
    subtitle: 'Duration',
    value: '4m 32s',
    trend: '+22s',
    isPositive: true,
    accentColor: Color(0xFF8B5CF6),
    icon: Icons.timer_outlined,
  ),
];