import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/state/curriculum_provider.dart';
import '../../../../core/models/course.dart';
import '../../../planning/domain/models.dart';
import '../../../planning/domain/planning_service.dart';
import '../../../../core/services/notification_service.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  final PlanningService _service = PlanningService();
  List<SemesterPlan> _plans = [];
  bool _loading = true;

  // Helpers: maps to locate a course's group and compute remaining credits per group
  Map<String, dynamic> _buildCourseIndex(CurriculumProvider provider) {
    final Map<String, Map<String, Object>> courseToGroup = {};
    final Map<String, Map<String, Object>> groupInfo = {};
    for (final section in provider.sections) {
      for (final group in section.courseGroups) {
        groupInfo[group.id] = {
          'requiredCredits': group.requiredCredits,
          'optionalCredits': group.optionalCredits,
          'name': group.name,
        };
        for (final c in group.courses) {
          courseToGroup[c.id] = {
            'groupId': group.id,
            'groupName': group.name,
          };
        }
      }
    }
    return {
      'courseToGroup': courseToGroup,
      'groupInfo': groupInfo,
    };
  }

  Future<void> _pickAndAddCourse(SemesterPlan plan, CurriculumProvider provider) async {
    final remaining = provider.getCoursesByStatus(CourseStatus.notStarted);
    if (remaining.isEmpty) {
      NotificationService.showSnack(context, 'Không còn môn phù hợp để thêm.');
      return;
    }

    final selected = await showDialog<Course>(
      context: context,
      builder: (context) {
        final plannedIds = plan.plannedCourses.map((e) => e.courseId).toSet();
                                      final groupRemaining = _computeGroupRemaining(provider, plan);
        final index = _buildCourseIndex(provider);
        final courseToGroup = index['courseToGroup'] as Map<String, Map<String, Object>>;
        final TextEditingController searchCtrl = TextEditingController();
        String query = '';
        List<Course> filterList() {
          final q = query.trim().toLowerCase();
          return remaining.where((c) {
            if (plannedIds.contains(c.id)) return false;
            final meta = courseToGroup[c.id];
            if (meta != null) {
              final groupId = meta['groupId'] as String;
              final remain = groupRemaining[groupId] ?? {'req': 0, 'opt': 0};
              if (c.type == CourseType.required) {
                if ((remain['req'] ?? 0) <= 0) return false;
              } else {
                if ((remain['opt'] ?? 0) <= 0) return false;
              }
            }
            if (q.isEmpty) return true;
            return c.name.toLowerCase().contains(q) || c.id.toLowerCase().contains(q);
          }).toList();
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = filterList();
            return SimpleDialog(
              title: const Text('Chọn môn để thêm'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm theo tên hoặc mã môn',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => query = v),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 360,
                  height: 480,
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final c = filtered[idx];
                      final meta = courseToGroup[c.id];
                      final groupName = meta != null ? meta['groupName'] as String : '';
                      final groupId = meta != null ? meta['groupId'] as String : '';
                                                final remain = groupRemaining[groupId] ?? {'req': 0, 'opt': 0};
                                                final reqRemain = remain['req'] ?? 0;
                                                final optRemain = remain['opt'] ?? 0;
                                                final typeText = c.type == CourseType.required ? 'BB' : 'TC';
                      final subtitle = c.type == CourseType.required
                          ? 'BB • Nhóm: $groupName • Còn cần BB: $reqRemain TC • TC còn: $optRemain'
                          : 'TC • Nhóm: $groupName • TC còn: $optRemain';
                      return ListTile(
                        leading: Icon(c.type == CourseType.required ? Icons.checklist_rtl : Icons.list_alt_outlined),
                        title: Text('${c.name} (${c.credits} TC)'),
                        subtitle: Text(subtitle),
                        trailing: Text(typeText),
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );

    if (selected == null) return;

    final completed = provider
        .getCoursesByStatus(CourseStatus.completed)
        .map((c) => c.id)
        .toSet();
    final validation = PlanningService().validateAddCourse(
      _plans,
      plan.id,
      selected,
      completed,
    );

    if (validation.willExceedLimit) {
      NotificationService.showSnack(context, 'Vượt giới hạn tín chỉ (${validation.currentCredits}/${validation.limit}).');
      return;
    }

    if (validation.missingPrerequisites.isNotEmpty) {
      final missing = validation.missingPrerequisites.join(', ');
      NotificationService.showSnack(context, 'Thiếu học phần tiên quyết: $missing');
    }

    setState(() {
      _plans = PlanningService().addCourse(_plans, plan.id, selected);
    });
    await _save();
  }

  Future<void> _pickAndAddCourseForGroup(
    SemesterPlan plan,
    CurriculumProvider provider, {
    required String groupId,
    required CourseType type,
  }) async {
    // Base remaining list
    final allNotStarted = provider.getCoursesByStatus(CourseStatus.notStarted);
    // Filter by group and type
    final index = _buildCourseIndex(provider);
    final courseToGroup = index['courseToGroup'] as Map<String, Map<String, Object>>;
    final plannedIds = plan.plannedCourses.map((e) => e.courseId).toSet();
    final groupRemain = _computeGroupRemaining(provider, plan);
    final targetRemain = groupRemain[groupId] ?? {'req': 0, 'opt': 0};
    final needed = type == CourseType.required ? (targetRemain['req'] ?? 0) : (targetRemain['opt'] ?? 0);
    if (needed <= 0) {
      NotificationService.showSnack(context, 'Nhóm đã đủ tín chỉ cho loại này');
      return;
    }

    final candidates = allNotStarted.where((c) {
      if (plannedIds.contains(c.id)) return false;
      final meta = courseToGroup[c.id];
      if (meta == null) return false;
      if (meta['groupId'] as String != groupId) return false;
      return c.type == type;
    }).toList();

    if (candidates.isEmpty) {
      NotificationService.showSnack(context, 'Không có môn phù hợp trong nhóm');
      return;
    }

    Course? selected = await showDialog<Course>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Chọn môn (${type == CourseType.required ? 'BB' : 'TC'})'),
          children: [
            SizedBox(
              width: 360,
              height: 420,
              child: ListView.builder(
                itemCount: candidates.length,
                itemBuilder: (context, idx) {
                  final c = candidates[idx];
                  return ListTile(
                    leading: const Icon(Icons.add),
                    title: Text('${c.name} (${c.credits} TC)'),
                    onTap: () => Navigator.pop(context, c),
                  );
                },
              ),
            )
          ],
        );
      },
    );

    if (selected == null) return;

    final completed = provider
        .getCoursesByStatus(CourseStatus.completed)
        .map((c) => c.id)
        .toSet();
    final validation = PlanningService().validateAddCourse(
      _plans,
      plan.id,
      selected,
      completed,
    );
    if (validation.willExceedLimit) {
      NotificationService.showSnack(context, 'Vượt giới hạn tín chỉ (${validation.currentCredits}/${validation.limit}).');
      return;
    }
    if (validation.missingPrerequisites.isNotEmpty) {
      final missing = validation.missingPrerequisites.join(', ');
      NotificationService.showSnack(context, 'Thiếu học phần tiên quyết: $missing');
    }
    setState(() {
      _plans = PlanningService().addCourse(_plans, plan.id, selected);
    });
    await _save();
  }

  Map<String, Map<String, int>> _computeGroupRemaining(
    CurriculumProvider provider,
    SemesterPlan plan,
  ) {
    final index = _buildCourseIndex(provider);
    final courseToGroup = index['courseToGroup'] as Map<String, Map<String, Object>>;
    final groupInfo = index['groupInfo'] as Map<String, Map<String, Object>>;

    final Map<String, int> requiredCompleted = {};
    final Map<String, int> optionalCompleted = {};
    final Map<String, int> requiredInProgress = {};
    final Map<String, int> optionalInProgress = {};
    // Accumulate current progress by type
    for (final section in provider.sections) {
      for (final group in section.courseGroups) {
        for (final c in group.courses) {
          if (c.status == CourseStatus.completed) {
            if (c.type == CourseType.required) {
              requiredCompleted[group.id] = (requiredCompleted[group.id] ?? 0) + c.credits;
            } else {
              optionalCompleted[group.id] = (optionalCompleted[group.id] ?? 0) + c.credits;
            }
          } else if (c.status == CourseStatus.inProgress) {
            if (c.type == CourseType.required) {
              requiredInProgress[group.id] = (requiredInProgress[group.id] ?? 0) + c.credits;
            } else {
              optionalInProgress[group.id] = (optionalInProgress[group.id] ?? 0) + c.credits;
            }
          }
        }
      }
    }
    // Planned credits in this semester
    for (final pc in plan.plannedCourses) {
      final meta = courseToGroup[pc.courseId];
      if (meta != null) {
        final groupId = meta['groupId'] as String;
        // Find the actual course to know its type
        final course = provider.getCourseById(pc.courseId);
        if (course != null) {
          if (course.type == CourseType.required) {
            // planned reduces remaining, but is not "in progress"
            requiredCompleted[groupId] = (requiredCompleted[groupId] ?? 0) + pc.credits;
          } else {
            optionalCompleted[groupId] = (optionalCompleted[groupId] ?? 0) + pc.credits;
          }
        }
      }
    }

    final Map<String, Map<String, int>> remaining = {};
    groupInfo.forEach((groupId, info) {
      final requiredTotal = info['requiredCredits'] as int;
      final optionalTotal = info['optionalCredits'] as int;
      final accReq = (requiredCompleted[groupId] ?? 0);
      final accOpt = (optionalCompleted[groupId] ?? 0);
      final progReq = (requiredInProgress[groupId] ?? 0);
      final progOpt = (optionalInProgress[groupId] ?? 0);
      final reqRemain = (requiredTotal - accReq).clamp(0, requiredTotal);
      final optRemain = (optionalTotal - accOpt).clamp(0, optionalTotal);
      remaining[groupId] = {
        'req': reqRemain,
        'opt': optRemain,
        'progReq': progReq,
        'progOpt': progOpt,
      };
    });
    return remaining;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await _service.loadPlans();
    setState(() {
      _plans = loaded;
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _service.savePlans(_plans);
  }

  void _addNewPlan() async {
    final now = DateTime.now();
    final term = await showDialog<String>(
      context: context,
      builder: (context) {
        String selected = 'HK1';
        int year = now.year;
        return AlertDialog(
          title: const Text('Tạo học kỳ mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selected,
                decoration: const InputDecoration(labelText: 'Học kỳ'),
                items: const [
                  DropdownMenuItem(value: 'HK1', child: Text('HK1')),
                  DropdownMenuItem(value: 'HK2', child: Text('HK2')),
                  DropdownMenuItem(value: 'Hè', child: Text('Hè')),
                ],
                onChanged: (v) => selected = v ?? 'HK1',
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: year.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Năm'),
                onChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null) year = n;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, '$selected-$year'),
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );
    if (term == null) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _plans = [
        ..._plans,
        SemesterPlan(id: id, term: term.split('-').first, year: int.parse(term.split('-').last)),
      ];
    });
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kế hoạch học tập',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewPlan,
        icon: const Icon(Icons.add),
        label: const Text('Thêm học kỳ'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<CurriculumProvider>(
              builder: (context, provider, _) {
                final allCourses = <String, String>{};
                for (final s in provider.sections) {
                  for (final g in s.courseGroups) {
                    for (final c in g.courses) {
                      allCourses[c.id] = c.name;
                    }
                  }
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  itemCount: _plans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final plan = _plans[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.school_outlined),
                                const SizedBox(width: 8),
                                Text('${plan.term} • ${plan.year}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Xóa học kỳ',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final confirm = await NotificationService.showConfirmDialog(
                                      context,
                                      title: 'Xóa học kỳ',
                                      message: 'Bạn có chắc muốn xóa học kỳ này? Hành động không thể hoàn tác.',
                                      confirmColor: Theme.of(context).colorScheme.error,
                                      confirmText: 'Xóa',
                                    );
                                    if (confirm == true) {
                                      setState(() {
                                        _plans = _plans.where((p) => p.id != plan.id).toList();
                                      });
                                      await _save();
                                      NotificationService.showSnack(context, 'Đã xóa học kỳ');
                                    }
                                  },
                                ),
                                IconButton(
                                  tooltip: 'Chỉnh sửa ghi chú/lịch',
                                  icon: const Icon(Icons.edit_note_outlined),
                                  onPressed: () async {
                                    final result = await showDialog<Map<String, String>>(
                                      context: context,
                                      builder: (context) {
                                        final noteCtrl = TextEditingController(text: plan.note ?? '');
                                        final scheduleCtrl = TextEditingController(text: plan.schedule ?? '');
                                        return AlertDialog(
                                          title: const Text('Ghi chú & Lịch học dự kiến'),
                                          content: SizedBox(
                                            width: 420,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: noteCtrl,
                                                    maxLines: 3,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Ghi chú',
                                                      alignLabelWithHint: true,
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  TextField(
                                                    controller: scheduleCtrl,
                                                    maxLines: 5,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Lịch học (dạng văn bản)',
                                                      alignLabelWithHint: true,
                                                      hintText: 'Ví dụ: T2: Lập trình C (7-9); T4: CSDL (1-3)...',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Hủy'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context, {
                                                'note': noteCtrl.text,
                                                'schedule': scheduleCtrl.text,
                                              }),
                                              child: const Text('Lưu'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _plans = PlanningService().updatePlanMeta(
                                          _plans,
                                          plan.id,
                                          note: result['note'],
                                          schedule: result['schedule'],
                                        );
                                      });
                                      await _save();
                                    }
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('${plan.totalCredits} TC'),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _pickAndAddCourse(plan, provider),
                                  icon: const Icon(Icons.add, color: Colors.white,),
                                  label: const Text('Thêm môn'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Group summary: remaining BB/TC per group (collapsible)
                            Builder(
                              builder: (context) {
                                final groupRemain = _computeGroupRemaining(provider, plan);
                                final List<Widget> rows = [];
                                for (final s in provider.sections) {
                                  for (final g in s.courseGroups) {
                                    final remain = groupRemain[g.id] ?? {'req': 0, 'opt': 0};
                                    final reqR = remain['req'] ?? 0;
                                    final optR = remain['opt'] ?? 0;
                                    final progTotal = (remain['progReq'] ?? 0) + (remain['progOpt'] ?? 0);
                                    // Show all groups, or only those with remaining > 0
                                    if (reqR > 0 || optR > 0) {
                                      rows.add(
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(g.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                                            Row(
                                              children: [
                                                InkWell(
                                                  borderRadius: BorderRadius.circular(12),
                                                  onTap: reqR > 0
                                                      ? () => _pickAndAddCourseForGroup(
                                                            plan,
                                                            provider,
                                                            groupId: g.id,
                                                            type: CourseType.required,
                                                          )
                                                      : () => NotificationService.showSnack(context, 'Nhóm đã đủ BB'),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.withOpacity(0.08),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text('BB còn: $reqR'),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                InkWell(
                                                  borderRadius: BorderRadius.circular(12),
                                                  onTap: optR > 0
                                                      ? () => _pickAndAddCourseForGroup(
                                                            plan,
                                                            provider,
                                                            groupId: g.id,
                                                            type: CourseType.optional,
                                                          )
                                                      : () => NotificationService.showSnack(context, 'Nhóm đã đủ TC'),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green.withOpacity(0.08),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text('TC còn: $optR'),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.withOpacity(0.08),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text('Đang học: $progTotal TC'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                      rows.add(const SizedBox(height: 4));
                                    }
                                  }
                                }
                                if (rows.isEmpty) return const SizedBox.shrink();
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                    ),
                                    child: ExpansionTile(
                                      shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
                                      collapsedShape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
                                      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                                      title: const Text('Tóm tắt theo nhóm', style: TextStyle(fontWeight: FontWeight.w600)),
                                      childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      children: rows,
                                    ),
                                  ),
                                );
                              },
                            ),
                            if ((plan.note?.isNotEmpty ?? false) || (plan.schedule?.isNotEmpty ?? false))
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (plan.note?.isNotEmpty ?? false) ...[
                                      const Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text(plan.note!),
                                      const SizedBox(height: 8),
                                    ],
                                    if (plan.schedule?.isNotEmpty ?? false) ...[
                                      const Text('Lịch học dự kiến', style: TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      _ScheduleTimeline(text: plan.schedule!),
                                    ],
                                  ],
                                ),
                              ),
                            if (plan.plannedCourses.isEmpty)
                              Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.grey[600], size: 18),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text('Chưa có môn nào trong kế hoạch.'),
                                  ),
                                ],
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: plan.plannedCourses.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, i) {
                                  final pc = plan.plannedCourses[i];
                                  final name = allCourses[pc.courseId] ?? pc.courseId;
                                  final indexMaps = _buildCourseIndex(provider);
                                  final courseToGroup = indexMaps['courseToGroup'] as Map<String, Map<String, Object>>;
                                  final meta = courseToGroup[pc.courseId];
                                  final groupName = meta != null ? meta['groupName'] as String : '';
                                  final groupId = meta != null ? meta['groupId'] as String : '';
                                  final groupRemain = _computeGroupRemaining(provider, plan);
                                  final remain = groupRemain[groupId] ?? {'req': 0, 'opt': 0, 'progReq': 0, 'progOpt': 0};
                                  final reqRemain = remain['req'] ?? 0;
                                  final optRemain = remain['opt'] ?? 0;
                                  final progTotal = (remain['progReq'] ?? 0) + (remain['progOpt'] ?? 0);
                                  return ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                    leading: const Icon(Icons.book_outlined),
                                    title: Text(name),
                                    subtitle: Text('TC: ${pc.credits} • Nhóm: $groupName • BB còn: $reqRemain • TC còn: $optRemain • Đang học: $progTotal TC'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () async {
                                        setState(() {
                                          _plans = PlanningService()
                                              .removeCourse(_plans, plan.id, pc.courseId);
                                        });
                                        await _save();
                                      },
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 8),

                            // Graduation impact warning (đơn giản): nếu còn > 20 TC sau học kỳ này
                            Builder(
                              builder: (context) {
                                final providerStats = provider.progressModel;
                                final remainingAfter = (providerStats.totalCredits - providerStats.completedCredits) - plan.totalCredits;
                                if (remainingAfter > 20) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Cảnh báo: Sau học kỳ này còn khoảng $remainingAfter tín chỉ. Cân nhắc tăng tín chỉ/kế hoạch.',
                                            style: const TextStyle(color: Colors.orange),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            // Recommendations
                            Builder(
                              builder: (context) {
                                final allCourses = <Course>[];
                                for (final s in provider.sections) {
                                  for (final g in s.courseGroups) {
                                    allCourses.addAll(g.courses);
                                  }
                                }
                                final completed = provider
                                    .getCoursesByStatus(CourseStatus.completed)
                                    .map((c) => c.id)
                                    .toSet();
                                final suggestions = PlanningService()
                                    .suggestNextCourses(allCourses, completed);
                                if (suggestions.isEmpty) return const SizedBox.shrink();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text('Gợi ý cho học kỳ này'),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [

                                        ...suggestions.take(4).map((c) {
                                          return ActionChip(
                                            avatar: const Icon(Icons.add, size: 16),
                                            label: Text('${c.name} (${c.credits} TC)'),
                                            onPressed: () async {
                                              final validation = PlanningService().validateAddCourse(
                                                _plans,
                                                plan.id,
                                                c,
                                                completed,
                                              );
                                              if (validation.willExceedLimit) {
                                                NotificationService.showSnack(context, 'Vượt giới hạn tín chỉ (${validation.currentCredits}/${validation.limit}).');
                                                return;
                                              }
                                              setState(() {
                                                _plans = PlanningService().addCourse(_plans, plan.id, c);
                                              });
                                              await _save();
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _ScheduleTimeline extends StatelessWidget {
  final String text;
  const _ScheduleTimeline({required this.text});

  @override
  Widget build(BuildContext context) {
    final items = text
        .split(RegExp(r'[\n;]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (items.isEmpty) {
      return Text(
        'Chưa có lịch học.',
        style: TextStyle(color: Colors.grey[600]),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final line = items[index];
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: const Icon(Icons.schedule_outlined),
          title: Text(line),
        );
      },
    );
  }
}
