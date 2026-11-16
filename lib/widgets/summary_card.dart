import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 15),
            Text(
              count.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(color: AppTheme.textsecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
