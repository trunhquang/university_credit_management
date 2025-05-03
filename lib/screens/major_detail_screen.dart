import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/language_manager.dart';
import '../models/major.dart';

class MajorDetailScreen extends StatefulWidget {
  final Major major;

  const MajorDetailScreen({
    super.key,
    required this.major,
  });

  @override
  State<MajorDetailScreen> createState() => _MajorDetailScreenState();
}

class _MajorDetailScreenState extends State<MajorDetailScreen> {
  void _showAddSectionDialog() {
    final languageManager = context.read<LanguageManager>();
    final strings = languageManager.currentStrings;
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.addSection),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: strings.sectionName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                widget.major.addSection(nameController.text);
                Navigator.pop(context);
              }
            },
            child: Text(strings.save),
          ),
        ],
      ),
    );
  }

  void _showAddSubsectionDialog() {
    final languageManager = context.read<LanguageManager>();
    final strings = languageManager.currentStrings;
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.addSubsection),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: strings.subsectionName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                widget.major.addSubsection(nameController.text);
                Navigator.pop(context);
              }
            },
            child: Text(strings.save),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog() {
    final languageManager = context.read<LanguageManager>();
    final strings = languageManager.currentStrings;
    final nameController = TextEditingController();
    final creditsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.addCourse),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: strings.courseName,
              ),
            ),
            TextField(
              controller: creditsController,
              decoration: InputDecoration(
                labelText: strings.credits,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && creditsController.text.isNotEmpty) {
                widget.major.addCourse(
                  nameController.text,
                  int.parse(creditsController.text),
                );
                Navigator.pop(context);
              }
            },
            child: Text(strings.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageManager = context.watch<LanguageManager>();
    final strings = languageManager.currentStrings;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.major.name),
      ),
      body: ListView(
        children: [
          if (widget.major.description.isNotEmpty)
            ListTile(
              title: const Text('Description'),
              subtitle: Text(widget.major.description),
            ),
          ListTile(
            title: Text(strings.totalCredits),
            subtitle: Text('${widget.major.totalCredits}'),
          ),
          ListTile(
            title: Text(strings.requiredCredits),
            subtitle: Text('${widget.major.requiredCredits}'),
          ),
          ListTile(
            title: Text(strings.completedCredits),
            subtitle: Text('${widget.major.completedCredits}'),
          ),
          ListTile(
            title: Text(strings.remainingCredits),
            subtitle: Text('${widget.major.remainingCredits}'),
          ),
          ListTile(
            title: Text(strings.progressText),
            subtitle: LinearProgressIndicator(
              value: widget.major.progress,
            ),
          ),
          ...widget.major.sections.map((section) => ExpansionTile(
                title: Text(section.name),
                children: [
                  ...section.subsections.map((subsection) => ExpansionTile(
                        title: Text(subsection.name),
                        children: [
                          ...subsection.courses.map((course) => ListTile(
                                title: Text(course.name),
                                subtitle: Text('${strings.credits}: ${course.credits}'),
                                trailing: Checkbox(
                                  value: course.isCompleted,
                                  onChanged: (value) {
                                    course.toggleCompleted();
                                  },
                                ),
                              )),
                        ],
                      )),
                ],
              )),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showAddSectionDialog,
            child: const Icon(Icons.add),
            tooltip: strings.addSection,
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _showAddSubsectionDialog,
            child: const Icon(Icons.add),
            tooltip: strings.addSubsection,
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _showAddCourseDialog,
            child: const Icon(Icons.add),
            tooltip: strings.addCourse,
          ),
        ],
      ),
    );
  }
} 