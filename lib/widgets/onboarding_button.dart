import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const OnboardingButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: onPressed != null 
              ? const LinearGradient(
                  colors: [
                    Color(0xFF3B82F6), // Lighter blue
                    Color(0xFF1E3A8A), // Deep blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: onPressed == null ? Colors.grey[400] : null,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
