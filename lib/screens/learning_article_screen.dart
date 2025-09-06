import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LearningArticleScreen extends StatefulWidget {
  final Map<String, dynamic> resource;

  const LearningArticleScreen({super.key, required this.resource});

  @override
  State<LearningArticleScreen> createState() => _LearningArticleScreenState();
}

class _LearningArticleScreenState extends State<LearningArticleScreen> {
  String? _feedbackGiven;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Article',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop&crop=center',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.resource['title'],
                    style: GoogleFonts.dmSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Badges
                  Row(
                    children: [
                      _buildLevelChip(widget.resource['level']),
                      const SizedBox(width: 8),
                      _buildTypeChip(widget.resource['type']),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Article Content
                  _buildArticleContent(),
                  
                  const SizedBox(height: 32),
                  
                  // Feedback Section
                  _buildFeedbackSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leading remote teams has become a critical skill in today\'s distributed work environment. Success requires a fundamental shift in how we approach management, communication, and team building.',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        
        Text(
          'Building Trust in Virtual Environments',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        Text(
          'Trust is the foundation of any successful remote team. Without the benefit of in-person interactions, leaders must be intentional about creating psychological safety and demonstrating reliability.',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          '• Be transparent about decisions and processes\n• Follow through consistently on commitments\n• Create regular opportunities for informal connection\n• Acknowledge mistakes and model vulnerability',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        
        Text(
          'Communication Strategies',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        Text(
          'Effective communication in remote teams requires structure, clarity, and multiple channels. Leaders must over-communicate context and create systems that keep everyone aligned.',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          '• Establish clear communication protocols\n• Use asynchronous updates for status sharing\n• Schedule regular one-on-ones with team members\n• Document decisions and share context widely',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        
        Text(
          'Maintaining Team Culture',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        Text(
          'Remote teams need intentional culture-building activities. Leaders should create opportunities for connection that go beyond work tasks and help team members feel part of something larger.',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          'The key to successful remote leadership is adapting your approach while maintaining the human elements that make teams thrive. Focus on outcomes, invest in relationships, and create systems that support both productivity and well-being.',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Is this helpful?',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_feedbackGiven == null) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _giveFeedback('yes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Yes',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _giveFeedback('no'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'No',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _feedbackGiven == 'yes' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _feedbackGiven == 'yes' ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _feedbackGiven == 'yes' ? Icons.check_circle : Icons.cancel,
                    color: _feedbackGiven == 'yes' ? Colors.green : Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _feedbackGiven == 'yes' 
                        ? 'Thanks for your feedback! We\'ll continue to recommend similar content.'
                        : 'Thanks for your feedback! We\'ll improve our recommendations.',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: _feedbackGiven == 'yes' ? Colors.green[700] : Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLevelChip(String level) {
    Color backgroundColor;
    Color textColor;
    switch (level.toLowerCase()) {
      case 'beginner':
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
        break;
      case 'intermediate':
        backgroundColor = Colors.grey[300]!;
        textColor = Colors.grey[900]!;
        break;
      case 'advanced':
        backgroundColor = Colors.grey[400]!;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Text(
        level,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        type,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _giveFeedback(String feedback) {
    setState(() {
      _feedbackGiven = feedback;
    });
  }
}
