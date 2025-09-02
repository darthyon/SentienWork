import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final bool isViewMode;
  final bool isEditMode;

  const AddNoteScreen({
    super.key,
    this.note,
    this.isViewMode = false,
    this.isEditMode = false,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      return;
    }

    // TODO: Save note to data model/storage
    final note = {
      'title': _titleController.text.trim().isEmpty 
          ? 'Untitled Note' 
          : _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isViewMode ? 'Note Details' : (widget.note != null ? 'Edit Note' : 'New Note'),
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0,
          ),
        ),
        actions: [
          if (widget.isViewMode && !_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isEditMode = true;
                });
              },
            )
          else if (_isEditMode || !widget.isViewMode)
            TextButton(
              onPressed: _saveNote,
              child: Text(
                'Save',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0,
                ),
              ),
            ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Title Field
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 0.5,
                  ),
                ),
              ),
              child: widget.isViewMode && !_isEditMode
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _titleController.text.isEmpty ? 'Untitled Note' : _titleController.text,
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0,
                        ),
                      ),
                    )
                  : TextField(
                      controller: _titleController,
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Note title...',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                          letterSpacing: 0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
            ),
            
            // Content Field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: widget.isViewMode && !_isEditMode
                    ? SingleChildScrollView(
                        child: Text(
                          _contentController.text.isEmpty ? 'No content' : _contentController.text,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: _contentController.text.isEmpty ? Colors.grey[500] : Colors.black,
                            letterSpacing: 0,
                            height: 1.5,
                          ),
                        ),
                      )
                    : TextField(
                        controller: _contentController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 0,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Start writing your note...',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: Colors.grey[500],
                            letterSpacing: 0,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
