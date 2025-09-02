import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/selection_card.dart';

class JourneySelectionScreen extends StatelessWidget {
  final Function(String) onModeSelected;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final String? selectedMode;

  const JourneySelectionScreen({
    super.key,
    required this.onModeSelected,
    required this.onContinue,
    required this.onSkip,
    this.selectedMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: onSkip,
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
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
              const SizedBox(height: 20),
              
              // Text Block with larger sizes and subtext
              Column(
                children: [
                  Text(
                    'Choose how you want to begin.',
                    style: GoogleFonts.dmSans(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You can always change this later in your Settings.',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Selection Cards
              SelectionCard(
                title: 'Guided Start',
                subtitle: 'Show me the ropes.',
                isSelected: selectedMode == 'guided',
                onTap: () => onModeSelected('guided'),
              ),
              
              const SizedBox(height: 16),
              
              SelectionCard(
                title: 'Pro Mode',
                subtitle: 'I know what to do.',
                isSelected: selectedMode == 'pro',
                onTap: () => onModeSelected('pro'),
              ),
              
              const Spacer(flex: 2),
              
              // Continue Button
              if (selectedMode != null)
                OnboardingButton(
                  text: 'Continue',
                  onPressed: onContinue,
                ),
              
              const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
