import 'package:flutter/material.dart';
import '../services/program_service.dart';
import '../models/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _programService = ProgramService();
  final _formKey = GlobalKey<FormState>();
  final _englishScoreController = TextEditingController();
  final _englishRequiredScoreController = TextEditingController();
  
  Settings _currentSettings = Settings.defaultSettings();

  bool _isLoading = false;
  String _errorMessage = '';

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Future<void> _loadSettings() async {
    if (!mounted || _isLoading) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      // Load settings from service
      _currentSettings =  await _programService.getSettings();

      if (mounted) {
        setState(() {
          _englishRequiredScoreController.text = _currentSettings.englishCertType.minScore.toString();
          if (_currentSettings.englishScore != null) {
            _englishScoreController.text = _currentSettings.englishScore.toString();
          } else {
            _englishScoreController.text = '';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Lỗi khi tải cài đặt: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _englishScoreController.dispose();
    _englishRequiredScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }


  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSettings,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnglishCertificateSection(),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                child:  Text('Lưu cài đặt'),),
            ),
            const SizedBox(height: 16),
            _buildEnglishRequirementInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnglishCertificateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Điều kiện tiếng Anh',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        DropdownButtonFormField<EnglishCertType>(
          value: _currentSettings.englishCertType,
          decoration: const InputDecoration(
            labelText: 'Loại chứng chỉ',
            border: OutlineInputBorder(),
          ),
          items: EnglishCertType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.displayName),
            );
          }).toList(),
          onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _currentSettings = _currentSettings.copyWith(
                        englishCertType: value,
                      );
                      _englishRequiredScoreController.text = value.minScore.toString();
                      _englishScoreController.text = '';
                    });
                  }
                },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _englishRequiredScoreController,
          decoration: const InputDecoration(
            labelText: 'Điểm yêu cầu tối thiểu',
            helperText: 'Điểm tối thiểu cần đạt được',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập điểm yêu cầu';
            }
            if (int.tryParse(value) == null) {
              return 'Vui lòng nhập số hợp lệ';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _englishScoreController,
          decoration: InputDecoration(
            labelText: 'Điểm ${_currentSettings.englishCertType.displayName} đạt được',
            helperText: 'Điểm bạn đã đạt được (để trống nếu chưa có)',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            final score = int.tryParse(value);
            if (score == null) {
              return 'Vui lòng nhập số hợp lệ';
            }
            final requiredScore = int.tryParse(_englishRequiredScoreController.text) ?? 0;
            if (score < requiredScore) {
              return 'Điểm phải lớn hơn hoặc bằng điểm yêu cầu ($requiredScore)';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),
        if (_englishScoreController.text.isNotEmpty)
          _buildEnglishScoreStatus(),
      ],
    );
  }

  Widget _buildEnglishScoreStatus() {
    final currentScore = int.tryParse(_englishScoreController.text);
    final requiredScore = int.tryParse(_englishRequiredScoreController.text) ?? 0;
    final isPassed = currentScore != null && currentScore >= requiredScore;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isPassed ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPassed ? Colors.green : Colors.orange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPassed ? Icons.check_circle : Icons.warning,
            color: isPassed ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isPassed 
                ? 'Đã đạt yêu cầu tiếng Anh' 
                : 'Chưa đạt yêu cầu tiếng Anh',
            style: TextStyle(
              color: isPassed ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnglishRequirementInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yêu cầu chứng chỉ tiếng Anh',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sinh viên cần đạt một trong các chứng chỉ sau:',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            ...(EnglishCertType.values.map((type) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text('• ${type.displayName}: ${type.minScore} điểm trở lên'),
            ))),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newSettings = Settings(
          englishCertType: _currentSettings.englishCertType,
          englishRequiredScore: int.parse(_englishRequiredScoreController.text),
          englishScore: _englishScoreController.text.isEmpty 
              ? null 
              : int.parse(_englishScoreController.text),
        );

        await _programService.saveSettings(newSettings);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã cập nhật cài đặt thành công'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi lưu cài đặt: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
} 