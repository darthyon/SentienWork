import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mixin AddNoteScreenHelper {
  Widget buildAttachmentCard({
    required String type,
    required String name,
    required VoidCallback onRemove,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    type == 'voice' ? Icons.mic : Icons.insert_drive_file,
                    size: 24,
                    color: type == 'voice' ? Colors.blue[600] : Colors.grey[600],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name.length > 8 ? '${name.substring(0, 8)}...' : name,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: Colors.grey[600],
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTagChip(String value, String label, String selectedTag, Function(String) onTagSelected) {
    final isSelected = selectedTag == value;
    return GestureDetector(
      onTap: () => onTagSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
