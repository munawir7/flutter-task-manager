import 'package:get/get.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
final RxList<TaskModel> tasks = <TaskModel>[].obs;

final RxString searchQuery = ''.obs;
final RxString selectedFilter = 'All'.obs;

int get totalTasks => tasks.length;

int get pendingTasks =>
tasks.where((task) => task.status == TaskStatus.pending).length;

int get completedTasks =>
tasks.where((task) => task.status == TaskStatus.completed).length;

List<TaskModel> get filteredTasks {
final query = searchQuery.value.trim().toLowerCase();


return tasks.where((task) {
  final matchesSearch = task.title.toLowerCase().contains(query);

  final matchesFilter = switch (selectedFilter.value) {
    'Pending' => task.status == TaskStatus.pending,
    'Completed' => task.status == TaskStatus.completed,
    _ => true,
  };

  return matchesSearch && matchesFilter;
}).toList();


}

void addTask(TaskModel task) {
tasks.add(task);
}

void updateTask(TaskModel updatedTask) {
final index = tasks.indexWhere((task) => task.id == updatedTask.id);


if (index != -1) {
  tasks[index] = updatedTask;
}


}

void deleteTask(String taskId) {
tasks.removeWhere((task) => task.id == taskId);
}

void toggleTaskStatus(String taskId) {
final index = tasks.indexWhere((task) => task.id == taskId);


if (index == -1) return;

final task = tasks[index];

final updatedTask = task.copyWith(
  status: task.status == TaskStatus.pending
      ? TaskStatus.completed
      : TaskStatus.pending,
);

tasks[index] = updatedTask;


}

void updateSearch(String query) {
searchQuery.value = query;
}

void updateFilter(String filter) {
selectedFilter.value = filter;
}
}
