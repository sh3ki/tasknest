import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskData {
  static List<TaskCategory> get categories => const [
    TaskCategory(id: 'work', name: 'Work', icon: Icons.work_rounded, color: Color(0xFF5B2C6F), taskCount: 8),
    TaskCategory(id: 'personal', name: 'Personal', icon: Icons.person_rounded, color: Color(0xFF4ECDC4), taskCount: 5),
    TaskCategory(id: 'health', name: 'Health', icon: Icons.favorite_rounded, color: Color(0xFFE74C3C), taskCount: 4),
    TaskCategory(id: 'learning', name: 'Learning', icon: Icons.school_rounded, color: Color(0xFF9B72CF), taskCount: 6),
    TaskCategory(id: 'finance', name: 'Finance', icon: Icons.account_balance_wallet_rounded, color: Color(0xFFE8A54B), taskCount: 3),
    TaskCategory(id: 'home', name: 'Home', icon: Icons.home_rounded, color: Color(0xFF27AE60), taskCount: 4),
  ];

  static TaskCategory categoryFor(String id) => categories.firstWhere((c) => c.id == id, orElse: () => categories.first);

  static List<Task> get tasks => [
    Task(id: '1', title: 'Prepare quarterly report', description: 'Compile Q3 metrics and create presentation slides', priority: TaskPriority.high, status: TaskStatus.inProgress, dueDate: DateTime.now().add(const Duration(days: 2)), categoryId: 'work', tags: ['report', 'urgent'], isStarred: true, subTasks: [SubTask(title: 'Collect data', isDone: true), SubTask(title: 'Create charts', isDone: true), SubTask(title: 'Write summary'), SubTask(title: 'Review with team')]),
    Task(id: '2', title: 'Update project roadmap', description: 'Align milestones with new timeline', priority: TaskPriority.medium, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 5)), categoryId: 'work', tags: ['planning']),
    Task(id: '3', title: 'Code review for auth module', description: 'Review PR #247 for security compliance', priority: TaskPriority.high, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 1)), categoryId: 'work', tags: ['code', 'security'], isStarred: true),
    Task(id: '4', title: 'Team standup preparation', description: 'Prepare agenda for daily standup', priority: TaskPriority.low, status: TaskStatus.completed, dueDate: DateTime.now(), categoryId: 'work'),
    Task(id: '5', title: 'Schedule dentist visit', description: 'Annual checkup with Dr. Wilson', priority: TaskPriority.medium, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 7)), categoryId: 'personal'),
    Task(id: '6', title: 'Buy birthday gift', description: 'Find something for Sarah', priority: TaskPriority.medium, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 3)), categoryId: 'personal', tags: ['shopping']),
    Task(id: '7', title: 'Morning workout routine', description: '30 min cardio + strength training', priority: TaskPriority.high, status: TaskStatus.inProgress, dueDate: DateTime.now(), categoryId: 'health', subTasks: [SubTask(title: 'Warm up', isDone: true), SubTask(title: 'Cardio 20 min', isDone: true), SubTask(title: 'Strength training'), SubTask(title: 'Cool down stretch')]),
    Task(id: '8', title: 'Meal prep for the week', description: 'Prepare healthy lunches', priority: TaskPriority.medium, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 1)), categoryId: 'health'),
    Task(id: '9', title: 'Complete Flutter course', description: 'Finish chapters 8-12 on state management', priority: TaskPriority.high, status: TaskStatus.inProgress, dueDate: DateTime.now().add(const Duration(days: 10)), categoryId: 'learning', tags: ['flutter', 'education'], isStarred: true, subTasks: [SubTask(title: 'Chapter 8: Provider', isDone: true), SubTask(title: 'Chapter 9: Riverpod', isDone: true), SubTask(title: 'Chapter 10: BLoC'), SubTask(title: 'Chapter 11: GetX'), SubTask(title: 'Chapter 12: Project')]),
    Task(id: '10', title: 'Read design patterns book', description: 'Gang of Four - chapters 5-8', priority: TaskPriority.low, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 14)), categoryId: 'learning'),
    Task(id: '11', title: 'Practice algorithm challenges', description: 'Complete 5 LeetCode problems', priority: TaskPriority.medium, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 4)), categoryId: 'learning', tags: ['coding']),
    Task(id: '12', title: 'Review monthly budget', description: 'Track expenses and adjust savings', priority: TaskPriority.high, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 2)), categoryId: 'finance', tags: ['budget']),
    Task(id: '13', title: 'Pay utility bills', description: 'Electric, water, internet', priority: TaskPriority.high, status: TaskStatus.completed, dueDate: DateTime.now().subtract(const Duration(days: 1)), categoryId: 'finance'),
    Task(id: '14', title: 'Organize home office', description: 'Declutter desk and set up cable management', priority: TaskPriority.low, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 6)), categoryId: 'home'),
    Task(id: '15', title: 'Fix kitchen shelving', description: 'Tighten loose brackets on pantry shelf', priority: TaskPriority.medium, status: TaskStatus.inProgress, dueDate: DateTime.now().add(const Duration(days: 3)), categoryId: 'home', subTasks: [SubTask(title: 'Buy brackets', isDone: true), SubTask(title: 'Remove old shelf'), SubTask(title: 'Install new brackets')]),
    Task(id: '16', title: 'API endpoint documentation', description: 'Document all REST endpoints for v2', priority: TaskPriority.medium, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 8)), categoryId: 'work', tags: ['docs']),
    Task(id: '17', title: 'Water plants', description: 'Indoor and balcony plants', priority: TaskPriority.low, status: TaskStatus.completed, dueDate: DateTime.now(), categoryId: 'home'),
    Task(id: '18', title: 'Complete UI wireframes', description: 'Finalize wireframes for onboarding flow', priority: TaskPriority.high, status: TaskStatus.completed, dueDate: DateTime.now().subtract(const Duration(days: 2)), categoryId: 'work', tags: ['design'], isStarred: true),
    Task(id: '19', title: 'Yoga session', description: 'Evening relaxation and flexibility', priority: TaskPriority.low, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 1)), categoryId: 'health'),
    Task(id: '20', title: 'Watch machine learning lecture', description: 'Stanford CS229 - Lecture 6', priority: TaskPriority.low, status: TaskStatus.pending, dueDate: DateTime.now().add(const Duration(days: 5)), categoryId: 'learning'),
  ];
}
