import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AskBenScreen extends StatefulWidget {
  const AskBenScreen({super.key});

  @override
  State<AskBenScreen> createState() => _AskBenScreenState();
}

class _AskBenScreenState extends State<AskBenScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  String? _selectedMood;
  bool? _wantsActionItems;
  List<String> _actionItems = [];
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _conversationSteps = [
    "Hey there! How are you feeling today?",
    "I noticed you had a meeting at 11am. Do you want to create action items from it?",
  ];

  final List<Map<String, dynamic>> _moodOptions = [
    {'emoji': '😢', 'label': 'Very Sad', 'value': 'very_sad'},
    {'emoji': '😞', 'label': 'Sad', 'value': 'sad'},
    {'emoji': '😐', 'label': 'Neutral', 'value': 'neutral'},
    {'emoji': '😊', 'label': 'Happy', 'value': 'happy'},
    {'emoji': '😄', 'label': 'Very Happy', 'value': 'very_happy'},
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
    
    _startConversation();
  }

  void _startConversation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _currentStep = 0;
      });
      _fadeController.forward();
    }
  }

  void _selectMood(String mood) {
    setState(() {
      _selectedMood = mood;
    });
    
    // Move to next question after a brief delay
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentStep = 1;
        });
        _fadeController.reset();
        _fadeController.forward();
      }
    });
  }

  void _selectActionItems(bool wants) {
    setState(() {
      _wantsActionItems = wants;
    });
    
    if (wants) {
      // Generate sample action items
      _generateActionItems();
    } else {
      // Close after a brief delay
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  void _generateActionItems() {
    setState(() {
      _actionItems = [
        'Follow up with Sarah about Q4 budget',
        'Schedule design review meeting',
        'Update project timeline document',
        'Send meeting notes to stakeholders',
      ];
    });
  }

  void _addActionItem(String item) {
    setState(() {
      _actionItems.add(item);
    });
  }

  void _removeActionItem(int index) {
    setState(() {
      _actionItems.removeAt(index);
    });
  }

  void _createTasks() {
    // TODO: Convert action items to actual tasks
    Navigator.pop(context);
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
                    
                    // Question content
                    SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentStep >= 0)
                            FadeTransition(
                              opacity: _fadeAnimation,
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
                            ),
                        ],
                      ),
                    ),
                    
                    // Mood selection (step 0)
                    if (_currentStep == 0 && _selectedMood == null) ...[
                      const SizedBox(height: 24),
                      Row(
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
                    ],
                    
                    // Action items question (step 1)
                    if (_currentStep == 1 && _wantsActionItems == null) ...[
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectActionItems(true),
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
                              onTap: () => _selectActionItems(false),
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
                    ],
                    
                    // Action items list
                    if (_wantsActionItems == true && _actionItems.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text(
                        'Here are the action items I found:',
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
                                  GestureDetector(
                                    onTap: () => _removeActionItem(index),
                                    child: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red[400],
                                      size: 20,
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
                        onTap: _createTasks,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Create Tasks',
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
    super.dispose();
  }
}
