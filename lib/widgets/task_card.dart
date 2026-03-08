import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskCategory? category;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onStar;

  const TaskCard({
    super.key,
    required this.task,
    this.category,
    this.onTap,
    this.onToggle,
    this.onStar,
  });

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
        return 'High';
      case TaskPriority.medium:
        return 'Med';
      case TaskPriority.low:
        return 'Low';
    }
  }

  bool get _isOverdue {
    return task.status != TaskStatus.completed &&
        task.dueDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final bool isDone = task.status == TaskStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone
                ? AppTheme.divider
                : _isOverdue
                    ? AppTheme.priorityHigh.withOpacity(0.3)
                    : AppTheme.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppTheme.priorityLow
                        : Colors.transparent,
                    border: Border.all(
                      color: isDone
                          ? AppTheme.priorityLow
                          : AppTheme.textSecondary.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDone
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // Subtask progress
                    if (task.subTasks.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: task.completionPercent,
                                backgroundColor:
                                    AppTheme.divider,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        category?.color ??
                                            AppTheme.primary),
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${task.subTasks.where((s) => s.isDone).length}/${task.subTasks.length}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Bottom row: category, priority, date
                    Row(
                      children: [
                        if (category != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: category!.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(category!.icon,
                                    size: 11, color: category!.color),
                                const SizedBox(width: 3),
                                Text(
                                  category!.name,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: category!.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: _priorityColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _priorityLabel,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _priorityColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: _isOverdue
                              ? AppTheme.priorityHigh
                              : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          _isOverdue
                              ? 'Overdue'
                              : DateFormat('MMM d').format(task.dueDate),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _isOverdue
                                ? AppTheme.priorityHigh
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Star
              GestureDetector(
                onTap: onStar,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, top: 1),
                  child: Icon(
                    task.isStarred
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 20,
                    color: task.isStarred
                        ? const Color(0xFFFFB300)
                        : AppTheme.textSecondary.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
