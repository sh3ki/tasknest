import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final TaskCategory category;

  const TaskDetailScreen({super.key, required this.task, required this.category});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Color get _priorityColor => AppTheme.priorityColor(_task.priority.name);

  String get _statusLabel {
    switch (_task.status) {
      case TaskStatus.pending: return 'Pending';
      case TaskStatus.inProgress: return 'In Progress';
      case TaskStatus.completed: return 'Completed';
    }
  }

  Color get _statusColor {
    switch (_task.status) {
      case TaskStatus.pending: return AppTheme.warning;
      case TaskStatus.inProgress: return AppTheme.accent;
      case TaskStatus.completed: return AppTheme.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Task Details'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(_task.isStarred ? Icons.star_rounded : Icons.star_outline_rounded, color: _task.isStarred ? AppTheme.warning : AppTheme.textSecondary),
            onPressed: () => setState(() => _task.isStarred = !_task.isStarred),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & category
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: widget.category.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                        child: Icon(widget.category.icon, color: widget.category.color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(widget.category.name, style: TextStyle(color: widget.category.color, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(_task.title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                  if (_task.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(_task.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Status, Priority, Due date
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.circle_outlined,
                    label: 'Status',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(_statusLabel, style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.flag_rounded,
                    label: 'Priority',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _priorityColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(_task.priority.name[0].toUpperCase() + _task.priority.name.substring(1), style: TextStyle(color: _priorityColor, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Due Date',
                    child: Text(DateFormat('EEE, MMM d, yyyy').format(_task.dueDate), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tags
            if (_task.tags.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tags', style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _task.tags.map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.secondary.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                        child: Text('#$t', style: const TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.w600)),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Sub-tasks
            if (_task.subTasks.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Sub-tasks', style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text('${_task.subTasks.where((s) => s.isDone).length}/${_task.subTasks.length}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(value: _task.completionPercent, backgroundColor: AppTheme.divider, color: AppTheme.accent, minHeight: 4),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_task.subTasks.length, (i) {
                      final st = _task.subTasks[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: GestureDetector(
                          onTap: () => setState(() => st.isDone = !st.isDone),
                          child: Row(
                            children: [
                              Icon(st.isDone ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, color: st.isDone ? AppTheme.success : AppTheme.textSecondary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  st.title,
                                  style: TextStyle(
                                    color: st.isDone ? AppTheme.textSecondary : AppTheme.textPrimary,
                                    fontSize: 13,
                                    decoration: st.isDone ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        if (_task.status == TaskStatus.completed) {
                          _task.status = TaskStatus.pending;
                        } else {
                          _task.status = TaskStatus.completed;
                        }
                      });
                    },
                    icon: Icon(_task.status == TaskStatus.completed ? Icons.undo_rounded : Icons.check_rounded, size: 18),
                    label: Text(_task.status == TaskStatus.completed ? 'Reopen' : 'Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _task.status == TaskStatus.completed ? AppTheme.textSecondary : AppTheme.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(color: AppTheme.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.danger),
                    onPressed: () => Navigator.pop(context),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _DetailRow({required this.icon, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 18),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        const Spacer(),
        child,
      ],
    );
  }
}
