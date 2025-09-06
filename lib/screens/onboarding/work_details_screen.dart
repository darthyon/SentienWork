import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';

class WorkDetailsScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const WorkDetailsScreen({
    super.key,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  State<WorkDetailsScreen> createState() => _WorkDetailsScreenState();
}

class _WorkDetailsScreenState extends State<WorkDetailsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  String? _selectedExperience;
  bool _isLoading = false;
  bool _showFields = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _experienceOptions = [
    'Less than 1 year',
    '1-2 years',
    '3-5 years',
    '6-10 years',
    '11-15 years',
    '16+ years',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill with placeholder data
    _roleController.text = 'Product Manager';
    _companyController.text = 'Google';
    _selectedExperience = '3-5 years';
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _startSequence();
  }

  void _startSequence() {
    // Use WidgetsBinding to ensure the widget is fully built before starting animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            _fadeController.forward();
          }
        });
        Timer(const Duration(milliseconds: 3000), () {
          if (mounted) {
            setState(() {
              _showFields = true;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.stop();
    _fadeController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    return _roleController.text.trim().isNotEmpty &&
           _companyController.text.trim().isNotEmpty &&
           _selectedExperience != null;
  }

  void _handleContinue() async {
    if (!_canContinue) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      widget.onContinue();
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hintText,
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
          child: TextField(
            controller: controller,
            onChanged: (value) => setState(() {}),
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: Colors.black,
              letterSpacing: -0.1,
            ),
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
              hintText: hintText,
              hintStyle: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Years of Experience',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedExperience,
              hint: Row(
                children: [
                  Icon(
                    Icons.work_outline,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select experience level',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey[600],
              ),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedExperience = newValue;
                });
              },
              items: _experienceOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        value,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showWorkDetailsInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            'This helps me understand your career level and provide relevant advice for your professional growth.',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
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
                        widthFactor: 0.7, // 70% progress
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Ben avatar
                    BenAvatar(
                      size: 80,
                      dotColor: Colors.white,
                      isConversational: true,
                      isAnimated: true,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Conversation area
                    Center(
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Text(
                              'Let\'s review your work details.',
                              style: GoogleFonts.dmSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                height: 1.3,
                                letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Form fields with fade-in animation
                    AnimatedOpacity(
                      opacity: _showFields ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current role field
                          _buildTextField(
                            label: 'Current Role',
                            controller: _roleController,
                            icon: Icons.badge_outlined,
                            hintText: 'e.g. Product Manager, Software Engineer',
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Company field
                          _buildTextField(
                            label: 'Company',
                            controller: _companyController,
                            icon: Icons.business_outlined,
                            hintText: 'e.g. Google, Microsoft, Startup Inc.',
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Experience dropdown
                          _buildDropdown(),
                          
                          const SizedBox(height: 100), // Space for sticky button
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Sticky continue button at bottom
            Padding(
              padding: const EdgeInsets.all(24),
              child: OnboardingButton(
                text: _isLoading ? 'Processing...' : 'Continue',
                onPressed: _isLoading ? null : (_canContinue ? _handleContinue : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
