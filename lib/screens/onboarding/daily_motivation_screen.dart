import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';

class DailyMotivationScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const DailyMotivationScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<DailyMotivationScreen> createState() => _DailyMotivationScreenState();
}

class _DailyMotivationScreenState extends State<DailyMotivationScreen> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    // Delay showing the button for fade-in effect
    Future.delayed(const Duration(milliseconds: 1500), () {
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
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 3),
              
              // Content centered vertically
              Column(
                children: [
                  // Main heading
                  Text(
                    'Today is the day. Be the boss of your life.',
                    style: GoogleFonts.dmSans(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtext
                  Text(
                    'Words to motivate you',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Body description
                  Text(
                    'Every moment is a fresh start. Take control of your decisions and shape the day ahead with intention and purpose.',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      height: 1.4,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const Spacer(flex: 2),
              
              // Start my day button with fade-in animation
              AnimatedOpacity(
                opacity: _showButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: GestureDetector(
                  onTap: _showButton ? widget.onContinue : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Start my day',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ),
              
              const Spacer(flex: 1),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
