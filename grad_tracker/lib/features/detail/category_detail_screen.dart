import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/category.dart';
import '../../core/state/curriculum_state.dart';
import '../../core/theme/app_sizes.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CurriculumState>();
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: ListView.builder(
        itemCount: category.courses.length,
        itemBuilder: (context, index) {
          final c = category.courses[index];
          final done = state.isDone(c.code);
          return CheckboxListTile(
            value: done,
            onChanged: (v) => context.read<CurriculumState>().toggleCourse(c.code, v ?? false),
            title: Text('${c.code} • ${c.name}'),
            subtitle: Text('${c.credits} TC${c.elective ? ' • TC' : ' • BB'}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.cardPadding,
        child: Builder(
          builder: (context) {
            final earned = state.earnedCreditsIn(category);
            final ok = earned >= category.requiredCredits;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: (earned / (category.requiredCredits == 0 ? 1 : category.requiredCredits)).clamp(0, 1)),
                const SizedBox(height: 8),
                Text(ok ? 'Đạt yêu cầu học phần' : 'Chưa đạt yêu cầu học phần'),
              ],
            );
          },
        ),
      ),
    );
  }
}


