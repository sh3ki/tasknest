import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const StatCard({super.key, required this.icon, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.secondary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: c.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: c, size: 18),
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class CategoryStatCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final int taskCount;
  final VoidCallback? onTap;

  const CategoryStatCard({super.key, required this.icon, required this.name, required this.color, required this.taskCount, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Spacer(),
            Text(name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text('$taskCount tasks', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
