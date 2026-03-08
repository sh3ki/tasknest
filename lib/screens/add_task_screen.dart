import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  String _categoryId = 'work';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (!_formKey.currentState!.validate()) return;
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      status: TaskStatus.pending,
      dueDate: _dueDate,
      categoryId: _categoryId,
      tags: List.from(_tags),
    );
    MockData.tasks.insert(0, task);
    Navigator.pop(context);
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppTheme.textPrimary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add New Task'),
        actions: [
          TextButton(
            onPressed: _addTask,
            child: const Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              _SectionLabel(label: 'Task Title *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter a title' : null,
                style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'e.g., Finish UI design mockups',
                  prefixIcon: Icon(Icons.title_rounded,
                      color: AppTheme.primary, size: 20),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              _SectionLabel(label: 'Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Add task details...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // Priority
              _SectionLabel(label: 'Priority'),
              const SizedBox(height: 10),
              Row(
                children: TaskPriority.values.map((p) {
                  final colors = {
                    TaskPriority.high: AppTheme.priorityHigh,
                    TaskPriority.medium: AppTheme.priorityMedium,
                    TaskPriority.low: AppTheme.priorityLow,
                  };
                  final labels = {
                    TaskPriority.high: 'High',
                    TaskPriority.medium: 'Medium',
                    TaskPriority.low: 'Low',
                  };
                  final icons = {
                    TaskPriority.high: Icons.keyboard_double_arrow_up_rounded,
                    TaskPriority.medium: Icons.remove_rounded,
                    TaskPriority.low: Icons.keyboard_double_arrow_down_rounded,
                  };
                  final isSelected = _priority == p;
                  final color = colors[p]!;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _priority = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withOpacity(0.12)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : AppTheme.divider,
                              width: isSelected ? 1.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(icons[p], color: color, size: 20),
                              const SizedBox(height: 4),
                              Text(
                                labels[p]!,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? color
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Category
              _SectionLabel(label: 'Category'),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.categories.length,
                  itemBuilder: (_, index) {
                    final cat = MockData.categories[index];
                    final isSelected = _categoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _categoryId = cat.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 72,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cat.color.withOpacity(0.12)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? cat.color
                                  : AppTheme.divider,
                              width: isSelected ? 1.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(cat.icon,
                                  color: isSelected
                                      ? cat.color
                                      : AppTheme.textSecondary,
                                  size: 22),
                              const SizedBox(height: 4),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? cat.color
                                      : AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Due Date
              _SectionLabel(label: 'Due Date'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: AppTheme.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppTheme.textSecondary, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tags
              _SectionLabel(label: 'Tags'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      style: const TextStyle(
                          fontFamily: 'Poppins', fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Add a tag...',
                        prefixIcon: Icon(Icons.label_rounded,
                            color: AppTheme.primary, size: 18),
                      ),
                      onFieldSubmitted: (_) => _addTag(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addTag,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child:
                        const Icon(Icons.add_rounded, size: 20),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _tags
                      .map((tag) => Chip(
                            label: Text(tag,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12)),
                            backgroundColor:
                                AppTheme.primary.withOpacity(0.1),
                            labelStyle: const TextStyle(
                                color: AppTheme.primary),
                            deleteIcon: const Icon(Icons.close,
                                size: 14, color: AppTheme.primary),
                            onDeleted: () =>
                                setState(() => _tags.remove(tag)),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Create Task'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}
