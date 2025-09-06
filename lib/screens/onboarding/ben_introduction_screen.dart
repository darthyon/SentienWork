import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../main_app_screen.dart';
import '../../utils/ben_avatar.dart';

class BenIntroductionScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onGenerateTodos;

  const BenIntroductionScreen({
    super.key,
    required this.onSkip,
    required this.onGenerateTodos,
  });

  @override
  State<BenIntroductionScreen> createState() => _BenIntroductionScreenState();
}

class _BenIntroductionScreenState extends State<BenIntroductionScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _showButton = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _conversationSteps = [
    "Hi, I'm Ben.\nYour AI companion.",
    "I'll guide you to personalise your experience with SentienWork.",
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _startConversation();
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
        setState(() {
          _currentStep++;
        });
        // Continue to next step or show button after last message
        if (_currentStep < _conversationSteps.length - 1) {
          _nextStep();
        } else {
          // After last message, show continue button
          Timer(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _showButton = true;
              });
            }
          });
        }
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
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainAppScreen(),
                      ),
                    );
                  },
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
                    const SizedBox(height: 40),
                    
                    // Ben avatar
                    BenAvatar(
                      size: 80,
                      dotColor: Colors.white,
                      isConversational: true,
                      isAnimated: true,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Conversation content with fade transitions
                    Container(
                      height: 100,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: Text(
                            _conversationSteps[_currentStep],
                            key: ValueKey<int>(_currentStep),
                            style: GoogleFonts.dmSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.3,
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                  ],
                ),
              ),
            ),
            
            // Sticky continue button at bottom
            if (_showButton)
              Padding(
                padding: const EdgeInsets.all(24),
                child: OnboardingButton(
                  text: 'Continue',
                  onPressed: widget.onGenerateTodos,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
}
