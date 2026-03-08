import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  TaskCategory? get _category {
    try {
      return MockData.categories.firstWhere((c) => c.id == task.categoryId);
    } catch (_) {
      return null;
    }
  }

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.high:
        return AppTheme.priorityHigh;
      case TaskPriority.medium:
        return AppTheme.priorityMedium;
      case TaskPriority.low:
        return AppTheme.priorityLow;
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case TaskPriority.high:
        return 'High Priority';
      case TaskPriority.medium:
        return 'Medium Priority';
      case TaskPriority.low:
        return 'Low Priority';
    }
  }

  String get _statusLabel {
    switch (task.status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get _statusColor {
    switch (task.status) {
      case TaskStatus.pending:
        return AppTheme.priorityMedium;
      case TaskStatus.inProgress:
        return AppTheme.primary;
      case TaskStatus.completed:
        return AppTheme.priorityLow;
    }
  }

  void _toggleStatus() {
    setState(() {
      task.status = task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed;
    });
  }

  void _toggleSubTask(int index) {
    setState(() {
      task.subTasks[index].isDone = !task.subTasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cat = _category;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          // Custom SliverAppBar with gradient
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: cat?.color ?? AppTheme.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: IconButton(
                    icon: Icon(
                      task.isStarred
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: task.isStarred
                          ? const Color(0xFFFFB300)
                          : Colors.white,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => task.isStarred = !task.isStarred),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (cat?.color ?? AppTheme.primary).withOpacity(0.95),
                      (cat?.color ?? AppTheme.primary).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (cat != null)
                          Row(
                            children: [
                              Icon(cat.icon,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 14),
                              const SizedBox(width: 4),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 6),
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status / Priority pills
                  Row(
                    children: [
                      _PillBadge(
                        label: _statusLabel,
                        color: _statusColor,
                        icon: Icons.circle,
                      ),
                      const SizedBox(width: 8),
                      _PillBadge(
                        label: _priorityLabel,
                        color: _priorityColor,
                        icon: Icons.flag_rounded,
                      ),
                      const Spacer(),
                      Text(
                        'Due ${DateFormat('MMM d, yyyy').format(task.dueDate)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Text(
                      task.description.isEmpty
                          ? 'No description added.'
                          : task.description,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: task.description.isEmpty
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ),

                  // Sub-tasks
                  if (task.subTasks.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Sub-tasks',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${task.subTasks.where((s) => s.isDone).length}/${task.subTasks.length}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: cat?.color ?? AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: task.completionPercent,
                        backgroundColor: AppTheme.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            cat?.color ?? AppTheme.primary),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...task.subTasks.asMap().entries.map((e) {
                      final subTask = e.value;
                      return GestureDetector(
                        onTap: () => _toggleSubTask(e.key),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: subTask.isDone
                                ? AppTheme.priorityLow.withOpacity(0.06)
                                : AppTheme.cardBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: subTask.isDone
                                  ? AppTheme.priorityLow.withOpacity(0.3)
                                  : AppTheme.divider,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: subTask.isDone
                                      ? AppTheme.priorityLow
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: subTask.isDone
                                        ? AppTheme.priorityLow
                                        : AppTheme.textSecondary
                                            .withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                child: subTask.isDone
                                    ? const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 13)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                subTask.title,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: subTask.isDone
                                      ? AppTheme.textSecondary
                                      : AppTheme.textPrimary,
                                  decoration: subTask.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],

                  // Tags
                  if (task.tags.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: task.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#$tag',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Mark as done button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _toggleStatus,
                      icon: Icon(
                        task.status == TaskStatus.completed
                            ? Icons.undo_rounded
                            : Icons.check_circle_rounded,
                        size: 20,
                      ),
                      label: Text(
                        task.status == TaskStatus.completed
                            ? 'Mark as Pending'
                            : 'Mark as Complete',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task.status == TaskStatus.completed
                            ? AppTheme.textSecondary
                            : AppTheme.priorityLow,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _PillBadge(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
