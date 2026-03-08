import 'package:flutter/material.dart';

enum TaskPriority { high, medium, low }

enum TaskStatus { pending, inProgress, completed }

class TaskCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int taskCount;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.taskCount = 0,
  });
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  TaskStatus status;
  final DateTime dueDate;
  final String categoryId;
  final List<SubTask> subTasks;
  final List<String> tags;
  bool isStarred;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.categoryId,
    this.subTasks = const [],
    this.tags = const [],
    this.isStarred = false,
  });

  double get completionPercent {
    if (subTasks.isEmpty) {
      return status == TaskStatus.completed ? 1.0 : 0.0;
    }
    final done = subTasks.where((s) => s.isDone).length;
    return done / subTasks.length;
  }

  Task copyWith({
    TaskStatus? status,
    bool? isStarred,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status ?? this.status,
      dueDate: dueDate,
      categoryId: categoryId,
      subTasks: subTasks,
      tags: tags,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}

class SubTask {
  final String title;
  bool isDone;

  SubTask({required this.title, this.isDone = false});
}
