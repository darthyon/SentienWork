import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';

class ProfessionalDetailsScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  const ProfessionalDetailsScreen({
    super.key,
    required this.onSkip,
    required this.onContinue,
  });

  @override
  State<ProfessionalDetailsScreen> createState() => _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  final _roleController = TextEditingController();
  String? _selectedIndustry;
  String? _selectedExperience;
  bool _isFormValid = false;

  final List<String> _industries = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Marketing',
    'Sales',
    'Consulting',
    'Manufacturing',
    'Retail',
    'Non-profit',
    'Government',
    'Other',
  ];

  final List<String> _experienceLevels = [
    'Entry level (0-2 years)',
    'Mid-level (3-5 years)',
    'Senior level (6-10 years)',
    'Executive level (10+ years)',
    'Student/Recent graduate',
    'Career changer',
  ];

  @override
  void initState() {
    super.initState();
    _roleController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _roleController.text.trim().isNotEmpty && 
                     _selectedIndustry != null && 
                     _selectedExperience != null;
    });
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.grey[600],
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: 'Select $label',
              hintStyle: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: Colors.black,
              letterSpacing: -0.1,
            ),
            dropdownColor: Colors.white,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
                        widthFactor: 0.75, // 75% progress
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    
                    // Title
                    Text(
                      'Your professional background',
                      style: GoogleFonts.dmSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'This information helps me understand your career context and provide relevant guidance.',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                        letterSpacing: -0.2,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Current role field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Role/Position',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _roleController,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: -0.1,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.work_outline,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintText: 'e.g. Product Manager, Software Engineer',
                              hintStyle: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Industry dropdown
                    _buildDropdownField(
                      label: 'Industry',
                      value: _selectedIndustry,
                      items: _industries,
                      onChanged: (value) {
                        setState(() {
                          _selectedIndustry = value;
                        });
                        _validateForm();
                      },
                      icon: Icons.business_outlined,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Experience level dropdown
                    _buildDropdownField(
                      label: 'Experience Level',
                      value: _selectedExperience,
                      items: _experienceLevels,
                      onChanged: (value) {
                        setState(() {
                          _selectedExperience = value;
                        });
                        _validateForm();
                      },
                      icon: Icons.timeline_outlined,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Continue button
                    OnboardingButton(
                      text: 'Continue',
                      onPressed: _isFormValid ? widget.onContinue : null,
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
