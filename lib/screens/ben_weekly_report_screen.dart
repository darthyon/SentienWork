import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BenWeeklyReportScreen extends StatefulWidget {
  const BenWeeklyReportScreen({super.key});

  @override
  State<BenWeeklyReportScreen> createState() => _BenWeeklyReportScreenState();
}

class _BenWeeklyReportScreenState extends State<BenWeeklyReportScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _showOptions = false;
  String? _currentMessage;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _optionsController;
  late Animation<double> _optionsAnimation;

  final List<Map<String, dynamic>> _reportSteps = [
    {
      'message': 'Let me walk you through your weekly report. This week has been quite productive!',
      'hasOptions': true,
      'options': ['Continue', 'Skip to summary']
    },
    {
      'message': 'You attended 3 meetings this week - 2 team meetings and 1 one-on-one with your boss.',
      'hasOptions': true,
      'options': ['Tell me more', 'Next section']
    },
    {
      'message': 'In those meetings, you successfully presented the quarterly roadmap and got approval for the new feature initiative. Great leadership!',
      'hasOptions': true,
      'options': ['That\'s encouraging', 'What else?']
    },
    {
      'message': 'You completed 8 out of 10 tasks this week. The completed ones included project planning, stakeholder updates, and team coordination.',
      'hasOptions': true,
      'options': ['Good progress', 'What about the incomplete ones?']
    },
    {
      'message': 'Your mood has been consistently positive this week, with an average rating of 4.2/5. You had one challenging day on Wednesday but bounced back quickly.',
      'hasOptions': true,
      'options': ['That sounds right', 'Tell me about Wednesday']
    },
    {
      'message': 'On Wednesday, you logged feeling 😞 Sad after your boss meeting. I noticed this coincided with the quarterly review discussion. Would you like some tips for handling similar situations?',
      'hasOptions': true,
      'options': ['Yes, help me improve', 'What else happened?']
    },
    {
      'message': 'Here are some strategies:\n\n• Before tough meetings, prepare 3 key wins to share\n• During the meeting, ask clarifying questions instead of assuming criticism\n• After, reflect on actionable feedback rather than dwelling on negatives',
      'hasOptions': true,
      'options': ['That\'s helpful', 'Continue with report']
    },
    {
      'message': 'Key highlights: You earned 2 new badges for "Team Collaboration" and "Goal Achievement". You also maintained your 7-day streak!',
      'hasOptions': true,
      'options': ['Awesome!', 'What\'s next?']
    },
    {
      'message': 'Now, let\'s see how you\'re progressing toward your aspiration of becoming a product manager.',
      'hasOptions': true,
      'options': ['Show me', 'I\'m curious']
    },
    {
      'message': 'Based on your activities, you\'re 68% of the way to your leadership milestone and 45% toward product management basics. You\'re on track!',
      'hasOptions': true,
      'options': ['That\'s great news', 'How can I improve?']
    },
    {
      'message': 'Would you like me to generate a PDF summary of this report for your records?',
      'hasOptions': true,
      'options': ['Yes, please', 'No, thanks']
    }
  ];

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
    _optionsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _optionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _optionsController, curve: Curves.easeIn),
    );
    
    _startReport();
  }

  void _startReport() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _currentStep = 0;
        _currentMessage = _reportSteps[0]['message'];
      });
      _fadeController.forward();
      
      // Show options after message appears
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
        _optionsController.forward();
      }
    }
  }

  void _proceedToNext() {
    setState(() {
      _showOptions = false;
    });
    _optionsController.reset();
    
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (_currentStep < _reportSteps.length - 1) {
          setState(() {
            _currentStep++;
            _currentMessage = _reportSteps[_currentStep]['message'];
          });
          _fadeController.reset();
          _fadeController.forward();
          
          Timer(const Duration(milliseconds: 1500), () {
            if (mounted) {
              setState(() {
                _showOptions = true;
              });
              _optionsController.forward();
            }
          });
        } else {
          // End of report
          _showCompletionMessage();
        }
      }
    });
  }

  void _showCompletionMessage() {
    setState(() {
      _currentMessage = 'That\'s your weekly report! Keep up the excellent work toward your goals.';
    });
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _generatePDF() {
    // TODO: Implement PDF generation
    setState(() {
      _currentMessage = 'PDF report generated! Check your downloads folder.';
    });
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _skipToSummary() {
    setState(() {
      _showOptions = false;
      _currentStep = _reportSteps.length - 2; // Go to progress comparison
      _currentMessage = _reportSteps[_currentStep]['message'];
    });
    _optionsController.reset();
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
        _optionsController.forward();
      }
    });
  }

  void _showWednesdayDetails() {
    setState(() {
      _showOptions = false;
      _currentStep = 5; // Go to Wednesday mood details
      _currentMessage = _reportSteps[5]['message'];
    });
    _optionsController.reset();
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
        _optionsController.forward();
      }
    });
  }

  void _skipMoodAdvice() {
    setState(() {
      _showOptions = false;
      _currentStep = 7; // Skip mood advice, go to highlights
      _currentMessage = _reportSteps[7]['message'];
    });
    _optionsController.reset();
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
        _optionsController.forward();
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
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    
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
                    
                    // Report content
                    Flexible(
                      flex: 3,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_currentMessage != null)
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    _currentMessage!,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      height: 1.3,
                                      letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Options
                    if (_showOptions && _currentStep < _reportSteps.length) ...[
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _optionsAnimation,
                        child: Column(
                          children: _buildOptions(),
                        ),
                      ),
                    ],
                    
                    Flexible(flex: 1, child: Container()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptions() {
    if (_currentStep >= _reportSteps.length) return [];
    
    final options = _reportSteps[_currentStep]['options'] as List<String>;
    
    return options.map((option) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            if (option == 'Skip to summary') {
              _skipToSummary();
            } else if (option == 'Yes, please') {
              _generatePDF();
            } else if (option == 'No, thanks') {
              _showCompletionMessage();
            } else if (option == 'Tell me about Wednesday') {
              _showWednesdayDetails();
            } else if (option == 'What else happened?') {
              _skipMoodAdvice();
            } else {
              _proceedToNext();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              option,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _optionsController.dispose();
    super.dispose();
  }
}
