import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/program_service.dart';
import '../models/settings.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import '../widgets/language_dropdown.dart';

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
  late final LanguageManager _languageManager;

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  @override
  void dispose() {
    _englishScoreController.dispose();
    _englishRequiredScoreController.dispose();
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
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
          _errorMessage = '${_languageManager.currentStrings.loadingSettingsError}: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageManager.currentStrings.settingsTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          LanguageDropdown(
            currentLanguageCode: _languageManager.currentLanguageCode,
            currentLanguage: _languageManager.currentLanguage,
            getLanguageFlag: _languageManager.getLanguageFlag,
            onLanguageChanged: _languageManager.changeLanguage,
          ),
        ],
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
              child: Text(_languageManager.currentStrings.retry),
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
                child: Text(_languageManager.currentStrings.saveSettings),
              ),
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
        Text(
          _languageManager.currentStrings.englishRequirements,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildCertificateTypeDropdown(),
        const SizedBox(height: 16),

        TextFormField(
          controller: _englishRequiredScoreController,
          decoration: InputDecoration(
            labelText: _languageManager.currentStrings.minimumScore,
            helperText: _languageManager.currentStrings.minimumScoreHelper,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _languageManager.currentStrings.pleaseEnterScore;
            }
            if (int.tryParse(value) == null) {
              return _languageManager.currentStrings.pleaseEnterValidNumber;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildScoreInput(),

        const SizedBox(height: 16),
        if (_englishScoreController.text.isNotEmpty)
          _buildEnglishScoreStatus(),
      ],
    );
  }

  Widget _buildCertificateTypeDropdown() {
    return DropdownButtonFormField<EnglishCertType>(
      value: _currentSettings.englishCertType,
      decoration: InputDecoration(
        labelText: _languageManager.currentStrings.certificateType,
      ),
      items: EnglishCertType.values.map((type) {
        return DropdownMenuItem<EnglishCertType>(
          value: type,
          child: Text(type.getDisplayName(_languageManager.currentStrings)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _currentSettings = _currentSettings.copyWith(
              englishCertType: value,
              englishRequiredScore: value.minScore,
            );
          });
        }
      },
    );
  }

  Widget _buildScoreInput() {
    return TextFormField(
      initialValue: _currentSettings.englishScore?.toString() ?? '',
      decoration: InputDecoration(
        labelText: '${_languageManager.currentStrings.achievedScore} (${_currentSettings.englishCertType.getDisplayName(_languageManager.currentStrings)})',
        helperText: _languageManager.currentStrings.achievedScoreHelper,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        final score = int.tryParse(value);
        if (score == null) {
          return _languageManager.currentStrings.pleaseEnterValidNumber;
        }
        if (score < _currentSettings.englishRequiredScore) {
          return _languageManager.currentStrings.scoreMustBeHigher;
        }
        return null;
      },
      onSaved: (value) {
        if (value != null && value.isNotEmpty) {
          _currentSettings = _currentSettings.copyWith(
            englishScore: int.parse(value),
          );
        }
      },
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
                ? _languageManager.currentStrings.englishPassed
                : _languageManager.currentStrings.englishNotPassed,
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
            Text(
              _languageManager.currentStrings.englishRequirementInfo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(_languageManager.currentStrings.englishRequirementDescription),
            const SizedBox(height: 8),
            _buildRequirementsInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _languageManager.currentStrings.englishRequirementInfo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(_languageManager.currentStrings.englishRequirementDescription),
        const SizedBox(height: 8),
        ...EnglishCertType.values.map((type) {
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('• ${type.getDisplayName(_languageManager.currentStrings)}: ${type.minScore} ${_languageManager.currentStrings.minimumScore}'),
          );
        }).toList(),
      ],
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
            SnackBar(
              content: Text(_languageManager.currentStrings.settingsSaved),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_languageManager.currentStrings.settingsError}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
} 