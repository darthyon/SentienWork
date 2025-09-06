import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';

class GoalSettingScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  const GoalSettingScreen({
    super.key,
    required this.onSkip,
    required this.onContinue,
  });

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen>
    with TickerProviderStateMixin {
  final _goalController = TextEditingController(
    text: 'Advance to VP of Product within the next 2 years by leading high-impact initiatives and building strategic partnerships.'
  );
  bool _isEditing = false;
  bool _showContent = false;
  int _currentStep = 0;
  bool _showField = false;
  bool _showButton = false;
  
  late AnimationController _fadeController;
  late AnimationController _fadeOutController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeOutAnimation;

  final List<String> _conversationSteps = [
    "What's your career direction?",
  ];

  final List<String> _mockSuggestions = [
    'Advance to VP of Product within the next 2 years by leading high-impact initiatives and building strategic partnerships.',
    'Transition to senior engineering leadership role by mastering emerging technologies and building high-performing teams.',
    'Become a strategic consultant helping companies scale their operations through digital transformation and process optimization.',
  ];
  int _currentSuggestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeOutController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );
    _startConversation();
  }

  @override
  void dispose() {
    _goalController.dispose();
    _fadeController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  void _startConversation() {
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        setState(() {
          _showContent = true;
        });
        Timer(const Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              _showField = true;
            });
            Timer(const Duration(milliseconds: 400), () {
              if (mounted) {
                setState(() {
                  _showButton = true;
                });
              }
            });
          }
        });
      }
    });
  }

  void _getNewSuggestion() {
    _currentSuggestionIndex = (_currentSuggestionIndex + 1) % _mockSuggestions.length;
    setState(() {
      _goalController.text = _mockSuggestions[_currentSuggestionIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _showContent ? _fadeAnimation.value : 0.0,
              child: Column(
                children: [
                  // Progress bar and skip button
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        // Progress bar
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.9, // 90% progress
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E3A8A),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Skip button
                        GestureDetector(
                          onTap: widget.onSkip,
                          child: Text(
                            'Skip',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          
                          // Ben Avatar
                          Center(
                            child: BenAvatar(
                              size: 80,
                              dotColor: Colors.white,
                              isConversational: true,
                              isAnimated: true,
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Conversation step
                          AnimatedOpacity(
                            opacity: _showField ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              _conversationSteps[_currentStep],
                              style: GoogleFonts.dmSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                height: 1.3,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Goal input field
                          AnimatedOpacity(
                            opacity: _showField ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _isEditing 
                                      ? const Color(0xFF1E3A8A)
                                      : Colors.grey[300]!,
                                  width: _isEditing ? 2 : 1,
                                ),
                              ),
                              child: TextField(
                                controller: _goalController,
                                minLines: 3,
                                maxLines: null,
                                onTap: () {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                },
                                onTapOutside: (_) {
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Describe your career goal...',
                                  hintStyle: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Suggestion button
                          AnimatedOpacity(
                            opacity: _showButton ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            child: GestureDetector(
                              onTap: _getNewSuggestion,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                child: Text(
                                  'Get a suggestion',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 100), // Space for sticky button
                        ],
                      ),
                    ),
                  ),
                  
                  // Sticky continue button at bottom
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: OnboardingButton(
                      text: 'Continue',
                      onPressed: widget.onContinue,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
