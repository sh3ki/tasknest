import 'package:flutter/material.dart';
import '../data/task_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/stat_card.dart';
import 'task_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategoryId;

  List<Task> get _categoryTasks {
    if (_selectedCategoryId == null) return [];
    return TaskData.tasks.where((t) => t.categoryId == _selectedCategoryId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Categories', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('${TaskData.categories.length} categories', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: TaskData.categories.map((cat) {
                final count = TaskData.tasks.where((t) => t.categoryId == cat.id).length;
                return CategoryStatCard(
                  icon: cat.icon,
                  name: cat.name,
                  color: cat.color,
                  taskCount: count,
                  onTap: () => setState(() => _selectedCategoryId = _selectedCategoryId == cat.id ? null : cat.id),
                );
              }).toList(),
            ),

            if (_selectedCategoryId != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Text('${TaskData.categoryFor(_selectedCategoryId!).name} Tasks', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _selectedCategoryId = null),
                    child: const Icon(Icons.close_rounded, color: AppTheme.textSecondary, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_categoryTasks.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text('No tasks in this category', style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.6), fontSize: 13))),
                )
              else
                ..._categoryTasks.map((task) {
                  final cat = TaskData.categoryFor(task.categoryId);
                  return TaskCard(
                    task: task,
                    category: cat,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task, category: cat))),
                  );
                }),
            ],
          ],
        ),
      ),
    );
  }
}
