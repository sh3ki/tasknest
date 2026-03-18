import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskCategory category;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isComplete = task.status == TaskStatus.completed;
    final priorityColor = AppTheme.priorityColor(task.priority.name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppTheme.cardShadow,
          border: Border(left: BorderSide(color: priorityColor, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(category.icon, color: category.color, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      color: isComplete ? AppTheme.textSecondary : AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: isComplete ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                if (task.isStarred) const Icon(Icons.star_rounded, color: AppTheme.warning, size: 18),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: AppTheme.textSecondary.withOpacity(0.5), size: 12),
                const SizedBox(width: 4),
                Text(DateFormat('MMM d').format(task.dueDate), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                const SizedBox(width: 12),
                if (task.subTasks.isNotEmpty) ...[
                  Icon(Icons.checklist_rounded, color: AppTheme.textSecondary.withOpacity(0.5), size: 12),
                  const SizedBox(width: 4),
                  Text('${task.subTasks.where((s) => s.isDone).length}/${task.subTasks.length}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  const SizedBox(width: 12),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(task.priority.name.toUpperCase(), style: TextStyle(color: priorityColor, fontSize: 9, fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                if (task.subTasks.isNotEmpty)
                  SizedBox(
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: task.completionPercent,
                        backgroundColor: AppTheme.divider,
                        color: AppTheme.accent,
                        minHeight: 4,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
