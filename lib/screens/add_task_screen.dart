import 'package:flutter/material.dart';
import '../data/task_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  String _categoryId = 'work';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(title: const Text('Add Task'), leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const _SectionLabel(label: 'Title'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(12), boxShadow: AppTheme.cardShadow),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const _SectionLabel(label: 'Description'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(12), boxShadow: AppTheme.cardShadow),
              child: TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add details...',
                  hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category selection
            const _SectionLabel(label: 'Category'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TaskData.categories.map((cat) {
                final isSelected = cat.id == _categoryId;
                return GestureDetector(
                  onTap: () => setState(() => _categoryId = cat.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? cat.color : AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isSelected ? null : AppTheme.cardShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, color: isSelected ? Colors.white : cat.color, size: 16),
                        const SizedBox(width: 6),
                        Text(cat.name, style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Priority
            const _SectionLabel(label: 'Priority'),
            const SizedBox(height: 8),
            Row(
              children: TaskPriority.values.map((p) {
                final isSelected = p == _priority;
                final color = AppTheme.priorityColor(p.name);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: Container(
                      margin: EdgeInsets.only(right: p != TaskPriority.low ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? color : AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected ? null : AppTheme.cardShadow,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flag_rounded, color: isSelected ? Colors.white : color, size: 16),
                            const SizedBox(width: 4),
                            Text(p.name[0].toUpperCase() + p.name.substring(1), style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Due date
            const _SectionLabel(label: 'Due Date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: _dueDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (picked != null) setState(() => _dueDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(12), boxShadow: AppTheme.cardShadow),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: AppTheme.secondary, size: 20),
                    const SizedBox(width: 10),
                    Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Create Task', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600));
  }
}
