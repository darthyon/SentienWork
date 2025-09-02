import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/tone_selection_card.dart';
import '../main_app_screen.dart';

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
  String? _selectedTone;
  bool _showToneSelection = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _conversationSteps = [
    "Hi, I'm Ben.",
    "I'm here to help you manage your goals, tasks, and time.",
    "How do you prefer my tone to be like?",
  ];

  final Map<String, List<String>> _toneResponses = {
    'tough': [
      "Perfect. I'll keep you accountable and push you forward.",
      "No excuses, just results. Let's get to work.",
    ],
    'caring': [
      "Wonderful! I'll be your supportive companion on this journey.",
      "Together, we'll achieve your goals with kindness and understanding.",
    ],
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _startConversation();
  }

  void _startConversation() async {
    for (int i = 0; i < _conversationSteps.length; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 500 : 2000));
      if (mounted) {
        setState(() {
          _currentStep = i;
        });
        _fadeController.reset();
        _fadeController.forward();
      }
    }
  }

  void _selectTone(String tone) {
    setState(() {
      _selectedTone = tone;
      _showToneSelection = false;
    });
    
    // Start showing tone response messages
    _showToneResponses(tone);
  }

  void _showToneResponses(String tone) {
    final responses = _toneResponses[tone] ?? [];
    
    for (int i = 0; i < responses.length; i++) {
      Timer(Duration(milliseconds: 1000 + (i * 2000)), () {
        if (mounted) {
          setState(() {
            _conversationSteps.add(responses[i]);
            _currentStep = _conversationSteps.length - 1;
          });
          _fadeController.reset();
          _fadeController.forward();
        }
      });
    }
  }

  String get _finalMessage {
    if (_selectedTone == 'tough') {
      return "Alright, let's cut to the chase. Let's generate your to-do's based on what you entered during onboarding.";
    } else {
      return "Perfect! Let's gently create your to-do's based on what you shared during onboarding.";
    }
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
                    const Spacer(flex: 2),
                    
                    // Ben avatar
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Conversation content
                    SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentStep >= 0)
                            FadeTransition(
                              opacity: _currentStep == 0 ? _fadeAnimation : const AlwaysStoppedAnimation(1.0),
                              child: Text(
                                _conversationSteps[0],
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
                          
                          if (_currentStep >= 1) ...[
                            const SizedBox(height: 24),
                            FadeTransition(
                              opacity: _currentStep == 1 ? _fadeAnimation : const AlwaysStoppedAnimation(1.0),
                              child: Text(
                                _conversationSteps[1],
                                style: GoogleFonts.dmSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                  height: 1.4,
                                  letterSpacing: 0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          
                          if (_currentStep >= 2) ...[
                            const SizedBox(height: 32),
                            FadeTransition(
                              opacity: _currentStep == 2 ? _fadeAnimation : const AlwaysStoppedAnimation(1.0),
                              child: Text(
                                _conversationSteps[2],
                                style: GoogleFonts.dmSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  height: 1.4,
                                  letterSpacing: 0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Tone selection cards (only show if no tone selected and showing tone selection)
                    if (_currentStep >= 2 && _selectedTone == null && _showToneSelection) ...[
                      const SizedBox(height: 24),
                      AnimatedOpacity(
                        opacity: _showToneSelection ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          children: [
                            Expanded(
                              child: ToneSelectionCard(
                                title: 'Tough love',
                                subtitle: 'Direct and challenging',
                                isSelected: _selectedTone == 'tough',
                                onTap: () => _selectTone('tough'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ToneSelectionCard(
                                title: 'Kind and caring',
                                subtitle: 'Supportive and gentle',
                                isSelected: _selectedTone == 'caring',
                                onTap: () => _selectTone('caring'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Show additional conversation steps after tone selection
                    if (_currentStep > 2) ...[
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          _conversationSteps[_currentStep],
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                            height: 1.4,
                            letterSpacing: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    
                    // Generate button (show after tone responses)
                    if (_selectedTone != null && _currentStep >= 4) ...[
                      const SizedBox(height: 32),
                      OnboardingButton(
                        text: 'Generate To-Do\'s',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainAppScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                    
                    const Spacer(flex: 2),
                  ],
                ),
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
