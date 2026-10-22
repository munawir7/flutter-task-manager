import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TaskStatistics extends StatelessWidget {
final int total;
final int pending;
final int completed;

const TaskStatistics({
super.key,
required this.total,
required this.pending,
required this.completed,
});

@override
Widget build(BuildContext context) {
return Row(
children: [
Expanded(
child: _StatisticsCard(
title: 'Total Tasks',
count: total,
icon: Icons.task_alt_rounded,
color: AppColors.primary,
),
),
const SizedBox(width: 10),
Expanded(
child: _StatisticsCard(
title: 'Pending',
count: pending,
icon: Icons.pending_actions_rounded,
color: AppColors.warning,
),
),
const SizedBox(width: 10),
Expanded(
child: _StatisticsCard(
title: 'Completed',
count: completed,
icon: Icons.check_circle_outline_rounded,
color: AppColors.success,
),
),
],
);
}
}

class _StatisticsCard extends StatelessWidget {
final String title;
final int count;
final IconData icon;
final Color color;

const _StatisticsCard({
required this.title,
required this.count,
required this.icon,
required this.color,
});

@override
Widget build(BuildContext context) {
return Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.border),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(icon, color: color, size: 23),
const SizedBox(height: 12),
Text(
'$count',
style: const TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
color: AppColors.textPrimary,
),
),
const SizedBox(height: 4),
Text(
title,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 11,
color: AppColors.textSecondary,
),
),
],
),
);
}
}
