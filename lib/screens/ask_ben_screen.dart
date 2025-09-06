import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/ben_avatar.dart';

class AskBenScreen extends StatefulWidget {
  const AskBenScreen({super.key});

  @override
  State<AskBenScreen> createState() => _AskBenScreenState();
}

class _AskBenScreenState extends State<AskBenScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  String? _selectedDayRating;
  String? _selectedMood;
  bool? _wantsDaySummary;
  List<String> _actionItems = [];
  String? _currentQuestion;
  bool _showOptions = false;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _optionsController;
  late Animation<double> _optionsAnimation;

  final List<String> _conversationSteps = [
    "How is your day going so far?",
    "How are you feeling today?",
    "Would you like to see a summary of what you're going to do for the day and what you should start off with?",
  ];

  final List<Map<String, dynamic>> _dayRatingOptions = [
    {'label': 'Bad', 'value': 'bad'},
    {'label': 'Could be better', 'value': 'could_be_better'},
    {'label': 'Great', 'value': 'great'},
  ];

  final List<Map<String, dynamic>> _moodOptions = [
    {'emoji': '😢', 'label': 'Very Sad', 'value': 'very_sad'},
    {'emoji': '😞', 'label': 'Sad', 'value': 'sad'},
    {'emoji': '😐', 'label': 'Neutral', 'value': 'neutral'},
    {'emoji': '😊', 'label': 'Happy', 'value': 'happy'},
    {'emoji': '😄', 'label': 'Very Happy', 'value': 'very_happy'},
  ];

  final Map<String, List<String>> _dynamicQuestions = {
    'bad': [
      "How is your day going so far?",
      "That sounds tough — days like that can really drain you.",
      "How does that make you feel?",
      "Would you like to see a summary of what you're going to do for the day and what you should start off with?",
    ],
    'could_be_better': [
      "How is your day going so far?",
      "I understand — some days just feel off, don't they?",
      "How does that make you feel?",
      "Would you like to see a summary of what you're going to do for the day and what you should start off with?",
    ],
    'great': [
      "How is your day going so far?",
      "How are you feeling today?",
      "Would you like to see a summary of what you're going to do for the day and what you should start off with?",
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
    _optionsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _optionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _optionsController, curve: Curves.easeIn),
    );
    
    _startConversation();
  }

  void _startConversation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _currentStep = 0;
        _currentQuestion = _dynamicQuestions['bad']![0];
      });
      _fadeController.forward();
      
      // Show options after question appears
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
        _optionsController.forward();
      }
    }
  }

  void _selectDayRating(String rating) {
    setState(() {
      _selectedDayRating = rating;
      _showOptions = false;
    });
    
    _optionsController.reset();
    
    // For bad/could_be_better, show empathetic response first
    if (rating == 'bad' || rating == 'could_be_better') {
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _currentStep = 1;
            _currentQuestion = _dynamicQuestions[rating]![1];
          });
          _fadeController.reset();
          _fadeController.forward();
          
          // Show the actual mood question after empathetic response
          Timer(const Duration(milliseconds: 2500), () {
            if (mounted) {
              setState(() {
                _currentStep = 2;
                _currentQuestion = _dynamicQuestions[rating]![2];
              });
              _fadeController.reset();
              _fadeController.forward();
              
              // Show mood options
              Timer(const Duration(milliseconds: 1000), () {
                if (mounted) {
                  setState(() {
                    _showOptions = true;
                  });
                  _optionsController.forward();
                }
              });
            }
          });
        }
      });
    } else {
      // For great, go directly to mood question
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _currentStep = 1;
            _currentQuestion = _dynamicQuestions[rating]![1];
          });
          _fadeController.reset();
          _fadeController.forward();
          
          Timer(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _showOptions = true;
              });
              _optionsController.forward();
            }
          });
        }
      });
    }
  }

  void _selectMood(String mood) {
    setState(() {
      _selectedMood = mood;
      _showOptions = false;
    });
    
    _optionsController.reset();
    
    // Move to day summary question after a brief delay
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        final questionIndex = _selectedDayRating == 'bad' || _selectedDayRating == 'could_be_better' ? 3 : 2;
        setState(() {
          _currentStep = questionIndex;
          _currentQuestion = _dynamicQuestions[_selectedDayRating]![questionIndex];
        });
        _fadeController.reset();
        _fadeController.forward();
        
        Timer(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _showOptions = true;
            });
            _optionsController.forward();
          }
        });
      }
    });
  }

  void _selectDaySummary(bool wants) {
    setState(() {
      _wantsDaySummary = wants;
    });
    
    if (wants) {
      // Generate sample day summary
      _generateDaySummary();
    } else {
      // Close after a brief delay
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  void _generateDaySummary() {
    setState(() {
      _actionItems = [
        'Start with your quarterly goals review',
        'Prepare key points for your boss meeting',
        'Focus on the project proposal in the afternoon',
        'End the day with some exercise',
      ];
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
                    const Spacer(flex: 2),
                    
                    // Ben avatar
                    const BenAvatar(
                      size: 64,
                      dotColor: Colors.white,
                      isConversational: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Question content
                    SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentQuestion != null)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                _currentQuestion!,
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
                        ],
                      ),
                    ),
                    
                    // Day rating selection (step 0)
                    if (_currentStep == 0 && _selectedDayRating == null && _showOptions) ...[
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _optionsAnimation,
                        child: Column(
                          children: _dayRatingOptions.map((rating) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _selectDayRating(rating['value']),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    rating['label'],
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      letterSpacing: 0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    
                    // Mood selection (step 2)
                    if (_currentStep == 2 && _selectedMood == null && _showOptions) ...[
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _optionsAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _moodOptions.map((mood) {
                            return GestureDetector(
                              onTap: () => _selectMood(mood['value']),
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        mood['emoji'],
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    mood['label'],
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    
                    // Day summary question (step 3)
                    if (_currentStep == 3 && _wantsDaySummary == null && _showOptions) ...[
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _optionsAnimation,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDaySummary(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    'Yes, please',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      letterSpacing: 0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDaySummary(false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    'No, thanks',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      letterSpacing: 0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Day summary display
                    if (_wantsDaySummary == true && _actionItems.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text(
                        'Here\'s your day at a glance:',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          itemCount: _actionItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _actionItems[index],
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        color: Colors.black,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Got it!',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
    _optionsController.dispose();
    super.dispose();
  }
}
