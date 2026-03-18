import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/task_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  List<Task> get _tasksForDate {
    return TaskData.tasks.where((t) =>
      t.dueDate.year == _selectedDate.year &&
      t.dueDate.month == _selectedDate.month &&
      t.dueDate.day == _selectedDate.day
    ).toList();
  }

  bool _hasTasksOn(DateTime date) {
    return TaskData.tasks.any((t) => t.dueDate.year == date.year && t.dueDate.month == date.month && t.dueDate.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;
    final today = DateTime.now();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calendar', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),

            // Month nav
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.textSecondary),
                        onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1)),
                      ),
                      Text(DateFormat('MMMM yyyy').format(_focusedMonth), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
                        onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Weekday headers
                  Row(
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) =>
                      Expanded(child: Center(child: Text(d, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)))),
                    ).toList(),
                  ),
                  const SizedBox(height: 8),
                  // Calendar grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
                    itemCount: firstWeekday + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < firstWeekday) return const SizedBox.shrink();
                      final day = index - firstWeekday + 1;
                      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
                      final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
                      final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
                      final hasTasks = _hasTasksOn(date);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primary : isToday ? AppTheme.primary.withOpacity(0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$day', style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontSize: 13, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500)),
                              if (hasTasks) Container(width: 4, height: 4, margin: const EdgeInsets.only(top: 2), decoration: BoxDecoration(color: isSelected ? Colors.white : AppTheme.accent, shape: BoxShape.circle)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tasks for selected date
            Text(DateFormat('EEEE, MMMM d').format(_selectedDate), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (_tasksForDate.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.event_available_rounded, color: AppTheme.textSecondary.withOpacity(0.3), size: 40),
                    const SizedBox(height: 8),
                    const Text('No tasks for this date', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              )
            else
              ..._tasksForDate.map((task) {
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
