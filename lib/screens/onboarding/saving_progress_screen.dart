import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/ben_avatar.dart';

class SavingProgressScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SavingProgressScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<SavingProgressScreen> createState() => _SavingProgressScreenState();
}

class _SavingProgressScreenState extends State<SavingProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _fadeController;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _startSaving();
  }

  void _startSaving() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _progressController.forward();
    
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Ben avatar
              FadeTransition(
                opacity: _fadeAnimation,
                child: BenAvatar(
                  size: 80,
                  dotColor: Colors.white,
                  isConversational: true,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Saving your details',
                  style: GoogleFonts.dmSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 16),
              
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'I\'m processing your information to create a personalized experience just for you.',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Progress indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 200,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1E3A8A),
                                Color(0xFF3B82F6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Progress text
              FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    String progressText = 'Getting started...';
                    if (_progressAnimation.value > 0.3) {
                      progressText = 'Analyzing your profile...';
                    }
                    if (_progressAnimation.value > 0.6) {
                      progressText = 'Creating recommendations...';
                    }
                    if (_progressAnimation.value > 0.9) {
                      progressText = 'Almost ready!';
                    }
                    
                    return Text(
                      progressText,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.grey[500],
                        letterSpacing: -0.1,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
