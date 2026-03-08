import 'package:flutter/material.dart';
import '../models/task_model.dart';

class MockData {
  static final List<TaskCategory> categories = [
    const TaskCategory(
      id: 'work',
      name: 'Work',
      icon: Icons.work_rounded,
      color: Color(0xFF5C6BC0),
      taskCount: 8,
    ),
    const TaskCategory(
      id: 'personal',
      name: 'Personal',
      icon: Icons.person_rounded,
      color: Color(0xFFEC407A),
      taskCount: 5,
    ),
    const TaskCategory(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFF26C6DA),
      taskCount: 3,
    ),
    const TaskCategory(
      id: 'health',
      name: 'Health',
      icon: Icons.favorite_rounded,
      color: Color(0xFF66BB6A),
      taskCount: 4,
    ),
    const TaskCategory(
      id: 'education',
      name: 'Education',
      icon: Icons.school_rounded,
      color: Color(0xFFFF9800),
      taskCount: 6,
    ),
    const TaskCategory(
      id: 'finance',
      name: 'Finance',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFFAB47BC),
      taskCount: 2,
    ),
  ];

  static List<Task> tasks = [
    Task(
      id: '1',
      title: 'Finish UI Design for Mobile App',
      description:
          'Complete the high-fidelity mockups for the onboarding flow, dashboard, and settings screens. Review with the design team before handoff.',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      categoryId: 'work',
      tags: ['design', 'mobile', 'urgent'],
      isStarred: true,
      subTasks: [
        SubTask(title: 'Onboarding screens', isDone: true),
        SubTask(title: 'Dashboard layout', isDone: true),
        SubTask(title: 'Settings screens', isDone: false),
        SubTask(title: 'Design review', isDone: false),
      ],
    ),
    Task(
      id: '2',
      title: 'Buy Groceries',
      description:
          'Weekly grocery run. Pick up fresh vegetables, fruits, dairy products, and household essentials from the supermarket.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 0)),
      categoryId: 'shopping',
      tags: ['errands', 'weekly'],
      subTasks: [
        SubTask(title: 'Vegetables & fruits', isDone: false),
        SubTask(title: 'Dairy products', isDone: false),
        SubTask(title: 'Household items', isDone: false),
      ],
    ),
    Task(
      id: '3',
      title: 'Prepare Quarterly Presentation',
      description:
          'Compile Q3 performance data, create slide deck, and prepare talking points for the board meeting next week.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      categoryId: 'work',
      tags: ['presentation', 'Q3', 'board'],
      isStarred: true,
      subTasks: [
        SubTask(title: 'Gather Q3 data', isDone: true),
        SubTask(title: 'Create slide deck', isDone: false),
        SubTask(title: 'Review with manager', isDone: false),
      ],
    ),
    Task(
      id: '4',
      title: 'Morning Workout Routine',
      description:
          '30-minute morning workout: 10 min cardio warm-up, 15 min strength training, 5 min cool-down stretches.',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      categoryId: 'health',
      tags: ['fitness', 'daily'],
      subTasks: [
        SubTask(title: 'Cardio warm-up', isDone: true),
        SubTask(title: 'Strength training', isDone: true),
        SubTask(title: 'Cool-down', isDone: true),
      ],
    ),
    Task(
      id: '5',
      title: 'Read Flutter Documentation',
      description:
          'Study Material 3 design guidelines and the latest Flutter 3.x features including new widget APIs.',
      priority: TaskPriority.medium,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      categoryId: 'education',
      tags: ['learning', 'flutter'],
      subTasks: [
        SubTask(title: 'Material 3 overview', isDone: true),
        SubTask(title: 'New widget APIs', isDone: false),
        SubTask(title: 'State management', isDone: false),
      ],
    ),
    Task(
      id: '6',
      title: 'Pay Monthly Bills',
      description:
          'Pay electricity, internet, and credit card bills before the due dates to avoid late fees.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      categoryId: 'finance',
      tags: ['bills', 'monthly'],
    ),
    Task(
      id: '7',
      title: 'Call Mom & Dad',
      description:
          'Weekly family catch-up call. Share updates about work and ask about the family trip plans.',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      categoryId: 'personal',
      tags: ['family'],
    ),
    Task(
      id: '8',
      title: 'Team Code Review Session',
      description:
          'Review PRs for the new authentication module and provide constructive feedback to junior developers.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      categoryId: 'work',
      tags: ['code-review', 'team'],
    ),
    Task(
      id: '9',
      title: 'Annual Health Checkup',
      description:
          'Schedule and attend annual physical exam, blood work, and eye exam.',
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      categoryId: 'health',
      tags: ['health', 'annual'],
      subTasks: [
        SubTask(title: 'Physical exam', isDone: true),
        SubTask(title: 'Blood work', isDone: true),
        SubTask(title: 'Eye exam', isDone: true),
      ],
    ),
    Task(
      id: '10',
      title: 'Plan Weekend Trip',
      description:
          'Research and book accommodations for the weekend getaway. Check weather and pack accordingly.',
      priority: TaskPriority.low,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 4)),
      categoryId: 'personal',
      tags: ['travel', 'weekend'],
      subTasks: [
        SubTask(title: 'Research destinations', isDone: true),
        SubTask(title: 'Book accommodation', isDone: false),
        SubTask(title: 'Pack bags', isDone: false),
      ],
    ),
    Task(
      id: '11',
      title: 'Launch Marketing Campaign',
      description:
          'Coordinate with the marketing team to launch the Q4 digital campaign across social media platforms.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      categoryId: 'work',
      tags: ['marketing', 'Q4', 'campaign'],
      isStarred: true,
    ),
    Task(
      id: '12',
      title: 'Meditate 10 Minutes',
      description:
          'Daily mindfulness practice using the breathing exercise routine.',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      dueDate: DateTime.now(),
      categoryId: 'health',
      tags: ['mindfulness', 'daily'],
    ),
  ];

  static Map<DateTime, List<String>> get calendarEvents {
    final map = <DateTime, List<String>>{};
    for (final task in tasks) {
      final key = DateTime(
          task.dueDate.year, task.dueDate.month, task.dueDate.day);
      map[key] = [...(map[key] ?? []), task.title];
    }
    return map;
  }

  static List<Map<String, dynamic>> get weeklyCompletionData {
    return [
      {'day': 'Mon', 'completed': 3, 'total': 5},
      {'day': 'Tue', 'completed': 5, 'total': 6},
      {'day': 'Wed', 'completed': 2, 'total': 7},
      {'day': 'Thu', 'completed': 4, 'total': 4},
      {'day': 'Fri', 'completed': 1, 'total': 3},
      {'day': 'Sat', 'completed': 3, 'total': 3},
      {'day': 'Sun', 'completed': 2, 'total': 4},
    ];
  }
}
