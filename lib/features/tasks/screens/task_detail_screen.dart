import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import 'add_edit_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
final String taskId;

TaskDetailsScreen({
super.key,
required this.taskId,
});

final TaskController controller = Get.find<TaskController>();

Color _priorityColor(TaskPriority priority) {
switch (priority) {
case TaskPriority.high:
return AppColors.danger;
case TaskPriority.medium:
return AppColors.warning;
case TaskPriority.low:
return AppColors.info;
}
}

String _formatDate(DateTime date) {
final day = date.day.toString().padLeft(2, '0');
final month = date.month.toString().padLeft(2, '0');


return '$day/$month/${date.year}';


}

Future<void> _deleteTask(TaskModel task) async {
final confirmed = await Get.dialog<bool>(
AlertDialog(
title: const Text('Delete task?'),
content: Text('Delete "${task.title}" permanently?'),
actions: [
TextButton(
onPressed: () => Get.back(result: false),
child: const Text('Cancel'),
),
FilledButton(
style: FilledButton.styleFrom(
backgroundColor: AppColors.danger,
),
onPressed: () => Get.back(result: true),
child: const Text('Delete'),
),
],
),
);


if (confirmed == true) {
  controller.deleteTask(task.id);
  Get.back();

  Get.snackbar(
    'Task deleted',
    'The task has been deleted.',
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(12),
  );
}


}

@override
Widget build(BuildContext context) {
return Obx(() {
final index = controller.tasks.indexWhere(
(task) => task.id == taskId,
);


  if (index == -1) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: const Center(
        child: Text('This task is no longer available.'),
      ),
    );
  }

  final task = controller.tasks[index];
  final isCompleted = task.status == TaskStatus.completed;
  final priorityColor = _priorityColor(task.priority);

  return Scaffold(
    appBar: AppBar(
      title: const Text('Task Details'),
      actions: [
        IconButton(
          tooltip: 'Edit task',
          onPressed: () {
            Get.to(() => AddEditTaskScreen(task: task));
          },
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: 'Delete task',
          onPressed: () => _deleteTask(task),
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.danger,
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCompleted ? 'Completed' : 'Pending',
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.success
                        : AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 25,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                task.description.isEmpty
                    ? 'No description provided.'
                    : task.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'Task information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        _DetailTile(
          icon: Icons.flag_outlined,
          title: 'Priority',
          value: task.priority.name.toUpperCase(),
          color: priorityColor,
        ),
        _DetailTile(
          icon: Icons.calendar_today_outlined,
          title: 'Due date',
          value: _formatDate(task.dueDate),
          color: AppColors.primary,
        ),
        _DetailTile(
          icon: Icons.access_time_rounded,
          title: 'Created on',
          value: _formatDate(task.createdAt),
          color: AppColors.info,
        ),
        _DetailTile(
          icon: Icons.check_circle_outline_rounded,
          title: 'Current status',
          value: isCompleted ? 'Completed' : 'Pending',
          color: isCompleted
              ? AppColors.success
              : AppColors.warning,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: () {
              controller.toggleTaskStatus(task.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: isCompleted
                  ? AppColors.warning
                  : AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: Icon(
              isCompleted
                  ? Icons.undo_rounded
                  : Icons.check_circle_outline_rounded,
            ),
            label: Text(
              isCompleted
                  ? 'Mark as Pending'
                  : 'Mark as Completed',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
});


}
}

class _DetailTile extends StatelessWidget {
final IconData icon;
final String title;
final String value;
final Color color;

const _DetailTile({
required this.icon,
required this.title,
required this.value,
required this.color,
});

@override
Widget build(BuildContext context) {
return Container(
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(15),
border: Border.all(color: AppColors.border),
),
child: Row(
children: [
Container(
height: 42,
width: 42,
decoration: BoxDecoration(
color: color.withValues(alpha: 0.10),
borderRadius: BorderRadius.circular(12),
),
child: Icon(icon, color: color),
),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: const TextStyle(
fontSize: 12,
color: AppColors.textSecondary,
),
),
const SizedBox(height: 5),
Text(
value,
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.w700,
color: AppColors.textPrimary,
),
),
],
),
),
],
),
);
}
}
