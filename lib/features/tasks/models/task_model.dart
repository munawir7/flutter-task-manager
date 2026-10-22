enum TaskPriority {
low,
medium,
high,
}

enum TaskStatus {
pending,
completed,
}

class TaskModel {
final String id;
final String title;
final String description;
final TaskPriority priority;
final DateTime dueDate;
final TaskStatus status;
final DateTime createdAt;

TaskModel({
required this.id,
required this.title,
required this.description,
required this.priority,
required this.dueDate,
this.status = TaskStatus.pending,
DateTime? createdAt,
}) : createdAt = createdAt ?? DateTime.now();

TaskModel copyWith({
String? title,
String? description,
TaskPriority? priority,
DateTime? dueDate,
TaskStatus? status,
}) {
return TaskModel(
id: id,
title: title ?? this.title,
description: description ?? this.description,
priority: priority ?? this.priority,
dueDate: dueDate ?? this.dueDate,
status: status ?? this.status,
createdAt: createdAt,
);
}
}
