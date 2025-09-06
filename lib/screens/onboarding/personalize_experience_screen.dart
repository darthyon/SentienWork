import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';

class PersonalizeExperienceScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onLinkedInSelected;
  final VoidCallback onDoLaterSelected;

  const PersonalizeExperienceScreen({
    super.key,
    required this.onSkip,
    required this.onLinkedInSelected,
    required this.onDoLaterSelected,
  });

  @override
  State<PersonalizeExperienceScreen> createState() => _PersonalizeExperienceScreenState();
}

class _PersonalizeExperienceScreenState extends State<PersonalizeExperienceScreen>
    with TickerProviderStateMixin {
  String? _selectedOption;
  int _currentStep = 0;
  bool _showOptions = false;
  bool _showButton = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _conversationSteps = [
    "How would you like to set up your profile?",
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _startSequence();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _startSequence() {
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        Timer(const Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              _showOptions = true;
            });
          }
        });
      }
    });
  }

  void _onOptionSelected() {
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
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
                        widthFactor: 0.25, // 25% progress (step 1 of 4)
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
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Ben avatar
                    BenAvatar(
                      size: 80,
                      dotColor: Colors.white,
                      isConversational: true,
                      isAnimated: true,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Conversation area
                    Center(
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Text(
                              _conversationSteps[_currentStep],
                              style: GoogleFonts.dmSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                height: 1.3,
                                letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Option cards with fade-in animation
                    AnimatedOpacity(
                      opacity: _showOptions ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          // LinkedIn option
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOption = 'linkedin';
                              });
                              _onOptionSelected();
                            },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _selectedOption == 'linkedin' 
                                  ? const Color(0xFF1E3A8A).withOpacity(0.05)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedOption == 'linkedin'
                                    ? const Color(0xFF1E3A8A)
                                    : Colors.grey[300]!,
                                width: _selectedOption == 'linkedin' ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0077B5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'in',
                                          style: TextStyle(
                                            color: Color(0xFF0077B5),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Connect with LinkedIn',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Auto-fill your profile with your professional information',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedOption == 'linkedin')
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1E3A8A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                          // Manual option
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOption = 'manual';
                              });
                              _onOptionSelected();
                            },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _selectedOption == 'manual' 
                                  ? const Color(0xFF1E3A8A).withOpacity(0.05)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedOption == 'manual'
                                    ? const Color(0xFF1E3A8A)
                                    : Colors.grey[300]!,
                                width: _selectedOption == 'manual' ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Set up manually',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'I\'ll guide you through entering your information step by step',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedOption == 'manual')
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1E3A8A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                  ],
                ),
              ),
            ),
            // Sticky continue button at bottom
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedOpacity(
                opacity: _showButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: OnboardingButton(
                  text: 'Continue',
                  onPressed: _selectedOption != null && _showButton ? () {
                    if (_selectedOption == 'linkedin') {
                      widget.onLinkedInSelected();
                    } else {
                      widget.onDoLaterSelected();
                    }
                  } : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
