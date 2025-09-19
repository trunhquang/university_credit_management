import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/curriculum_state.dart';
import '../detail/category_detail_screen.dart';
import '../../core/theme/app_spacing.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CurriculumState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theo dõi điều kiện tốt nghiệp'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                state.eligibleToGraduate ? 'ĐỦ ĐIỀU KIỆN' : 'CHƯA ĐỦ',
                style: TextStyle(
                  color: state.eligibleToGraduate ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: AppSpacing.screen,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tổng yêu cầu: ${state.totalRequired} TC'),
                      const SizedBox(height: 4),
                      Text('Đã tích lũy: ${state.totalEarned} TC'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (state.totalEarned / (state.totalRequired == 0 ? 1 : state.totalRequired)).clamp(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          ...state.categories.map((cat) => _CategoryTile(category: cat)).toList(),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CurriculumState>();
    final earned = state.earnedCreditsIn(category);
    final done = earned >= category.requiredCredits;
    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: category)),
        ),
        child: Padding(
          padding: AppSpacing.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(category.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Chip(label: Text('$earned/${category.requiredCredits} TC'), backgroundColor: done ? Colors.green.shade100 : null),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (earned / (category.requiredCredits == 0 ? 1 : category.requiredCredits)).clamp(0, 1),
                color: done ? Colors.green : null,
              ),
              const SizedBox(height: 4),
              Text('Số học phần: ${category.courses.length}'),
            ],
          ),
        ),
      ),
    );
  }
}


