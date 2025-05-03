import 'package:flutter/material.dart';
import '../services/program_service.dart';
import '../services/course_service.dart';
import '../models/section.dart';
import '../models/course.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // final ProgramService _programService = ProgramService();
  // final CourseService _courseService = CourseService();
  // bool _isLoading = false;
  // String _errorMessage = '';
  // List<Section>? _sections;
  // Map<String, dynamic>? _progress;
  // double _overallGPA = 0.0;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _loadData();
  //   });
  // }
  //
  // Future<void> _loadData() async {
  //   if (!mounted || _isLoading) return;
  //
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //       _errorMessage = '';
  //     });
  //
  //     // Lấy dữ liệu thực từ service
  //     final sections = await _programService.getSections();
  //
  //     // Tính toán tổng số tín chỉ
  //     final totalRequiredCredits = sections
  //         .fold(0, (sum, section) => sum + section.requiredCredits);
  //     final totalOptionalCredits = sections
  //         .fold(0, (sum, section) => sum + section.optionalCredits);
  //     final totalCredits = totalRequiredCredits + totalOptionalCredits;
  //
  //     // Tính toán số tín chỉ đã hoàn thành và đang học
  //     final completedRequiredCredits = sections
  //         .expand((s) => s.courses)
  //         .where((c) => c.status == CourseStatus.completed && c.type == CourseType.required)
  //         .fold(0, (sum, course) => sum + course.credits);
  //
  //     final completedOptionalCredits = sections
  //         .expand((s) => s.courses)
  //         .where((c) => c.status == CourseStatus.completed && c.type == CourseType.optional)
  //         .fold(0, (sum, course) => sum + course.credits);
  //
  //     final inProgressRequiredCredits = sections
  //         .expand((s) => s.courses)
  //         .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.required)
  //         .fold(0, (sum, course) => sum + course.credits);
  //
  //     final inProgressOptionalCredits = sections
  //         .expand((s) => s.courses)
  //         .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.optional)
  //         .fold(0, (sum, course) => sum + course.credits);
  //
  //     final totalCompletedCredits = completedRequiredCredits + completedOptionalCredits;
  //     final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
  //
  //     _progress = {
  //       'totalCredits': totalCredits,
  //       'completedCredits': totalCompletedCredits,
  //       'inProgressCredits': totalInProgressCredits,
  //       'remainingCredits': totalCredits - totalCompletedCredits - totalInProgressCredits,
  //       'completedRequiredCredits': completedRequiredCredits,
  //       'completedOptionalCredits': completedOptionalCredits,
  //       'inProgressRequiredCredits': inProgressRequiredCredits,
  //       'inProgressOptionalCredits': inProgressOptionalCredits,
  //       'totalRequiredCredits': totalRequiredCredits,
  //       'totalOptionalCredits': totalOptionalCredits,
  //       'overallProgress': (totalCompletedCredits / totalCredits * 100).clamp(0, 100),
  //     };
  //
  //     _sections = sections;
  //     _overallGPA = await _courseService.calculateOverallGPA();
  //
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _errorMessage = 'Lỗi khi tải dữ liệu: $e';
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiến độ học tập'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return const Center(
      child: Text('Chưa có dữ liệu'),
    );
    // if (_isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    //
    // if (_errorMessage.isNotEmpty) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(_errorMessage),
    //         const SizedBox(height: 16),
    //         ElevatedButton(
    //           onPressed: _loadData,
    //           child: const Text('Thử lại'),
    //         ),
    //       ],
    //     ),
    //   );
  //   }
  //
  //   if (_progress == null) {
  //     return const Center(child: Text('Không có dữ liệu'));
  //   }
  //
  //   return RefreshIndicator(
  //     onRefresh: _loadData,
  //     child: SingleChildScrollView(
  //       physics: const AlwaysScrollableScrollPhysics(),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             _buildOverallProgress(),
  //             const SizedBox(height: 24),
  //             _buildGPACard(),
  //             const SizedBox(height: 24),
  //             _buildCreditsSummary(),
  //             const SizedBox(height: 24),
  //             _buildSectionProgress(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildOverallProgress() {
  //   final percentage = _progress!['overallProgress'].toDouble();
  //   final completedCredits = _progress!['completedCredits'] as int;
  //   final inProgressCredits = _progress!['inProgressCredits'] as int;
  //   final totalCredits = _progress!['totalCredits'] as int;
  //
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Tiến độ tổng thể',
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           LinearProgressIndicator(
  //             value: percentage / 100,
  //             backgroundColor: Colors.grey[200],
  //             valueColor: AlwaysStoppedAnimation<Color>(
  //               percentage == 100 ? Colors.green : Colors.blue,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 '${percentage.toStringAsFixed(2)}% hoàn thành',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   color: percentage == 100 ? Colors.green : Colors.blue,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               RichText(
  //                 text: TextSpan(
  //                   style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
  //                   children: [
  //                     TextSpan(
  //                       text: '$completedCredits',
  //                       style: const TextStyle(
  //                         color: Colors.green,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     if (inProgressCredits > 0)
  //                       TextSpan(
  //                         text: ' (+$inProgressCredits)',
  //                         style: const TextStyle(
  //                           color: Colors.blue,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     TextSpan(text: '/$totalCredits tín chỉ'),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildGPACard() {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Row(
  //         children: [
  //           const Icon(Icons.school, size: 48, color: Colors.blue),
  //           const SizedBox(width: 16),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'Điểm trung bình tích lũy',
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               Text(
  //                 _overallGPA.toStringAsFixed(2),
  //                 style: const TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildCreditsSummary() {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 'Tổng quan tín chỉ',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                 decoration: BoxDecoration(
  //                   color: Colors.blue.withOpacity(0.1),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Text(
  //                   'Tổng: ${_progress!['totalCredits']} tín chỉ',
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           _buildCreditRow(
  //             'Tín chỉ bắt buộc',
  //             _progress!['completedRequiredCredits'],
  //             _progress!['inProgressRequiredCredits'],
  //             _progress!['totalRequiredCredits'],
  //             Colors.blue,
  //           ),
  //           const SizedBox(height: 12),
  //           _buildCreditRow(
  //             'Tín chỉ tự chọn',
  //             _progress!['completedOptionalCredits'],
  //             _progress!['inProgressOptionalCredits'],
  //             _progress!['totalOptionalCredits'],
  //             Colors.green,
  //           ),
  //           const Padding(
  //             padding: EdgeInsets.symmetric(vertical: 12),
  //             child: Divider(height: 1),
  //           ),
  //           _buildCreditRow(
  //             'Tổng số tín chỉ',
  //             _progress!['completedCredits'],
  //             _progress!['inProgressCredits'],
  //             _progress!['totalCredits'],
  //             Colors.purple,
  //             isTotal: true,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildCreditRow(
  //   String title,
  //   int completed,
  //   int inProgress,
  //   int total,
  //   Color color, {
  //   bool isTotal = false,
  // }) {
  //   final double progress = total > 0 ? (completed + inProgress) / total : 0;
  //   final remaining = total - completed - inProgress;
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
  //             ),
  //           ),
  //           Text(
  //             '${(progress * 100).toStringAsFixed(1)}%',
  //             style: TextStyle(
  //               color: color,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 4),
  //       LinearProgressIndicator(
  //         value: progress,
  //         backgroundColor: Colors.grey[200],
  //         valueColor: AlwaysStoppedAnimation<Color>(color),
  //       ),
  //       const SizedBox(height: 4),
  //       RichText(
  //         text: TextSpan(
  //           style: DefaultTextStyle.of(context).style.copyWith(
  //             fontSize: 13,
  //             color: Colors.grey[600],
  //           ),
  //           children: [
  //             TextSpan(
  //               text: '$completed',
  //               style: TextStyle(
  //                 color: Colors.green,
  //                 fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
  //               ),
  //             ),
  //             if (inProgress > 0)
  //               TextSpan(
  //                 text: ' (+$inProgress)',
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                   fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
  //                 ),
  //               ),
  //             TextSpan(text: '/$total tín chỉ'),
  //             if (remaining > 0)
  //               TextSpan(
  //                 text: ' • Còn thiếu: $remaining',
  //                 style: const TextStyle(
  //                   fontStyle: FontStyle.italic,
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildSectionProgress() {
  //   if (_sections == null || _sections!.isEmpty) {
  //     return const Center(child: Text('Chưa có dữ liệu khối kiến thức'));
  //   }
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Tiến độ theo khối kiến thức',
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       ...(_sections ?? []).map((section) => _buildSectionCard(section)),
  //     ],
  //   );
  // }
  //
  // Widget _buildSectionCard(Section section) {
  //   final completedRequiredCredits = section.courses
  //       .where((c) => c.status == CourseStatus.completed && c.type == CourseType.required)
  //       .fold(0, (sum, course) => sum + course.credits);
  //   final completedOptionalCredits = section.courses
  //       .where((c) => c.status == CourseStatus.completed && c.type == CourseType.optional)
  //       .fold(0, (sum, course) => sum + course.credits);
  //   final inProgressRequiredCredits = section.courses
  //       .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.required)
  //       .fold(0, (sum, course) => sum + course.credits);
  //   final inProgressOptionalCredits = section.courses
  //       .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.optional)
  //       .fold(0, (sum, course) => sum + course.credits);
  //
  //   return Card(
  //     margin: const EdgeInsets.only(bottom: 16),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             section.name,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           if (section.requiredCredits > 0)
  //             _buildCreditRow(
  //               'Bắt buộc',
  //               completedRequiredCredits,
  //               inProgressRequiredCredits,
  //               section.requiredCredits,
  //               Colors.blue,
  //             ),
  //           if (section.optionalCredits > 0) ...[
  //             const SizedBox(height: 8),
  //             _buildCreditRow(
  //               'Tự chọn',
  //               completedOptionalCredits,
  //               inProgressOptionalCredits,
  //               section.optionalCredits,
  //               Colors.green,
  //             ),
  //           ],
  //         ],
  //       ),
  //     ),
  //   );
  }
} 