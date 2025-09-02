import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_task_screen.dart';
import '../models/task.dart';

class BenMeetingSuggestionScreen extends StatefulWidget {
  const BenMeetingSuggestionScreen({super.key});

  @override
  State<BenMeetingSuggestionScreen> createState() => _BenMeetingSuggestionScreenState();
}

class _BenMeetingSuggestionScreenState extends State<BenMeetingSuggestionScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  List<String> _suggestedActionItems = [];
  List<bool> _selectedItems = [];
  bool _showSuggestions = false;
  bool _showOptions = false;
  String? _currentQuestion;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _optionsController;
  late Animation<double> _optionsAnimation;

  final List<String> _conversationSteps = [
    "I noticed you just finished your meeting with your boss. How did it go?",
    "Based on typical boss meetings, I have some action item suggestions for you:",
  ];

  final List<String> _actionItemSuggestions = [
    "Follow up on quarterly goals discussion",
    "Prepare project status update for next week",
    "Schedule team meeting to discuss new initiatives",
    "Review and update current project timeline",
    "Send meeting summary to relevant stakeholders",
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
    
    _suggestedActionItems = _actionItemSuggestions;
    _selectedItems = List.filled(_suggestedActionItems.length, false);
    
    _startConversation();
  }

  void _startConversation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _currentStep = 0;
        _currentQuestion = _conversationSteps[0];
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

  void _proceedToSuggestions() {
    setState(() {
      _showOptions = false;
    });
    _optionsController.reset();
    
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _currentStep = 1;
          _showSuggestions = true;
          _currentQuestion = _conversationSteps[1];
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

  void _toggleActionItem(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
  }

  void _createSelectedTasks() async {
    List<Task> tasksToCreate = [];
    
    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        final task = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
          title: _suggestedActionItems[i],
          notes: 'Action item from boss meeting',
          priority: 'medium',
          timeOfDay: 'afternoon',
          date: DateTime.now(),
          isCompleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          tag: 'work',
        );
        tasksToCreate.add(task);
      }
    }
    
    // Return the created tasks to the calling screen
    Navigator.pop(context, tasksToCreate);
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
                    
                    // Question content
                    SizedBox(
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentQuestion != null)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                _currentQuestion!,
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
                    
                    // Initial response options (step 0)
                    if (_currentStep == 0 && _showOptions) ...[
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _optionsAnimation,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: _proceedToSuggestions,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    'It went well',
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
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: _proceedToSuggestions,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    'Could have been better',
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
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Action item suggestions (step 1)
                    if (_currentStep == 1 && _showSuggestions && _showOptions) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Select the action items you\'d like me to add to your tasks:',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.grey[700],
                          letterSpacing: -0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: FadeTransition(
                          opacity: _optionsAnimation,
                          child: ListView.builder(
                            itemCount: _suggestedActionItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: () => _toggleActionItem(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _selectedItems[index] ? Colors.black.withOpacity(0.05) : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedItems[index] ? Colors.black : Colors.grey[300]!,
                                        width: _selectedItems[index] ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: _selectedItems[index] ? Colors.black : Colors.transparent,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: _selectedItems[index] ? Colors.black : Colors.grey[400]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: _selectedItems[index]
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 14,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            _suggestedActionItems[index],
                                            style: GoogleFonts.dmSans(
                                              fontSize: 15,
                                              fontWeight: _selectedItems[index] ? FontWeight.w600 : FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_selectedItems.any((selected) => selected)) ...[
                        GestureDetector(
                          onTap: _createSelectedTasks,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              'Add Selected Tasks',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            'Maybe later',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                              letterSpacing: -0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    
                    const Spacer(flex: 1),
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
