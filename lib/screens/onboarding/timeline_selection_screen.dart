import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';

class TimelineSelectionScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  const TimelineSelectionScreen({
    super.key,
    required this.onSkip,
    required this.onContinue,
  });

  @override
  State<TimelineSelectionScreen> createState() => _TimelineSelectionScreenState();
}

class _TimelineSelectionScreenState extends State<TimelineSelectionScreen>
    with TickerProviderStateMixin {
  String? _selectedTimeline;
  int _currentStep = 0;
  bool _showOptions = false;
  bool _showButton = false;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _conversationSteps = [
    "By when?",
  ];

  final List<Map<String, dynamic>> _timelineOptions = [
    {
      'value': '6_months',
      'title': '6 months',
      'icon': Icons.flash_on,
      'color': Colors.grey[600],
    },
    {
      'value': '1-3_years',
      'title': '1-3 years',
      'icon': Icons.trending_up,
      'color': Colors.grey[400],
    },
    {
      'value': '5_plus_years',
      'title': '5+ years',
      'icon': Icons.emoji_events,
      'color': Colors.grey[600],
    },
  ];

  Widget _buildTimelineCard(Map<String, dynamic> option) {
    bool isSelected = _selectedTimeline == option['value'];
    
    return GestureDetector(
      onTap: () {
        _onOptionSelected(option['value']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.grey[100]
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.grey[400]!
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
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
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option['icon'],
                color: option['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['title'],
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
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
    );
  }

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

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _startConversation() {
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

  void _onOptionSelected(String value) {
    setState(() {
      _selectedTimeline = value;
    });
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
                        widthFactor: 0.95, // 95% progress
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
                    const SizedBox(height: 20),
                    
                    // Ben avatar
                    BenAvatar(
                      size: 80,
                      dotColor: Colors.white,
                      isConversational: true,
                      isAnimated: true,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Conversation
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
                    
                    const SizedBox(height: 32),
                    
                    // Timeline options
                    if (_showOptions)
                      Column(
                        children: _timelineOptions.map((option) {
                          return _buildTimelineCard(option);
                        }).toList(),
                      ),
                    
                    const SizedBox(height: 100), // Space for sticky button
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
                  onPressed: widget.onContinue,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
