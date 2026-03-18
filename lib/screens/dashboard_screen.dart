import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/task_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../utils/profile_avatar_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/stat_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = 'all';
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = TaskData.tasks;
  }

  List<Task> get _filteredTasks {
    switch (_filter) {
      case 'pending': return _tasks.where((t) => t.status == TaskStatus.pending).toList();
      case 'inProgress': return _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
      case 'starred': return _tasks.where((t) => t.isStarred).toList();
      default: return _tasks.where((t) => t.status != TaskStatus.completed).toList();
    }
  }

  int get _totalTasks => _tasks.length;
  int get _completedCount => _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get _pendingCount => _tasks.where((t) => t.status == TaskStatus.pending).length;
  int get _inProgressCount => _tasks.where((t) => t.status == TaskStatus.inProgress).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      ProfileAvatarProvider.imageUrl,
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 42,
                        height: 42,
                        color: AppTheme.primary.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: const Text('AJ', style: TextStyle(color: AppTheme.primary, fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Good morning,', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      const Text('Alex Johnson', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(10), boxShadow: AppTheme.cardShadow),
                    child: const Icon(Icons.notifications_none_rounded, color: AppTheme.textSecondary, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats row
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.45,
                children: [
                  StatCard(icon: Icons.assignment_rounded, label: 'Total Tasks', value: '$_totalTasks', color: AppTheme.secondary),
                  StatCard(icon: Icons.check_circle_rounded, label: 'Completed', value: '$_completedCount', color: AppTheme.success),
                  StatCard(icon: Icons.pending_actions_rounded, label: 'Pending', value: '$_pendingCount', color: AppTheme.warning),
                  StatCard(icon: Icons.trending_up_rounded, label: 'In Progress', value: '$_inProgressCount', color: AppTheme.accent),
                ],
              ),
              const SizedBox(height: 24),

              // Progress overview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 24,
                          sections: [
                            PieChartSectionData(value: _completedCount.toDouble(), color: AppTheme.success, radius: 14, showTitle: false),
                            PieChartSectionData(value: _inProgressCount.toDouble(), color: AppTheme.accent, radius: 14, showTitle: false),
                            PieChartSectionData(value: _pendingCount.toDouble(), color: AppTheme.warning, radius: 14, showTitle: false),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _totalTasks > 0 ? '${(_completedCount / _totalTasks * 100).round()}% Complete' : '0% Complete',
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _completedCount >= _totalTasks * 0.75
                                ? 'Almost there! Keep it up!'
                                : _completedCount >= _totalTasks * 0.5
                                    ? 'Great progress! Stay focused!'
                                    : 'Let\'s get things done today!',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _LegendDot(color: AppTheme.success, label: 'Done'),
                              const SizedBox(width: 12),
                              _LegendDot(color: AppTheme.accent, label: 'Active'),
                              const SizedBox(width: 12),
                              _LegendDot(color: AppTheme.warning, label: 'Pending'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Filter chips
              Row(
                children: [
                  const Text('Tasks', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  _FilterChip(label: 'All', isSelected: _filter == 'all', onTap: () => setState(() => _filter = 'all')),
                  const SizedBox(width: 6),
                  _FilterChip(label: 'Pending', isSelected: _filter == 'pending', onTap: () => setState(() => _filter = 'pending')),
                  const SizedBox(width: 6),
                  _FilterChip(label: 'Active', isSelected: _filter == 'inProgress', onTap: () => setState(() => _filter = 'inProgress')),
                  const SizedBox(width: 6),
                  _FilterChip(label: 'Starred', isSelected: _filter == 'starred', onTap: () => setState(() => _filter = 'starred')),
                ],
              ),
              const SizedBox(height: 12),

              // Task list
              if (_filteredTasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.inbox_rounded, color: AppTheme.textSecondary.withOpacity(0.3), size: 48),
                      const SizedBox(height: 8),
                      const Text('No tasks found', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                    ],
                  ),
                )
              else
                ...(_filteredTasks.map((task) {
                  final cat = TaskData.categoryFor(task.categoryId);
                  return TaskCard(
                    task: task,
                    category: cat,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task, category: cat))),
                  );
                })),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen())),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? null : AppTheme.cardShadow,
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
