import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';

class LinkedInMockScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  const LinkedInMockScreen({
    super.key,
    required this.onSkip,
    required this.onContinue,
  });

  @override
  State<LinkedInMockScreen> createState() => _LinkedInMockScreenState();
}

class _LinkedInMockScreenState extends State<LinkedInMockScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _showButton = false;
  late AnimationController _fadeController;
  late AnimationController _fadeOutController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeOutAnimation;

  final List<String> _conversationSteps = [
    "Great! You've successfully connected your LinkedIn.",
    "Let's review everything.",
  ];

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
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
    );
    _startConversation();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  void _startConversation() {
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        _nextStep();
      }
    });
  }

  void _nextStep() {
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted && _currentStep < _conversationSteps.length - 1) {
        _fadeOutController.forward().then((_) {
          if (mounted) {
            setState(() {
              _currentStep++;
            });
            _fadeOutController.reset();
            _fadeController.reset();
            _fadeController.forward();
            _nextStep();
          }
        });
      } else if (mounted && _currentStep == _conversationSteps.length - 1) {
        // Show button after last message
        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _showButton = true;
            });
          }
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
                        widthFactor: 0.5, // 50% progress (step 2 of 4)
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Ben Avatar
                    BenAvatar(
                      size: 80,
                      dotColor: Colors.white,
                      isConversational: true,
                      isAnimated: true,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Conversation area
                    Container(
                      constraints: const BoxConstraints(minHeight: 200),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _fadeOutAnimation,
                          builder: (context, child) {
                            return AnimatedBuilder(
                              animation: _fadeAnimation,
                              builder: (context, child) {
                                double opacity = _fadeOutAnimation.value == 1.0
                                    ? _fadeAnimation.value
                                    : _fadeOutAnimation.value;
                                
                                return Opacity(
                                  opacity: opacity,
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
                            );
                          },
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
              child: AnimatedOpacity(
                opacity: _showButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: OnboardingButton(
                  text: 'Continue',
                  onPressed: _showButton ? widget.onContinue : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
