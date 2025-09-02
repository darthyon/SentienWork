import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Actual Image
              SizedBox(
                height: 280,
                width: 280,
                child: Image.asset(
                  'images/img-ob-1.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Text Block with larger sizes
              Column(
                children: [
                  Text(
                    'Your career, your path.',
                    style: GoogleFonts.dmSans(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Plan long-term, manage daily tasks, and grow without judgment — all in one place.',
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                      height: 1.2,
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const Spacer(flex: 2),
              
              // Button
              OnboardingButton(
                text: 'Get Started',
                onPressed: onGetStarted,
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
