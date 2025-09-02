import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../widgets/ask_ben_button.dart';
import 'add_note_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

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
                    'Notes',
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
            
            // Content - Notes List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildNoteCard(
                    'Meeting Notes - Q4 Planning',
                    'Discussed budget allocation for next quarter. Key points:\n• Marketing budget increase by 15%\n• New hire for engineering team\n• Product launch timeline moved to February',
                    '2h ago',
                    context,
                  ),
                  const SizedBox(height: 12),
                  _buildNoteCard(
                    'Ideas for App Improvement',
                    'User feedback from beta testing:\n- Dark mode requested by 80% of users\n- Push notifications need better timing\n- Calendar integration would be valuable\n\nNext steps: Prioritize dark mode implementation',
                    '1d ago',
                    context,
                  ),
                  const SizedBox(height: 12),
                  _buildNoteCard(
                    'Book Recommendations',
                    'From today\'s conversation with Sarah:\n\n1. "Atomic Habits" by James Clear\n2. "The Lean Startup" by Eric Ries\n3. "Thinking, Fast and Slow" by Daniel Kahneman\n\nShould check if library has these available.',
                    '3d ago',
                    context,
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(String title, String content, String timeAgo, BuildContext context) {
    final now = DateTime.now();
    final createdTime = timeAgo == '2h ago' 
        ? now.subtract(const Duration(hours: 2))
        : timeAgo == '1d ago' 
            ? now.subtract(const Duration(days: 1))
            : now.subtract(const Duration(days: 3));
            
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddNoteScreen(
              note: Note(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                content: content,
                createdAt: createdTime,
                updatedAt: createdTime,
              ),
              isViewMode: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
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
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.grey[600],
                letterSpacing: 0,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              timeAgo,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: Colors.grey[500],
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
