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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Actual Image
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: Image.asset(
                        'images/img-ob-1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Text Block with larger sizes
                    Column(
                      children: [
                        Text(
                          'Your career, your path.',
                          style: GoogleFonts.dmSans(
                            fontSize: 32,
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
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                            height: 1.3,
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Button
                    OnboardingButton(
                      text: 'Get Started',
                      onPressed: onGetStarted,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Sign In button
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to sign in screen
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
