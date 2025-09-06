import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkedInIntegrationScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const LinkedInIntegrationScreen({
    super.key,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  State<LinkedInIntegrationScreen> createState() => _LinkedInIntegrationScreenState();
}

class _LinkedInIntegrationScreenState extends State<LinkedInIntegrationScreen> {
  bool _isConnecting = false;

  void _connectLinkedIn() async {
    setState(() {
      _isConnecting = true;
    });

    // Simulate connection process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isConnecting = false;
      });
      
      // Show success message
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'LinkedIn Connected!',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ll help you discover career opportunities and track your professional growth.',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onContinue();
              },
              child: Text(
                'Continue',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: widget.onSkip,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              
              const Spacer(flex: 2),
              
              // LinkedIn logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A66C2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.business_center,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Connect with LinkedIn',
                style: GoogleFonts.dmSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                'Connect your LinkedIn profile to get personalized career insights, track your professional growth, and discover opportunities that match your goals.',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Benefits list
              Column(
                children: [
                  _buildBenefitItem(
                    Icons.trending_up,
                    'Track Career Progress',
                    'Monitor your professional development and achievements',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.lightbulb_outline,
                    'Personalized Insights',
                    'Get AI-powered recommendations based on your profile',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.work_outline,
                    'Discover Opportunities',
                    'Find relevant jobs and networking connections',
                  ),
                ],
              ),
              
              const Spacer(flex: 2),
              
              // Connect button
              GestureDetector(
                onTap: _isConnecting ? null : _connectLinkedIn,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isConnecting ? Colors.grey[400] : const Color(0xFF0A66C2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: _isConnecting
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          'Connect LinkedIn',
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
              
              const SizedBox(height: 16),
              
              // Skip button
              GestureDetector(
                onTap: widget.onSkip,
                child: Text(
                  'Maybe later',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    letterSpacing: 0,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF0A66C2),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
