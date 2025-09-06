import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';

class BackgroundAnalysisScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  const BackgroundAnalysisScreen({
    super.key,
    required this.onSkip,
    required this.onContinue,
  });

  @override
  State<BackgroundAnalysisScreen> createState() => _BackgroundAnalysisScreenState();
}

class _BackgroundAnalysisScreenState extends State<BackgroundAnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showAnalysis = false;

  final List<Map<String, dynamic>> _analysisItems = [
    {
      'title': 'Senior professional with leadership potential',
      'icon': Icons.trending_up,
      'color': Colors.grey[600],
    },
    {
      'title': 'Strong product management expertise',
      'icon': Icons.psychology,
      'color': Colors.grey[400],
    },
    {
      'title': 'Ready for strategic growth opportunities',
      'icon': Icons.lightbulb,
      'color': Colors.grey[600],
    },
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
    
    _startAnalysis();
  }

  void _startAnalysis() async {
    // Wait a moment, then show analysis
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _fadeController.forward();
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _showAnalysis = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildAnalysisCard(Map<String, dynamic> item, int index) {
    return AnimatedOpacity(
      opacity: _showAnalysis ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500 + (index * 200)),
      child: Container(
        margin: EdgeInsets.only(bottom: index < _analysisItems.length - 1 ? 16 : 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item['color'].withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item['icon'],
                color: item['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item['title'],
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.2,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                        widthFactor: 0.85, // 85% progress
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
                    
                    // Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Here\'s what I learnt about you',
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
                    
                    // Analysis cards
                    Column(
                      children: _analysisItems.asMap().entries.map((entry) {
                        return _buildAnalysisCard(entry.value, entry.key);
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Sticky continue button at bottom
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedOpacity(
                opacity: _showAnalysis ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: OnboardingButton(
                  text: 'Continue',
                  onPressed: _showAnalysis ? widget.onContinue : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
