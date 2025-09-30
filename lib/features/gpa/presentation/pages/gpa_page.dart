import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/state/curriculum_provider.dart';
import '../../../../core/models/course.dart';
import '../../../../core/models/section.dart';
import '../../domain/gpa_service.dart';
import '../../../../core/data/gpa_history_service.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/services/notification_service.dart';

class GPAPage extends StatefulWidget {
  const GPAPage({super.key});

  @override
  State<GPAPage> createState() => _GPAPageState();
}

class _GPAPageState extends State<GPAPage> {
  final TextEditingController _targetGpaController = TextEditingController(text: '3.2');
  double? _lastTarget;
  Map<String, double> _predictions = {};
  String _targetRank = 'Giỏi';
  Map<String, double> _rankSuggestions = {};

  @override
  void dispose() {
    _targetGpaController.dispose();
    super.dispose();
  }

  List<Course> _getAllCourses(List<Section> sections) {
    final List<Course> all = [];
    for (final section in sections) {
      for (final group in section.courseGroups) {
        all.addAll(group.courses);
      }
    }
    return all;
  }

  void _calculatePredictions(CurriculumProvider provider) {
    final targetText = _targetGpaController.text.trim();
    final target = double.tryParse(targetText);
    if (target == null || target < 0 || target > 4.0) {
      NotificationService.showSnack(context, 'Nhập GPA mục tiêu hợp lệ (0.0 - 4.0)');
      return;
    }

    final allCourses = _getAllCourses(provider.sections);
    final remaining = GPAService.getRemainingCourses(allCourses);
    final predictions = GPAService.predictForTarget(
      provider.gpaModel,
      target,
      remaining,
    );

    setState(() {
      _lastTarget = target;
      _predictions = predictions;
    });
  }

  void _calculateRankSuggestions(CurriculumProvider provider) {
    final allCourses = _getAllCourses(provider.sections);
    final remaining = GPAService.getRemainingCourses(allCourses);
    final suggestions = provider.gpaModel.getGradeSuggestions(_targetRank, remaining);
    setState(() {
      _rankSuggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPA & Điểm số',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.goBack(context),
        ),
      ),
      body: Consumer<CurriculumProvider>(
        builder: (context, provider, child) {
          final gpa = provider.gpaModel.currentGPA;
          final completedCredits = provider.gpaModel.completedCredits;
          final rank = provider.gpaModel.getAcademicRank();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_up, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GPA hiện tại: ${gpa.toStringAsFixed(2)} / 4.0',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Đã hoàn thành $completedCredits tín chỉ • Xếp loại: $rank',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                FutureBuilder<List<GPAHistoryEntry>>(
                  future: GPAHistoryService().load(),
                  builder: (context, snapshot) {
                    final entries = snapshot.data ?? [];
                    if (entries.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lịch sử GPA', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 220,
                          child: _GpaLineChart(entries: entries),
                        ),
                        const SizedBox(height: 8),
                        _HistoryList(entries: entries),
                      ],
                    );
                  },
                ),

                Text(
                  'GPA mục tiêu',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _targetGpaController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: 'Nhập GPA mục tiêu (0.0 - 4.0)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _calculatePredictions(provider),
                      icon: const Icon(Icons.calculate),
                      label: const Text('Tính'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (_lastTarget != null) ...[
                  Text(
                    'Dự đoán điểm cần đạt (thang 10) cho các môn còn lại',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _PredictionList(
                    predictions: _predictions,
                    allCourses: _getAllCourses(provider.sections),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey[600], size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Nhập GPA mục tiêu để xem gợi ý điểm cho các môn còn lại.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                Text(
                  'Gợi ý theo xếp loại mong muốn',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _targetRank,
                      items: const [
                        DropdownMenuItem(value: 'Xuất sắc', child: Text('Xuất sắc')),
                        DropdownMenuItem(value: 'Giỏi', child: Text('Giỏi')),
                        DropdownMenuItem(value: 'Khá', child: Text('Khá')),
                        DropdownMenuItem(value: 'Trung bình', child: Text('Trung bình')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _targetRank = v);
                      },
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _calculateRankSuggestions(provider),
                      icon: const Icon(Icons.tips_and_updates_outlined),
                      label: const Text('Gợi ý'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                if (_rankSuggestions.isNotEmpty)
                  _PredictionList(
                    predictions: _rankSuggestions,
                    allCourses: _getAllCourses(provider.sections),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PredictionList extends StatelessWidget {
  final Map<String, double> predictions;
  final List<Course> allCourses;

  const _PredictionList({
    required this.predictions,
    required this.allCourses,
  });

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.inbox_outlined, color: Colors.grey[600], size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Không có môn học còn lại hoặc không thể tính cho mục tiêu hiện tại.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      );
    }

    Course? findCourse(String id) {
      for (final c in allCourses) {
        if (c.id == id) return c;
      }
      return null;
    }

    final entries = predictions.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final e = entries[index];
        final course = findCourse(e.key);
        final name = course?.name ?? 'Môn ${e.key}';
        final credits = course?.credits ?? 0;
        final status = course?.status.toString().split('.').last ?? '';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          leading: const Icon(Icons.book_outlined),
          title: Text(name),
          subtitle: Text('Tín chỉ: $credits • Trạng thái: $status'),
          trailing: Text(
            e.value.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<GPAHistoryEntry> entries;
  const _HistoryList({required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final e = entries[index];
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: const Icon(Icons.timeline_outlined),
          title: Text('GPA ${e.gpa.toStringAsFixed(2)}'),
          subtitle: Text('Tín chỉ: ${e.completedCredits} • ${e.timestamp.toLocal()}'),
        );
      },
    );
  }
}

class _GpaLineChart extends StatelessWidget {
  final List<GPAHistoryEntry> entries;
  const _GpaLineChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return Center(
        child: Text(
          'Chưa đủ dữ liệu để vẽ xu hướng',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final sorted = [...entries]..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final firstTs = sorted.first.timestamp.millisecondsSinceEpoch.toDouble();

    List<FlSpot> spots = [];
    for (final e in sorted) {
      final x = (e.timestamp.millisecondsSinceEpoch.toDouble() - firstTs) / (1000 * 60 * 60 * 24);
      spots.add(FlSpot(x, e.gpa));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 4.0,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (spots.length > 1) ? (spots.last.x / 3).clamp(1, double.infinity) : 1,
              getTitlesWidget: (value, meta) {
                return Text('${value.toStringAsFixed(0)}d', style: const TextStyle(fontSize: 10));
              },
              reservedSize: 24,
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: Theme.of(context).primaryColor.withOpacity(0.1)),
          )
        ],
      ),
    );
  }
}
