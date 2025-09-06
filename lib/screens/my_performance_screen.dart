import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class MyPerformanceScreen extends StatefulWidget {
  const MyPerformanceScreen({super.key});

  @override
  State<MyPerformanceScreen> createState() => _MyPerformanceScreenState();
}

class _MyPerformanceScreenState extends State<MyPerformanceScreen> {
  String selectedPeriod = '3 months';
  final List<String> periods = ['3 months', '6 months', '1 year'];

  // AI-generated pillars based on user aspiration (Product Manager)
  final List<PillarData> pillars = [
    PillarData('Strategic Thinking', 85),
    PillarData('User Research', 72),
    PillarData('Data Analysis', 68),
    PillarData('Communication', 90),
    PillarData('Leadership', 75),
    PillarData('Technical Skills', 60),
  ];

  // Monthly distribution data
  final Map<String, List<MonthlyData>> distributionData = {
    '3 months': [
      MonthlyData('Oct', 45, 25, 15, 15),
      MonthlyData('Nov', 50, 20, 20, 10),
      MonthlyData('Dec', 40, 30, 18, 12),
    ],
    '6 months': [
      MonthlyData('Jul', 42, 28, 16, 14),
      MonthlyData('Aug', 48, 22, 18, 12),
      MonthlyData('Sep', 46, 26, 17, 11),
      MonthlyData('Oct', 45, 25, 15, 15),
      MonthlyData('Nov', 50, 20, 20, 10),
      MonthlyData('Dec', 40, 30, 18, 12),
    ],
    '1 year': [
      MonthlyData('Jan', 38, 32, 20, 10),
      MonthlyData('Feb', 41, 29, 18, 12),
      MonthlyData('Mar', 44, 26, 19, 11),
      MonthlyData('Apr', 43, 27, 17, 13),
      MonthlyData('May', 46, 24, 18, 12),
      MonthlyData('Jun', 45, 25, 16, 14),
      MonthlyData('Jul', 42, 28, 16, 14),
      MonthlyData('Aug', 48, 22, 18, 12),
      MonthlyData('Sep', 46, 26, 17, 11),
      MonthlyData('Oct', 45, 25, 15, 15),
      MonthlyData('Nov', 50, 20, 20, 10),
      MonthlyData('Dec', 40, 30, 18, 12),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'My Performance',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSpiderWebChart(),
              const SizedBox(height: 30),
              _buildDistributionChart(),
              const SizedBox(height: 30),
              _buildDistractionAnalysis(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpiderWebChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'AI Performance Analysis',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PM',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Based on your aspiration and recent activities',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: CustomPaint(
              painter: SpiderWebPainter(pillars),
              size: const Size(300, 300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Distribution',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildPeriodFilter(),
          const SizedBox(height: 20),
          _buildLegend(),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showBreakdownModal(),
            child: SizedBox(
              height: 200,
              child: CustomPaint(
                painter: DistributionChartPainter(distributionData[selectedPeriod]!),
                size: Size(MediaQuery.of(context).size.width - 80, 200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: periods.map((period) {
            final isSelected = period == selectedPeriod;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPeriod = period;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  period,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final items = [
      LegendItem('Work', Colors.black),
      LegendItem('Life', Colors.grey[400]!),
      LegendItem('Learning', Colors.grey[600]!),
      LegendItem('Distraction', Colors.red),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDistractionAnalysis() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distraction Analysis',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            'Peak Distraction Hours',
            '2:00 PM - 4:00 PM',
            'Your focus tends to dip during early afternoon. Consider scheduling lighter tasks during this time.',
            Icons.schedule,
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            'Weekly Pattern',
            'Mondays & Fridays show higher distraction',
            'Start-of-week planning and end-of-week fatigue contribute to reduced focus.',
            Icons.calendar_today,
          ),
          const SizedBox(height: 20),
          Text(
            'Key Observations',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildObservationItem('Your distraction levels have decreased by 15% compared to last month'),
          _buildObservationItem('Deep work sessions are most productive between 9-11 AM'),
          _buildObservationItem('Taking breaks every 90 minutes improves overall focus'),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.red[600], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBreakdownModal() {
    // Get current period data for modal
    final currentData = distributionData[selectedPeriod]!;
    final latestMonth = currentData.last;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.black, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${latestMonth.month} Breakdown',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Detailed breakdown of time allocation across work, personal, learning, and distraction activities for ${latestMonth.month}.',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Breakdown items
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildBreakdownItem('Work', '${latestMonth.work.toInt()}h', Colors.black),
                    _buildBreakdownItem('Personal', '${latestMonth.life.toInt()}h', Colors.grey[400]!),
                    _buildBreakdownItem('Learning', '${latestMonth.learning.toInt()}h', Colors.grey[600]!),
                    _buildBreakdownItem('Distractions', '${latestMonth.distraction.toInt()}h', Colors.red),
                    
                    const SizedBox(height: 24),
                    
                    // Summary stats
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Total Hours', '${(latestMonth.work + latestMonth.life + latestMonth.learning + latestMonth.distraction).toInt()}h'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Focus Score', '${(((latestMonth.work + latestMonth.learning) / (latestMonth.work + latestMonth.life + latestMonth.learning + latestMonth.distraction)) * 100).toInt()}%'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Productivity Rating', _getProductivityRating(latestMonth)),
                        ],
                      ),
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

  Widget _buildBreakdownItem(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _getProductivityRating(MonthlyData data) {
    final focusPercentage = ((data.work + data.learning) / (data.work + data.life + data.learning + data.distraction)) * 100;
    
    if (focusPercentage >= 75) return 'Excellent';
    if (focusPercentage >= 60) return 'Good';
    if (focusPercentage >= 45) return 'Fair';
    return 'Needs Improvement';
  }
}

class PillarData {
  final String name;
  final double value;

  PillarData(this.name, this.value);
}

class MonthlyData {
  final String month;
  final double work;
  final double life;
  final double learning;
  final double distraction;

  MonthlyData(this.month, this.work, this.life, this.learning, this.distraction);
}

class LegendItem {
  final String label;
  final Color color;

  LegendItem(this.label, this.color);
}

class SpiderWebPainter extends CustomPainter {
  final List<PillarData> pillars;

  SpiderWebPainter(this.pillars);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 40;
    
    final webPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dataPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final dataStrokePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw web circles
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * i / 5, webPaint);
    }

    // Draw web lines
    final angleStep = 2 * math.pi / pillars.length;
    for (int i = 0; i < pillars.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final endPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, webPaint);
    }

    // Draw data polygon
    final dataPath = Path();
    final dataPoints = <Offset>[];
    
    for (int i = 0; i < pillars.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final value = pillars[i].value / 100;
      final point = Offset(
        center.dx + radius * value * math.cos(angle),
        center.dy + radius * value * math.sin(angle),
      );
      dataPoints.add(point);
      
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, dataStrokePaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (final point in dataPoints) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < pillars.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final labelRadius = radius + 20;
      final labelPoint = Offset(
        center.dx + labelRadius * math.cos(angle),
        center.dy + labelRadius * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: pillars[i].name,
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DistributionChartPainter extends CustomPainter {
  final List<MonthlyData> data;

  DistributionChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = (size.width - 40) / data.length;
    final maxHeight = size.height - 40;

    for (int i = 0; i < data.length; i++) {
      final monthData = data[i];
      final x = 20 + i * barWidth;
      final total = monthData.work + monthData.life + monthData.learning + monthData.distraction;
      
      double currentY = 20;
      
      // Work (black)
      final workHeight = (monthData.work / total) * maxHeight;
      canvas.drawRect(
        Rect.fromLTWH(x + 5, currentY, barWidth - 10, workHeight),
        Paint()..color = Colors.black,
      );
      currentY += workHeight;
      
      // Life (gray)
      final lifeHeight = (monthData.life / total) * maxHeight;
      canvas.drawRect(
        Rect.fromLTWH(x + 5, currentY, barWidth - 10, lifeHeight),
        Paint()..color = Colors.grey[400]!,
      );
      currentY += lifeHeight;
      
      // Learning (dark gray)
      final learningHeight = (monthData.learning / total) * maxHeight;
      canvas.drawRect(
        Rect.fromLTWH(x + 5, currentY, barWidth - 10, learningHeight),
        Paint()..color = Colors.grey[600]!,
      );
      currentY += learningHeight;
      
      // Distraction (red)
      final distractionHeight = (monthData.distraction / total) * maxHeight;
      canvas.drawRect(
        Rect.fromLTWH(x + 5, currentY, barWidth - 10, distractionHeight),
        Paint()..color = Colors.red,
      );

      // Month label
      final textPainter = TextPainter(
        text: TextSpan(
          text: monthData.month,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, size.height - 15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
