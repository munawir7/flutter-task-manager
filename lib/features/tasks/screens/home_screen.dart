
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter.dart';
import '../widgets/task_statistics.dart';
import 'add_edit_task_screen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TaskController controller = Get.find<TaskController>();

  Future<void> _confirmDelete(
    BuildContext context,
    TaskModel task,
  ) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete task?'),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
        ),
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

      Get.snackbar(
        'Task deleted',
        'The task was deleted successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hello there! 👋',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'My Tasks',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.checklist_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => TaskStatistics(
                        total: controller.totalTasks,
                        pending: controller.pendingTasks,
                        completed: controller.completedTasks,
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Search tasks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: controller.updateSearch,
                      decoration: const InputDecoration(
                        hintText: 'Search by task title...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Your tasks',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${controller.filteredTasks.length} tasks',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TaskFilter(controller: controller),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            Obx(() {
              final tasks = controller.filteredTasks;

              if (tasks.isEmpty) {
                final query = controller.searchQuery.value.trim();
                final filter = controller.selectedFilter.value;

                final String title;
                final String message;
                final IconData icon;

                if (query.isNotEmpty) {
                  title = 'No matching tasks';
                  message =
                      'Try another search term to find your tasks.';
                  icon = Icons.search_off_rounded;
                } else if (filter == 'Pending') {
                  title = 'No pending tasks';
                  message =
                      'You are all caught up! There are no pending tasks.';
                  icon = Icons.check_circle_outline_rounded;
                } else if (filter == 'Completed') {
                  title = 'No completed tasks';
                  message =
                      'Complete a task and it will appear here.';
                  icon = Icons.task_alt_rounded;
                } else {
                  title = 'No tasks yet';
                  message =
                      'Create your first task to get started.';
                  icon = Icons.add_task_rounded;
                }

                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: EmptyState(
                      title: title,
                      message: message,
                      icon: icon,
                      buttonText: query.isEmpty && filter == 'All'
                          ? 'Add Task'
                          : null,
                      onButtonPressed: query.isEmpty && filter == 'All'
                          ? () => Get.to(
                                () => const AddEditTaskScreen(),
                              )
                          : null,
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = tasks[index];

                      return TaskCard(
                        key: ValueKey(task.id),
                        task: task,
                        controller: controller,
                        onTap: () => Get.to(
                          () => TaskDetailsScreen(
                            taskId: task.id,
                          ),
                        ),
                        onEdit: () => Get.to(
                          () => AddEditTaskScreen(task: task),
                        ),
                        onDelete: () => _confirmDelete(
                          context,
                          task,
                        ),
                      );
                    },
                    childCount: tasks.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(
          () => const AddEditTaskScreen(),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
    );
  }
}

