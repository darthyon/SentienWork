import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';

class IsThisYouScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const IsThisYouScreen({
    super.key,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  State<IsThisYouScreen> createState() => _IsThisYouScreenState();
}

class _IsThisYouScreenState extends State<IsThisYouScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;
  int _currentStep = 0;
  bool _showFields = false;
  bool _showButton = false;
  late AnimationController _fadeController;
  late AnimationController _fadeOutController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeOutAnimation;

  final List<String> _conversationSteps = [
    "Is this you?",
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate with LinkedIn data
    _nameController.text = 'John Smith';
    _selectedDate = DateTime(1990, 5, 15);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeOutController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
    );
    _startSequence();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  void _startSequence() {
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        Timer(const Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              _showFields = true;
              _showButton = true;
            });
          }
        });
      }
    });
  }

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            'We need this information to provide age-appropriate guidance and personalize your experience.',
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

  bool get _canContinue {
    return _nameController.text.trim().isNotEmpty && _selectedDate != null;
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
    bool showInfoIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (showInfoIcon) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showInfoModal(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ],
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
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
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : 'Select your date of birth',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: _selectedDate != null
                          ? Colors.black
                          : Colors.grey[400],
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
                        widthFactor: 0.6, // 60% progress
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
                            child: Column(
                              children: [
                                Text(
                                  _conversationSteps[_currentStep],
                                  style: GoogleFonts.dmSans(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    height: 1.3,
                                    letterSpacing: -0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
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
                        children: [
                          _buildTextField(
                            label: 'Full Name',
                            controller: _nameController,
                            icon: Icons.person_outline,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildDateField(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100), // Space for sticky button
                  ],
                ),
              ),
            ),
            
            // Sticky continue button at bottom
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedOpacity(
                    opacity: _showButton ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: OnboardingButton(
                      text: 'Continue',
                      onPressed: _canContinue ? _handleContinue : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
