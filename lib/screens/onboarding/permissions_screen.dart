import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/permission_toggle.dart';

class PermissionsScreen extends StatefulWidget {
  final VoidCallback onFinishSetup;
  final VoidCallback onSkip;

  const PermissionsScreen({
    super.key,
    required this.onFinishSetup,
    required this.onSkip,
  });

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _calendarEnabled = false;
  bool _emailEnabled = false;
  bool _linkedinEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
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
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
              const SizedBox(height: 20),
              
              // Text Block with larger sizes
              Column(
                children: [
                  Text(
                    'Connect your tools.',
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
                    'To unlock the full experience, integrate your calendar, email, and LinkedIn.',
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Toggle Rows
              PermissionToggle(
                title: 'Calendar Integration',
                subtitle: 'Sync your tasks with events.',
                value: _calendarEnabled,
                onChanged: (value) {
                  setState(() {
                    _calendarEnabled = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              PermissionToggle(
                title: 'Email Integration',
                subtitle: 'Stay on top of follow-ups.',
                value: _emailEnabled,
                onChanged: (value) {
                  setState(() {
                    _emailEnabled = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              PermissionToggle(
                title: 'LinkedIn Integration',
                subtitle: 'Track career progress and opportunities.',
                value: _linkedinEnabled,
                onChanged: (value) {
                  setState(() {
                    _linkedinEnabled = value;
                  });
                },
              ),
              
              const SizedBox(height: 40),
              
              // Finish Setup Button
              OnboardingButton(
                text: 'Finish Setup',
                onPressed: widget.onFinishSetup,
              ),
              
              const SizedBox(height: 40),
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
