import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/ask_ben_screen.dart';

class AskBenButton extends StatelessWidget {
  const AskBenButton({super.key});

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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Ask Ben',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
