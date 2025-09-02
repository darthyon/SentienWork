import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/selection_card.dart';

class EducationCredentialsScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const EducationCredentialsScreen({
    super.key,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  State<EducationCredentialsScreen> createState() => _EducationCredentialsScreenState();
}

class _EducationCredentialsScreenState extends State<EducationCredentialsScreen> {
  String? _selectedEducationLevel;
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  bool _isFormValid = false;

  final List<String> _educationLevels = [
    'High School',
    'Diploma',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Professional Certification',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _universityController.addListener(_validateForm);
    _fieldController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _selectedEducationLevel != null && 
                    _universityController.text.isNotEmpty &&
                    _fieldController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _universityController.dispose();
    _fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: widget.onSkip,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Title
                    Row(
                      children: [
                        Text(
                          'Education background',
                          style: GoogleFonts.dmSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Why we ask this',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'This helps us tailor career advice and opportunities to your educational background.',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Got it',
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    Text(
                      'Share your educational credentials to help us understand your expertise level.',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Education Level Selection
                    Text(
                      'Highest Education Level',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Education level dropdown
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white,
                        primaryColor: Colors.grey[600],
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: Colors.grey[600],
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        dropdownColor: Colors.white,
                        items: _educationLevels.map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(
                            level,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEducationLevel = value;
                          });
                          _validateForm();
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // University/Institution Field
                    Text(
                      'University/Institution',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _universityController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Stanford University, MIT, etc.',
                        hintStyle: GoogleFonts.dmSans(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Field of Study
                    Text(
                      'Field of Study',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _fieldController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Computer Science, Business, Engineering',
                        hintStyle: GoogleFonts.dmSans(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Buttons
                    Column(
                      children: [
                        OnboardingButton(
                          text: 'Next',
                          onPressed: _isFormValid ? widget.onContinue : null,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: widget.onSkip,
                          child: Text(
                            'Do it later',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
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
