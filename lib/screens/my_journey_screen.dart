import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ask_ben_button.dart';

class MyJourneyScreen extends StatefulWidget {
  const MyJourneyScreen({super.key});

  @override
  State<MyJourneyScreen> createState() => _MyJourneyScreenState();
}

class _MyJourneyScreenState extends State<MyJourneyScreen> {
  String _aspiration = "You're working toward becoming a product manager within the next 18 months. Let's focus on leadership skills and visibility.";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Journey',
                    style: GoogleFonts.dmSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const AskBenButton(),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Profile + Settings Cluster
                    _buildProfileSection(),
                    
                    const SizedBox(height: 24),
                    
                    // 2. Aspiration Card
                    _buildAspirationCard(),
                    
                    const SizedBox(height: 24),
                    
                    // 3. Stats Cards Row
                    _buildStatsRow(),
                    
                    const SizedBox(height: 24),
                    
                    // 4. Milestones Section
                    _buildMilestonesSection(),
                    
                    const SizedBox(height: 24),
                    
                    // 5. Assessments Section
                    _buildAssessmentsSection(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileSection() {
    return Row(
      children: [
        // Profile photo
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: Icon(
            Icons.person,
            size: 32,
            color: Colors.grey[600],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Name and edit profile
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alex Johnson',
                style: GoogleFonts.dmSans(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Edit Profile',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        
        // Settings icon
        IconButton(
          onPressed: () {
            // TODO: Settings functionality
          },
          icon: Icon(
            Icons.settings,
            color: Colors.grey[600],
            size: 24,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAspirationCard() {
    return GestureDetector(
      onTap: _showAspirationModal,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ASPIRATION',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1,
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _aspiration,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: 0,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('7', 'Day Streak', Icons.local_fire_department)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('24', 'Tasks Done', Icons.check_circle)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('3', 'Badges', Icons.workspace_premium)),
      ],
    );
  }
  
  Widget _buildStatCard(String number, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: Colors.grey[600],
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildMilestonesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestones',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 16),
        _buildMilestoneCard('Leadership Skills', 0.65),
        const SizedBox(height: 12),
        _buildMilestoneCard('Product Management Basics', 0.40),
        const SizedBox(height: 12),
        _buildMilestoneCard('Team Collaboration', 0.85),
      ],
    );
  }
  
  Widget _buildMilestoneCard(String title, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAssessmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assessments',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 16),
        _buildAssessmentCard('DASS-21', 'Depression, Anxiety & Stress Scale'),
        const SizedBox(height: 12),
        _buildAssessmentCard('MBTI', 'Myers-Briggs Type Indicator'),
        const SizedBox(height: 12),
        _buildAssessmentCard('Color Personality', 'Personality Color Test'),
      ],
    );
  }
  
  Widget _buildAssessmentCard(String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        _showAssessmentDetail(title);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAspirationModal() {
    final TextEditingController controller = TextEditingController(text: _aspiration);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Edit Aspiration',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Generated aspiration pill
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "You're working toward becoming a product manager within the next 18 months. Let's focus on leadership skills and visibility.",
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'This was generated based on your onboarding answers: Product Manager, 18 months.',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Text area
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Write your aspiration...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _aspiration = controller.text;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Center(
              child: TextButton(
                onPressed: () {
                  controller.text = "You're working toward becoming a product manager within the next 18 months. Let's focus on leadership skills and visibility.";
                },
                child: Text(
                  "Reset to Ben's version",
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAssessmentDetail(String assessmentType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssessmentDetailScreen(assessmentType: assessmentType),
      ),
    );
  }
}

class AssessmentDetailScreen extends StatelessWidget {
  final String assessmentType;
  
  const AssessmentDetailScreen({super.key, required this.assessmentType});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          assessmentType,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assessment Results',
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getAssessmentContent(assessmentType),
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
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
  
  String _getAssessmentContent(String type) {
    switch (type) {
      case 'DASS-21':
        return 'Your DASS-21 results show normal levels across all scales. This assessment measures depression, anxiety, and stress levels.';
      case 'MBTI':
        return 'Your personality type is ENFJ - The Protagonist. You are charismatic and inspiring leaders, able to mesmerize listeners.';
      case 'Color Personality':
        return 'Your dominant color is Blue, indicating you are analytical, deliberate, and precise in your approach to life and work.';
      default:
        return 'Assessment results will be displayed here once completed.';
    }
  }
}
