import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/ben_avatar.dart';

class BenWeeklyReportScreen extends StatefulWidget {
  const BenWeeklyReportScreen({super.key});

  @override
  State<BenWeeklyReportScreen> createState() => _BenWeeklyReportScreenState();
}

class _BenWeeklyReportScreenState extends State<BenWeeklyReportScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _showOptions = false;
  String? _currentMessage;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _optionsController;
  late Animation<double> _optionsAnimation;

  final List<Map<String, dynamic>> _reportSteps = [
    {
      'message': 'Let me walk you through your weekly report. This week has been quite productive!',
      'hasOptions': true,
      'options': ['Continue', 'Skip to summary']
    },
    {
      'message': 'You attended 3 meetings this week - 2 team meetings and 1 one-on-one with your boss.',
      'hasOptions': true,
      'options': ['Tell me more', 'Next section']
    },
    {
      'message': 'In those meetings, you successfully presented the quarterly roadmap and got approval for the new feature initiative. Great leadership!',
      'hasOptions': true,
      'options': ['That\'s encouraging', 'What else?']
    },
    {
      'message': 'You completed 8 out of 10 tasks this week. The completed ones included project planning, stakeholder updates, and team coordination.',
      'hasOptions': true,
      'options': ['Good progress', 'Show my performance']
    },
    {
      'message': 'Here\'s how your performance has evolved. I\'ve compared your current skills with last month.',
      'hasOptions': false,
      'showSpiderChart': true
    },
    {
      'message': 'Do you want a generated PDF of this report?',
      'hasOptions': true,
      'options': ['Yes, please', 'No, thanks']
    }
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _optionsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _optionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _optionsController, curve: Curves.easeIn),
    );
    
    _startReport();
  }

  void _startReport() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _currentStep = 0;
        _currentMessage = _reportSteps[0]['message'];
      });
      _fadeController.forward();
      
      // Show options after message appears
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
        _optionsController.forward();
      }
    }
  }

  void _proceedToNext() {
    setState(() {
      _showOptions = false;
    });
    _optionsController.reset();
    
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (_currentStep < _reportSteps.length - 1) {
          setState(() {
            _currentStep++;
            _currentMessage = _reportSteps[_currentStep]['message'];
          });
          _fadeController.reset();
          _fadeController.forward();
          
          Timer(const Duration(milliseconds: 1500), () {
            if (mounted) {
              final currentStepData = _reportSteps[_currentStep];
              if (currentStepData['hasOptions'] == true) {
                setState(() {
                  _showOptions = true;
                });
                _optionsController.forward();
              } else if (currentStepData['showSpiderChart'] == true) {
                // Show spider chart, then auto-advance after delay
                Timer(const Duration(milliseconds: 3000), () {
                  if (mounted) {
                    _nextStep();
                  }
                });
              }
            }
          });
        } else {
          // End of report
          _showCompletionMessage();
        }
      }
    });
  }

  void _nextStep() {
    setState(() {
      _showOptions = false;
    });
    _optionsController.reset();
    
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (_currentStep < _reportSteps.length - 1) {
          setState(() {
            _currentStep++;
            _currentMessage = _reportSteps[_currentStep]['message'];
          });
          _fadeController.reset();
          _fadeController.forward();
          
          Timer(const Duration(milliseconds: 1500), () {
            if (mounted) {
              final currentStepData = _reportSteps[_currentStep];
              if (currentStepData['hasOptions'] == true) {
                setState(() {
                  _showOptions = true;
                });
                _optionsController.forward();
              } else if (currentStepData['showSpiderChart'] == true) {
                // Show spider chart, then auto-advance after delay
                Timer(const Duration(milliseconds: 3000), () {
                  if (mounted) {
                    _nextStep();
                  }
                });
              }
            }
          });
        } else {
          // End of report
          _showCompletionMessage();
        }
      }
    });
  }

  void _showCompletionMessage() {
    setState(() {
      _currentMessage = 'That\'s your weekly report! Keep up the excellent work toward your goals.';
    });
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _generatePDF() {
    // TODO: Implement PDF generation
    setState(() {
      _currentMessage = 'PDF report generated! Check your downloads folder.';
    });
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _skipToSummary() {
    setState(() {
      _showOptions = false;
      _currentStep = _reportSteps.length - 3; // Go to performance comparison
      _currentMessage = _reportSteps[_currentStep]['message'];
    });
    _optionsController.reset();
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        // Show spider chart, then auto-advance
        Timer(const Duration(milliseconds: 3000), () {
          if (mounted) {
            _nextStep();
          }
        });
      }
    });
  }

  void _showWednesdayDetails() {
    setState(() {
      _showOptions = false;
      _currentStep = 5; // Go to Wednesday mood details
      _currentMessage = _reportSteps[5]['message'];
    });
    _optionsController.reset();
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showOptions = true;
        });
        _optionsController.forward();
      }
    });
  }

  void _skipMoodAdvice() {
    setState(() {
      _showOptions = false;
      _currentStep = 4; // Go to performance comparison
      _currentMessage = _reportSteps[4]['message'];
    });
    _optionsController.reset();
    _fadeController.reset();
    _fadeController.forward();
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        // Show spider chart, then auto-advance
        Timer(const Duration(milliseconds: 3000), () {
          if (mounted) {
            _nextStep();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    
                    // Ben avatar
                    const BenAvatar(
                      size: 64,
                      dotColor: Colors.white,
                      isConversational: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Report content
                    Flexible(
                      flex: 3,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_currentMessage != null)
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    _currentMessage!,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      height: 1.3,
                                      letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              
                              // Show spider chart when needed
                              if (_currentStep < _reportSteps.length && _reportSteps[_currentStep]['showSpiderChart'] == true)
                                Container(
                                  margin: const EdgeInsets.only(top: 32),
                                  height: 300,
                                  child: CustomPaint(
                                    painter: ComparisonSpiderWebPainter(),
                                    size: const Size(300, 300),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Options
                    if (_showOptions && _currentStep < _reportSteps.length) ...[
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _optionsAnimation,
                        child: Column(
                          children: _buildOptions(),
                        ),
                      ),
                    ],
                    
                    Flexible(flex: 1, child: Container()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptions() {
    if (_currentStep >= _reportSteps.length) return [];
    
    final options = _reportSteps[_currentStep]['options'] as List<String>;
    
    return options.map((option) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            if (option == 'Skip to summary') {
              _skipToSummary();
            } else if (option == 'Yes, please') {
              _generatePDF();
            } else if (option == 'No, thanks') {
              _showCompletionMessage();
            } else if (option == 'Tell me about Wednesday') {
              _showWednesdayDetails();
            } else if (option == 'What else happened?') {
              _skipMoodAdvice();
            } else {
              _proceedToNext();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              option,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _optionsController.dispose();
    super.dispose();
  }
}

class PillarData {
  final String name;
  final double value;
  
  PillarData(this.name, this.value);
}

class ComparisonSpiderWebPainter extends CustomPainter {
  ComparisonSpiderWebPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 40;
    
    // Sample data for previous and current performance
    final previousPillars = [
      PillarData('Leadership', 65),
      PillarData('Communication', 70),
      PillarData('Problem Solving', 60),
      PillarData('Time Management', 55),
      PillarData('Collaboration', 75),
    ];
    
    final currentPillars = [
      PillarData('Leadership', 80),
      PillarData('Communication', 75),
      PillarData('Problem Solving', 85),
      PillarData('Time Management', 70),
      PillarData('Collaboration', 70),
    ];
    
    final webPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw web circles
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * i / 5, webPaint);
    }

    // Draw web lines
    final angleStep = 2 * math.pi / previousPillars.length;
    for (int i = 0; i < previousPillars.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final endPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, webPaint);
    }

    // Draw previous performance (solid black line)
    final previousPath = Path();
    final previousPoints = <Offset>[];
    
    for (int i = 0; i < previousPillars.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final value = previousPillars[i].value / 100;
      final point = Offset(
        center.dx + radius * value * math.cos(angle),
        center.dy + radius * value * math.sin(angle),
      );
      previousPoints.add(point);
      
      if (i == 0) {
        previousPath.moveTo(point.dx, point.dy);
      } else {
        previousPath.lineTo(point.dx, point.dy);
      }
    }
    previousPath.close();

    final previousStrokePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(previousPath, previousStrokePaint);

    // Draw current performance (dotted colored lines)
    for (int i = 0; i < currentPillars.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final currentValue = currentPillars[i].value / 100;
      final previousValue = previousPillars[i].value / 100;
      
      final currentPoint = Offset(
        center.dx + radius * currentValue * math.cos(angle),
        center.dy + radius * currentValue * math.sin(angle),
      );
      
      final previousPoint = Offset(
        center.dx + radius * previousValue * math.cos(angle),
        center.dy + radius * previousValue * math.sin(angle),
      );
      
      // Determine color based on improvement or decline
      final isImprovement = currentValue > previousValue;
      final lineColor = isImprovement ? Colors.blue : Colors.red;
      
      final dottedPaint = Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      
      // Draw dotted line from previous to current point
      _drawDottedLine(canvas, previousPoint, currentPoint, dottedPaint);
      
      // Draw current point
      final pointPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 4, pointPaint);
    }

    // Draw previous performance points
    final previousPointPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (final point in previousPoints) {
      canvas.drawCircle(point, 4, previousPointPaint);
    }

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < previousPillars.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final labelRadius = radius + 20;
      final labelPoint = Offset(
        center.dx + labelRadius * math.cos(angle),
        center.dy + labelRadius * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: previousPillars[i].name,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();

      final textOffset = Offset(
        labelPoint.dx - textPainter.width / 2,
        labelPoint.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    
    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();
    
    for (int i = 0; i < dashCount; i++) {
      final startRatio = i * (dashWidth + dashSpace) / distance;
      final endRatio = (i * (dashWidth + dashSpace) + dashWidth) / distance;
      
      if (endRatio > 1.0) break;
      
      final dashStart = Offset.lerp(start, end, startRatio)!;
      final dashEnd = Offset.lerp(start, end, endRatio)!;
      
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
