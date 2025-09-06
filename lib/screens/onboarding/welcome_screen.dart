import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/onboarding_button.dart';
import '../../utils/ben_avatar.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onGetStarted;

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _circleController;
  late AnimationController _pulseController;
  late AnimationController _buttonController;
  
  final List<Particle> _particles = [];
  final int _particleCount = 5;

  @override
  void initState() {
    super.initState();
    
    // Particle animation - faster for more dynamic movement
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    // Circle animation
    _circleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    
    // Pulse animation for Ben avatar
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // Button outline animation
    _buttonController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _initializeParticles();
    
    _particleController.repeat();
    _circleController.repeat();
    _pulseController.repeat(reverse: true);
    _buttonController.repeat(reverse: true);
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.8 + 0.2,
        opacity: random.nextDouble() * 0.8 + 0.2,
        direction: random.nextDouble() * 2 * math.pi,
        rotationSpeed: random.nextDouble() * 0.02 + 0.01,
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _circleController.dispose();
    _pulseController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.8,
            colors: [
              Color(0xFF0000E6), // Bold electric blue center
              Color(0xFF0000CC), // Darker electric blue
              Color(0xFF0000AA), // Even darker blue
              Color(0xFF000088), // Deep dark blue
              Color(0xFF000044), // Very dark blue
              Color(0xFF000011), // Almost black with blue tint
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Enhanced particle background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particles, _particleController.value),
                  size: size,
                );
              },
            ),
            
            // Concentric circles and Ben avatar - moved up and larger
            Positioned(
              top: size.height * 0.08, // Moved up from center
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: Listenable.merge([_circleController, _pulseController]),
                builder: (context, child) {
                  return SizedBox(
                    width: 400, // Increased from 300
                    height: 400,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outermost circle
                        Container(
                          width: 500,
                          height: 500,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08 + _circleController.value * 0.08),
                              width: 0.8,
                            ),
                          ),
                        ),
                        
                        // Outer circle - larger
                        Container(
                          width: 420,
                          height: 420,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.09 + _circleController.value * 0.09),
                              width: 0.8,
                            ),
                          ),
                        ),
                        
                        // Middle-outer circle
                        Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.10 + _circleController.value * 0.10),
                              width: 0.8,
                            ),
                          ),
                        ),
                        
                        // Middle circle - larger
                        Container(
                          width: 290,
                          height: 290,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.11 + _circleController.value * 0.11),
                              width: 0.8,
                            ),
                          ),
                        ),
                        
                        // Middle-inner circle
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12 + _circleController.value * 0.12),
                              width: 0.8,
                            ),
                          ),
                        ),
                        
                        // Inner circle - larger
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.13 + _circleController.value * 0.13),
                              width: 0.8,
                            ),
                          ),
                        ),
                        
                        // Innermost circle
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15 + _circleController.value * 0.15),
                              width: 0.8,
                            ),
                          ),
                        ),
                        
                        // Ben avatar with enhanced glow
                        Container(
                          width: 100 + _pulseController.value * 15, // Slightly larger
                          height: 100 + _pulseController.value * 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0000E6).withOpacity(0.4),
                                blurRadius: 25 + _pulseController.value * 15,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.15),
                                blurRadius: 50 + _pulseController.value * 25,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: const BenAvatar(size: 100),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Updated title and subtitle
                    Text(
                      'Discover your path\nwith SentienWork',
                      style: GoogleFonts.dmSans(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Unlock career insights with your AI companion',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withOpacity(0.8),
                        height: 3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // SSO Buttons with theme matching
                    Column(
                      children: [
                        // Sign in with Gmail
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement Gmail SSO
                            },
                            icon: const Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              'Sign in with Gmail',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              side: BorderSide(color: Colors.white.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Sign in with Apple ID
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement Apple ID SSO
                            },
                            icon: const Icon(
                              Icons.apple,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              'Sign in with Apple ID',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              side: BorderSide(color: Colors.white.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 60),
                    
                    
                    // Get Started button - secondary with animated gradient outline
                    AnimatedBuilder(
                      animation: _buttonController,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF0000E6).withOpacity(0.3 + _buttonController.value * 0.4),
                                const Color(0xFF0066FF).withOpacity(0.2 + _buttonController.value * 0.3),
                                const Color(0xFF0000E6).withOpacity(0.3 + _buttonController.value * 0.4),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            child: OutlinedButton(
                              onPressed: widget.onGetStarted,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'New to the app? Get Started',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double direction;
  final double rotationSpeed;
  double rotation = 0;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.direction,
    required this.rotationSpeed,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Enhanced particle movement with rotation and varying speeds
      final currentX = (particle.x * size.width + 
          (math.cos(particle.direction + animationValue * particle.rotationSpeed) * 
           particle.speed * animationValue * 80)) % size.width;
      final currentY = (particle.y * size.height + 
          (math.sin(particle.direction + animationValue * particle.rotationSpeed) * 
           particle.speed * animationValue * 80)) % size.height;
      
      // Twinkling effect
      final twinkle = math.sin(animationValue * 4 + particle.x * 10) * 0.3 + 0.7;
      paint.color = Colors.white.withOpacity(particle.opacity * twinkle);
      
      canvas.drawCircle(
        Offset(currentX, currentY),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
