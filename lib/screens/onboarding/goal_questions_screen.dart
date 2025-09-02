import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/selection_card.dart';

class GoalQuestionsScreen extends StatefulWidget {
  final String mode;
  final Function(Map<String, String>) onAnswersSubmitted;
  final VoidCallback onContinue;

  const GoalQuestionsScreen({
    super.key,
    required this.mode,
    required this.onAnswersSubmitted,
    required this.onContinue,
  });

  @override
  State<GoalQuestionsScreen> createState() => _GoalQuestionsScreenState();
}

class _GoalQuestionsScreenState extends State<GoalQuestionsScreen> {
  int _currentStep = 0;
  
  // Step 1: Direction
  String? _selectedDirection;
  final TextEditingController _customDirectionController = TextEditingController();
  
  // Step 2: Timeline
  String? _selectedTimeframe;
  DateTime? _customDate;
  
  // Step 3: Age
  String? _selectedAge;
  
  // Step 4: Role/Industry
  String? _selectedRole;
  final TextEditingController _customRoleController = TextEditingController();
  
  final List<String> _directionOptions = [
    'Become a manager',
    'Improve skills',
    'Find a new role',
    'Build confidence',
    'Something Else'
  ];
  
  final List<String> _timeframeOptions = [
    '3 months',
    '6 months',
    '12 months',
    'No specific timeframe'
  ];
  
  final List<String> _ageOptions = [
    'Under 18',
    '18–24',
    '25–34',
    '35–44',
    '45–54',
    '55+'
  ];
  
  final List<String> _roleOptions = [
    'IT',
    'Finance',
    'Design',
    'Marketing',
    'Education',
    'Healthcare',
    'Something Else'
  ];
  
  String get _currentTitle {
    switch (_currentStep) {
      case 0:
        return 'Let\'s set your direction.';
      case 1:
        return 'By when?';
      case 2:
        return 'What\'s your age?';
      case 3:
        return 'Role / Industry';
      default:
        return 'Let\'s set your direction.';
    }
  }
  
  bool get _canContinue {
    switch (_currentStep) {
      case 0:
        return _selectedDirection != null && 
               (_selectedDirection != 'Something Else' || _customDirectionController.text.trim().isNotEmpty);
      case 1:
        return _selectedTimeframe != null || _customDate != null;
      case 2:
        return _selectedAge != null;
      case 3:
        return _selectedRole != null && 
               (_selectedRole != 'Something Else' || _customRoleController.text.trim().isNotEmpty);
      default:
        return false;
    }
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('Cancel', style: GoogleFonts.dmSans()),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text('Done', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _customDate ?? DateTime.now().add(const Duration(days: 365)),
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
                  onDateTimeChanged: (date) {
                    _customDate = date;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (!_canContinue) return;
    
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Final step - submit all answers
      Map<String, String> answers = {
        'direction': _selectedDirection == 'Something Else' 
            ? _customDirectionController.text.trim() 
            : _selectedDirection!,
        'timeframe': _selectedTimeframe ?? 'Custom: ${_customDate!.toIso8601String()}',
        'age': _selectedAge!,
        'role': _selectedRole == 'Something Else' 
            ? _customRoleController.text.trim() 
            : _selectedRole!,
      };
      
      widget.onAnswersSubmitted(answers);
      widget.onContinue();
    }
  }

  String get _imagePath {
    return widget.mode == 'guided' ? 'images/img-ob-guided.png' : 'images/img-ob-power.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: widget.onContinue,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
              const SizedBox(height: 20),
              
              // Dynamic Image based on mode
              SizedBox(
                height: 180,
                width: 180,
                child: Image.asset(
                  _imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Text Block with larger size
              Text(
                _currentTitle,
                style: GoogleFonts.dmSans(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Dynamic content based on current step
              Expanded(
                child: SingleChildScrollView(
                  child: _buildStepContent(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Continue Button
              OnboardingButton(
                text: _currentStep == 3 ? 'Continue' : 'Next',
                onPressed: _canContinue ? _handleContinue : null,
              ),
              
              const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDirectionStep();
      case 1:
        return _buildTimeframeStep();
      case 2:
        return _buildAgeStep();
      case 3:
        return _buildRoleStep();
      default:
        return _buildDirectionStep();
    }
  }
  
  Widget _buildDirectionStep() {
    return Column(
      children: [
        ..._directionOptions.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SelectionCard(
            title: option,
            isSelected: _selectedDirection == option,
            onTap: () {
              setState(() {
                _selectedDirection = option;
              });
            },
          ),
        )),
        if (_selectedDirection == 'Something Else') ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _customDirectionController,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Please specify...',
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildTimeframeStep() {
    return Column(
      children: [
        ..._timeframeOptions.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SelectionCard(
            title: option,
            isSelected: _selectedTimeframe == option,
            onTap: () {
              setState(() {
                _selectedTimeframe = option;
                _customDate = null; // Clear custom date if selecting preset
              });
            },
          ),
        )),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _showDatePicker();
            setState(() {
              _selectedTimeframe = null; // Clear preset if selecting custom date
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: _customDate != null ? Colors.blue[50] : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _customDate != null ? Colors.blue[300]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _customDate != null 
                        ? 'Custom: ${_customDate!.day}/${_customDate!.month}/${_customDate!.year}'
                        : 'Pick a custom date',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: _customDate != null ? Colors.blue[700] : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: _customDate != null ? Colors.blue[700] : Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAgeStep() {
    return Column(
      children: _ageOptions.map((option) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SelectionCard(
          title: option,
          isSelected: _selectedAge == option,
          onTap: () {
            setState(() {
              _selectedAge = option;
            });
          },
        ),
      )).toList(),
    );
  }
  
  Widget _buildRoleStep() {
    return Column(
      children: [
        ..._roleOptions.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SelectionCard(
            title: option,
            isSelected: _selectedRole == option,
            onTap: () {
              setState(() {
                _selectedRole = option;
              });
            },
          ),
        )),
        if (_selectedRole == 'Something Else') ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _customRoleController,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Please specify your role/industry...',
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _customDirectionController.dispose();
    _customRoleController.dispose();
    super.dispose();
  }
}
