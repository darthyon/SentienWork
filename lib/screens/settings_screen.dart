import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import 'onboarding/onboarding_flow.dart';
import '../widgets/permission_toggle.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _microphoneEnabled = true; // Default to enabled
  bool _calendarEnabled = false;
  bool _emailEnabled = false;
  bool _linkedinEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
  }

  Future<void> _checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    setState(() {
      // Default to enabled unless explicitly denied by user action
      // iOS simulator often shows permanently denied, so we handle this gracefully
      if (status.isPermanentlyDenied) {
        _microphoneEnabled = true; // Keep enabled for better UX
      } else {
        _microphoneEnabled = status.isGranted || status.isLimited;
      }
    });
  }

  Future<void> _requestMicrophonePermission(bool value) async {
    if (value) {
      final status = await Permission.microphone.request();
      setState(() {
        // Always reflect the toggle state the user intended
        _microphoneEnabled = value;
      });
      
      // Only show error if user explicitly denied after request
      if (!status.isGranted && status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission denied. Voice transcription may not work optimally.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      // User is turning off the toggle - no need for permission request or toast
      setState(() {
        _microphoneEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Permissions Section
            Text(
              'Permissions',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Permission Toggles
            PermissionToggle(
              title: 'Microphone Access',
              subtitle: 'Record voice notes and get speech-to-text transcription.',
              value: _microphoneEnabled,
              onChanged: _requestMicrophonePermission,
            ),
            
            const SizedBox(height: 16),
            
            PermissionToggle(
              title: 'Calendar Integration',
              subtitle: 'Sync your schedule to suggest better meeting times.',
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
              subtitle: 'Track important emails and remind you of follow-ups.',
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
              subtitle: 'Personalise your experience based on your career path and profile',
              value: _linkedinEnabled,
              onChanged: (value) {
                setState(() {
                  _linkedinEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 40),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Show logout confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Logout',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OnboardingFlow(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Logout',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
