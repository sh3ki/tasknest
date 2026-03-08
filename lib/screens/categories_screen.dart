import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategoryId;

  List<Task> _tasksForCategory(String categoryId) {
    return MockData.tasks
        .where((t) =>
            t.categoryId == categoryId &&
            t.status != TaskStatus.completed)
        .toList();
  }

  int _completedForCategory(String categoryId) {
    return MockData.tasks
        .where((t) =>
            t.categoryId == categoryId &&
            t.status == TaskStatus.completed)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${MockData.categories.length} categories • ${MockData.tasks.length} total tasks',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Category grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: MockData.categories.length,
                itemBuilder: (_, index) {
                  final cat = MockData.categories[index];
                  final allTasks = MockData.tasks
                      .where((t) => t.categoryId == cat.id)
                      .length;
                  final done = _completedForCategory(cat.id);
                  final isSelected = _selectedCategoryId == cat.id;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategoryId =
                          isSelected ? null : cat.id;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cat.color.withOpacity(0.12)
                            : AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? cat.color
                              : AppTheme.divider,
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: cat.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(cat.icon,
                                    color: cat.color, size: 20),
                              ),
                              const Spacer(),
                              Text(
                                '$done/$allTasks',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: cat.color,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            cat.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: allTasks == 0
                                  ? 0
                                  : done / allTasks,
                              backgroundColor: cat.color.withOpacity(0.15),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(cat.color),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Task list for selected category
            if (_selectedCategoryId != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: () {
                  final cat = MockData.categories.firstWhere(
                      (c) => c.id == _selectedCategoryId);
                  return Row(
                    children: [
                      Icon(cat.icon, color: cat.color, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${cat.name} Tasks',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: cat.color,
                        ),
                      ),
                    ],
                  );
                }(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount:
                      _tasksForCategory(_selectedCategoryId!).length,
                  itemBuilder: (_, index) {
                    final task =
                        _tasksForCategory(_selectedCategoryId!)[index];
                    final cat = MockData.categories
                        .firstWhere((c) => c.id == task.categoryId);
                    return TaskCard(
                      task: task,
                      category: cat,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(task: task),
                        ),
                      ).then((_) => setState(() {})),
                      onToggle: () => setState(() {
                        task.status =
                            task.status == TaskStatus.completed
                                ? TaskStatus.pending
                                : TaskStatus.completed;
                      }),
                    );
                  },
                ),
              ),
            ] else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 48,
                        color: AppTheme.textSecondary.withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tap a category to see its tasks',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
