import 'package:flutter/material.dart';
import '../../../../core/navigation/app_router.dart';
import '../../domain/checklist_models.dart';
import '../../domain/checklist_service.dart';
import '../../domain/grad_profile_models.dart';
import '../../domain/grad_profile_service.dart';
import '../../../../core/services/dialog_service.dart';

class GraduationPage extends StatefulWidget {
  const GraduationPage({super.key});

  @override
  State<GraduationPage> createState() => _GraduationPageState();
}

class _GraduationPageState extends State<GraduationPage> {
  final GraduationChecklistService _service = GraduationChecklistService();
  GraduationChecklist? _data;
  bool _loading = true;

  final GraduationProfileService _profileService = GraduationProfileService();
  GraduationProfile? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await _service.load();
    final p = await _profileService.load();
    setState(() {
      _data = d;
      _profile = p;
      _loading = false;
    });
  }

  Future<void> _toggleItem(String id, bool value) async {
    if (_data == null) return;
    final items = _data!.items
        .map((e) => e.id == id ? e.copyWith(completed: value) : e)
        .toList();
    final updated = _data!.copyWith(items: items);
    setState(() => _data = updated);
    await _service.save(updated);
  }

  Future<void> _addItem() async {
    final res = await DialogService.showAddTextWithNoteDialog(
      context: context,
      title: 'Thêm mục checklist',
      titleLabel: 'Nội dung',
      noteLabel: 'Ghi chú (tuỳ chọn)',
      confirmText: 'Thêm',
      cancelText: 'Hủy',
    );
    if (res == null || res['title']!.trim().isEmpty) return;
    final item = GraduationChecklistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: res['title']!.trim(),
      note: (res['note']!.trim().isEmpty) ? null : res['note']!.trim(),
    );
    final updated = _data!.copyWith(items: [..._data!.items, item]);
    setState(() => _data = updated);
    await _service.save(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checklist tốt nghiệp',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: _addItem,
            tooltip: 'Thêm mục',
          ),
        ],
      ),
      body: _loading || _data == null || _profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language proficiency
                  Text('Chuẩn ngoại ngữ', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _profile!.language.metRequirement,
                          onChanged: (v) async {
                            final updated = _profile!.copyWith(
                              language: _profile!.language.copyWith(
                                metRequirement: v ?? false,
                              ),
                            );
                            setState(() => _profile = updated);
                            await _profileService.save(updated);
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: _profile!.language.level,
                            decoration: const InputDecoration(
                              labelText: 'Mức độ/Chứng chỉ (vd: IELTS 6.5, B1)',
                            ),
                            onChanged: (t) async {
                              final updated = _profile!.copyWith(
                                language: _profile!.language.copyWith(level: t),
                              );
                              setState(() => _profile = updated);
                              await _profileService.save(updated);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Certificates
                  Row(
                    children: [
                      Text('Chứng chỉ', style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final res = await DialogService.showAddTextWithNoteDialog(
                            context: context,
                            title: 'Thêm chứng chỉ',
                            titleLabel: 'Tên chứng chỉ',
                            noteLabel: 'Ghi chú (tuỳ chọn)'
                          );
                          if (res == null || res['title']!.trim().isEmpty) return;
                          final entry = CertificateEntry(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: res['title']!.trim(),
                            note: (res['note']!.trim().isEmpty) ? null : res['note']!.trim(),
                          );
                          final updated = _profile!.copyWith(
                            certificates: [..._profile!.certificates, entry],
                          );
                          setState(() => _profile = updated);
                          await _profileService.save(updated);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_profile!.certificates.isEmpty)
                    Text('Chưa có chứng chỉ.', style: TextStyle(color: Colors.grey[600]))
                  else
                    ..._profile!.certificates.map((c) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.badge_outlined),
                            title: Text(c.title),
                            subtitle: c.note != null ? Text(c.note!) : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final updated = _profile!.copyWith(
                                  certificates: _profile!.certificates
                                      .where((e) => e.id != c.id)
                                      .toList(),
                                );
                                setState(() => _profile = updated);
                                await _profileService.save(updated);
                              },
                            ),
                          ),
                        )),

                  const SizedBox(height: 16),

                  // Timeline
                  Row(
                    children: [
                      Text('Timeline chuẩn bị', style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final res = await DialogService.showAddTextWithNoteDialog(
                            context: context,
                            title: 'Thêm mốc thời gian',
                            titleLabel: 'Ngày (yyyy-MM-dd)',
                            noteLabel: 'Nội dung',
                            confirmText: 'Thêm',
                          );
                          if (res == null || res['title']!.trim().isEmpty) return;
                          final entry = TimelineEntry(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            dateIso: res['title']!.trim(),
                            note: res['note']!.trim(),
                          );
                          final updated = _profile!.copyWith(
                            timeline: [..._profile!.timeline, entry],
                          );
                          setState(() => _profile = updated);
                          await _profileService.save(updated);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_profile!.timeline.isEmpty)
                    Text('Chưa có timeline.', style: TextStyle(color: Colors.grey[600]))
                  else
                    Column(
                      children: _profile!.timeline
                          .map((t) => Card(
                                child: ListTile(
                                  leading: const Icon(Icons.event_note_outlined),
                                  title: Text(t.dateIso),
                                  subtitle: Text(t.note),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      final updated = _profile!.copyWith(
                                        timeline: _profile!.timeline
                                            .where((e) => e.id != t.id)
                                            .toList(),
                                      );
                                      setState(() => _profile = updated);
                                      await _profileService.save(updated);
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                  const SizedBox(height: 16),

                  // Checklist section header
                  Text('Checklist điều kiện', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = _data!.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: item.completed,
                              onChanged: (v) => _toggleItem(item.id, v ?? false),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      decoration: item.completed
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      color: item.completed
                                          ? Colors.grey
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  if (item.note != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.note!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemCount: _data!.items.length,
                  ),
                ],
              ),
            ),
    );
  }
}
