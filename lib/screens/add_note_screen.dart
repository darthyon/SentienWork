import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'add_note_screen_helper.dart';
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

class _AddNoteScreenState extends State<AddNoteScreen> with TickerProviderStateMixin, AddNoteScreenHelper {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isRecording = false;
  List<String> _attachments = [];
  List<String> _voiceNotes = [];
  bool _isEditMode = false;
  late AnimationController _recordingAnimationController;
  late AnimationController _pulseAnimationController;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String _selectedTag = 'work';

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    
    _recordingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _recordingAnimationController.dispose();
    _pulseAnimationController.dispose();
    _recordingTimer?.cancel();
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
  
  void _toggleVoiceRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (_isRecording) {
      _recordingAnimationController.forward();
      _pulseAnimationController.repeat();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingSeconds++;
        });
      });
    } else {
      _recordingAnimationController.reverse();
      _pulseAnimationController.stop();
      _recordingTimer?.cancel();
      setState(() {
        _voiceNotes.add('Voice note ${_voiceNotes.length + 1}');
        _recordingSeconds = 0;
      });
    }
  }
  
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Attachment',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 20),
            _buildAttachmentOption(
              icon: Icons.photo_library,
              title: 'Photo Library',
              onTap: () {
                Navigator.pop(context);
                _addAttachment('Photo from library');
              },
            ),
            _buildAttachmentOption(
              icon: Icons.camera_alt,
              title: 'Camera',
              onTap: () {
                Navigator.pop(context);
                _addAttachment('Photo from camera');
              },
            ),
            _buildAttachmentOption(
              icon: Icons.insert_drive_file,
              title: 'Document',
              onTap: () {
                Navigator.pop(context);
                _addAttachment('Document file');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAttachmentOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.grey[700],
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _addAttachment(String attachment) {
    setState(() {
      _attachments.add(attachment);
    });
  }
  
  List<Widget> _buildAttachmentsList() {
    List<Widget> widgets = [];
    
    // Voice notes
    for (int i = 0; i < _voiceNotes.length; i++) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.mic, size: 16, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _voiceNotes[i],
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.blue[600],
                    letterSpacing: 0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _voiceNotes.removeAt(i);
                  });
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // File attachments
    for (int i = 0; i < _attachments.length; i++) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.attach_file, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _attachments[i],
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                    letterSpacing: 0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _attachments.removeAt(i);
                  });
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return widgets;
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
                            letterSpacing: -0.2,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
              ),
            ),
            
            // Attachment section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Attachments',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      // Voice note button
                      GestureDetector(
                        onTap: _toggleVoiceRecording,
                        child: AnimatedBuilder(
                          animation: _pulseAnimationController,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _isRecording ? Colors.red.withOpacity(0.1) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _isRecording ? Colors.red : Colors.grey[300]!,
                                  width: 1,
                                ),
                                boxShadow: _isRecording ? [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.2 * _pulseAnimationController.value),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ] : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedBuilder(
                                    animation: _recordingAnimationController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: 1.0 + (_recordingAnimationController.value * 0.1),
                                        child: Icon(
                                          _isRecording ? Icons.stop : Icons.mic,
                                          size: 16,
                                          color: _isRecording ? Colors.red : Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isRecording ? '0:${_recordingSeconds.toString().padLeft(2, '0')}' : 'Voice',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _isRecording ? Colors.red : Colors.grey[600],
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // File attachment button
                      GestureDetector(
                        onTap: _showAttachmentOptions,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'File',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Display attachments grid
                  if (_attachments.isNotEmpty || _voiceNotes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Voice notes
                        ...(_voiceNotes.map((note) => buildAttachmentCard(
                          type: 'voice',
                          name: note,
                          onRemove: () {
                            setState(() {
                              _voiceNotes.remove(note);
                            });
                          },
                        ))),
                        // File attachments
                        ...(_attachments.map((attachment) => buildAttachmentCard(
                          type: 'file',
                          name: attachment,
                          onRemove: () {
                            setState(() {
                              _attachments.remove(attachment);
                            });
                          },
                        ))),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Tag section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Tag: ',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                      letterSpacing: -0.2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _selectedTag = 'work'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedTag == 'work' ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Work',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _selectedTag == 'work' ? Colors.white : Colors.grey[600],
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedTag = 'personal'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedTag == 'personal' ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Personal',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _selectedTag == 'personal' ? Colors.white : Colors.grey[600],
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
