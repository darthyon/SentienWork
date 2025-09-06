import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/ask_ben_screen.dart';
import '../utils/ben_avatar.dart';

class AskBenButton extends StatefulWidget {
  const AskBenButton({super.key});

  @override
  State<AskBenButton> createState() => _AskBenButtonState();
}

class _AskBenButtonState extends State<AskBenButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _gradientAnimation;
  Timer? _gradientTimer;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Start the 60-second interval gradient animation
    _startGradientTimer();
  }

  void _startGradientTimer() {
    _gradientTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (mounted) {
        _performGradientAnimation();
      }
    });
    
    // Perform initial animation after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _performGradientAnimation();
      }
    });
  }

  void _performGradientAnimation() async {
    await _animationController.forward();
    await _animationController.reverse();
  }

  @override
  void dispose() {
    _gradientTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AskBenScreen(),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFF3B82F6), // Lighter blue (same as performance card)
                  Color(0xFF1E3A8A), // Deep blue (same as performance card)
                ],
                begin: Alignment.lerp(
                  Alignment.topLeft,
                  Alignment.bottomLeft,
                  _gradientAnimation.value,
                )!,
                end: Alignment.lerp(
                  Alignment.bottomRight,
                  Alignment.topRight,
                  _gradientAnimation.value,
                )!,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              margin: const EdgeInsets.all(1.5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Colors.black,
                        Color(0xFF1E3A8A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Colors.black,
                        Color(0xFF1E3A8A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Ask Ben',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
