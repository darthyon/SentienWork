import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class BenAvatar extends StatefulWidget {
  final double size;
  final Color? backgroundColor;
  final Color? dotColor;
  final bool isConversational;
  final bool isAnimated;
  
  const BenAvatar({
    super.key,
    this.size = 48,
    this.backgroundColor,
    this.dotColor,
    this.isConversational = false,
    this.isAnimated = true,
  });

  @override
  State<BenAvatar> createState() => _BenAvatarState();
}

class _BenAvatarState extends State<BenAvatar>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  Timer? _blinkTimer;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _blinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));
    
    _startRandomBlinking();
  }

  void _startRandomBlinking() {
    if (widget.isAnimated) {
      _scheduleNextBlink();
    }
  }

  void _scheduleNextBlink() {
    // Random interval between 2-6 seconds
    final nextBlinkDelay = Duration(
      milliseconds: 2000 + _random.nextInt(4000),
    );
    
    _blinkTimer?.cancel();
    _blinkTimer = Timer(nextBlinkDelay, () {
      if (mounted) {
        _performBlink();
      }
    });
  }

  void _performBlink() async {
    await _blinkController.forward();
    await _blinkController.reverse();
    _scheduleNextBlink();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (widget.backgroundColor ?? Colors.black).withOpacity(0.8),
            widget.backgroundColor ?? Colors.black,
            (widget.backgroundColor ?? Colors.black).withOpacity(0.9),
          ],
        ),
        boxShadow: widget.isConversational ? [
          BoxShadow(
            color: (widget.backgroundColor ?? Colors.black).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: (widget.backgroundColor ?? Colors.black).withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: widget.isAnimated ? AnimatedBuilder(
        animation: _blinkAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: BenFacePainter(
              dotOpacity: _blinkAnimation.value,
              dotColor: widget.dotColor ?? Colors.white,
              size: widget.size,
            ),
          );
        },
      ) : CustomPaint(
        painter: BenFacePainter(
          dotOpacity: 1.0,
          dotColor: widget.dotColor ?? Colors.white,
          size: widget.size,
        ),
      ),
    );
  }
}

class BenFacePainter extends CustomPainter {
  final double dotOpacity;
  final Color dotColor;
  final double size;

  BenFacePainter({
    required this.dotOpacity,
    required this.dotColor,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final dotRadius = size * 0.06; // Responsive dot size
    final eyeSpacing = size * 0.15; // Responsive eye spacing - closer together
    final eyeHeight = size * 0.15; // Position eyes slightly above center
    
    final dotPaint = Paint()
      ..color = dotColor.withOpacity(dotOpacity)
      ..style = PaintingStyle.fill;

    // Left eye (dot)
    canvas.drawCircle(
      Offset(center.dx - eyeSpacing, center.dy - eyeHeight),
      dotRadius,
      dotPaint,
    );

    // Right eye (dot)
    canvas.drawCircle(
      Offset(center.dx + eyeSpacing, center.dy - eyeHeight),
      dotRadius,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is BenFacePainter &&
        (oldDelegate.dotOpacity != dotOpacity ||
         oldDelegate.dotColor != dotColor ||
         oldDelegate.size != size);
  }
}
