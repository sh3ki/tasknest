import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/task_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completed = TaskData.tasks.where((t) => t.status == TaskStatus.completed).toList();
    final total = TaskData.tasks.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Completed', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),

            // Summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.success,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${completed.length} of $total Tasks', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(completed.length >= total * 0.5 ? 'Great progress!' : 'Keep going!', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: total > 0 ? completed.length / total : 0,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: Colors.white,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('${completed.length} tasks completed', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 12),

            if (completed.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.hourglass_empty_rounded, color: AppTheme.textSecondary.withOpacity(0.3), size: 48),
                    const SizedBox(height: 8),
                    const Text('No completed tasks yet', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                ),
              )
            else
              ...completed.map((task) {
                final cat = TaskData.categoryFor(task.categoryId);
                return TaskCard(
                  task: task,
                  category: cat,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task, category: cat))),
                );
              }),
          ],
        ),
      ),
    );
  }
}
