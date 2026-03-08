import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/mock_data.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
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
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Today', 'High', 'Starred'];

  List<Task> get _filteredTasks {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Today':
        return MockData.tasks
            .where((t) =>
                t.status != TaskStatus.completed &&
                t.dueDate.year == now.year &&
                t.dueDate.month == now.month &&
                t.dueDate.day == now.day)
            .toList();
      case 'High':
        return MockData.tasks
            .where((t) =>
                t.status != TaskStatus.completed &&
                t.priority == TaskPriority.high)
            .toList();
      case 'Starred':
        return MockData.tasks
            .where(
                (t) => t.status != TaskStatus.completed && t.isStarred)
            .toList();
      default:
        return MockData.tasks
            .where((t) => t.status != TaskStatus.completed)
            .toList();
    }
  }

  int get _totalTasks => MockData.tasks.length;
  int get _completedTasks =>
      MockData.tasks.where((t) => t.status == TaskStatus.completed).length;
  int get _pendingTasks =>
      MockData.tasks.where((t) => t.status == TaskStatus.pending).length;
  int get _inProgressTasks =>
      MockData.tasks.where((t) => t.status == TaskStatus.inProgress).length;

  TaskCategory? _categoryFor(Task task) {
    try {
      return MockData.categories
          .firstWhere((c) => c.id == task.categoryId);
    } catch (_) {
      return null;
    }
  }

  void _toggleTask(Task task) {
    setState(() {
      task.status = task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed;
    });
  }

  void _toggleStar(Task task) {
    setState(() {
      task.isStarred = !task.isStarred;
    });
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Text(
                            'Alex Johnson 👋',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primary.withOpacity(0.15),
                          child: const Text(
                            'AJ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.priorityHigh,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.surface, width: 2),
                            ),
                            child: const Center(
                              child: Text('3',
                                  style: TextStyle(
                                      fontSize: 7,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Progress Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _buildProgressBanner(),
              ),
            ),

            // Stats Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Pending',
                        value: '$_pendingTasks',
                        icon: Icons.pending_actions_rounded,
                        color: AppTheme.priorityMedium,
                        subtitle: 'tasks left',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'In Progress',
                        value: '$_inProgressTasks',
                        icon: Icons.autorenew_rounded,
                        color: AppTheme.primary,
                        subtitle: 'active',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'Completed',
                        value: '$_completedTasks',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.priorityLow,
                        subtitle: 'this week',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Weekly chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _buildWeeklyChart(),
              ),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Tasks',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters
                            .map((f) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _FilterChip(
                                    label: f,
                                    isSelected: _selectedFilter == f,
                                    onTap: () =>
                                        setState(() => _selectedFilter = f),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Task list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
              sliver: _filteredTasks.isEmpty
                  ? SliverToBoxAdapter(
                      child: _buildEmptyState(),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = _filteredTasks[index];
                          return TaskCard(
                            task: task,
                            category: _categoryFor(task),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TaskDetailScreen(task: task),
                              ),
                            ).then((_) => setState(() {})),
                            onToggle: () => _toggleTask(task),
                            onStar: () => _toggleStar(task),
                          );
                        },
                        childCount: _filteredTasks.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        ).then((_) => setState(() {})),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Task',
          style: TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildProgressBanner() {
    final progress = _totalTasks == 0 ? 0.0 : _completedTasks / _totalTasks;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Progress',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_completedTasks of $_totalTasks tasks done',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            progress >= 0.8
                ? '🎉 Almost there! Keep it up!'
                : progress >= 0.5
                    ? '💪 Great progress! Stay focused!'
                    : '🚀 Let\'s get things done today!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final data = MockData.weeklyCompletionData;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Task Completion This Week',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'This Week',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 8,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            data[value.toInt()]['day'] as String,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppTheme.divider,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data
                    .asMap()
                    .entries
                    .map(
                      (e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: (e.value['total'] as int).toDouble(),
                            color: AppTheme.primary.withOpacity(0.15),
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                          ),
                          BarChartRodData(
                            toY:
                                (e.value['completed'] as int).toDouble(),
                            color: AppTheme.primary,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                          ),
                        ],
                        barsSpace: -18,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              size: 40,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tasks here!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap + Add Task to get started.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? AppTheme.primary : AppTheme.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
