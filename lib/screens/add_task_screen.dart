import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final bool isViewMode;
  final bool isEditMode;

  const AddTaskScreen({
    super.key,
    this.task,
    this.isViewMode = false,
    this.isEditMode = false,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedPriority = 'medium';
  String _selectedTimeOfDay = 'morning';
  DateTime _selectedDate = DateTime.now();
  bool _isEditMode = false;
  bool _isRecording = false;
  List<String> _attachments = [];
  List<String> _voiceNotes = [];
  late AnimationController _recordingAnimationController;
  late AnimationController _pulseAnimationController;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String _selectedTag = 'work';

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    _selectedTag = widget.task?.tag ?? 'work';
    _recordingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _notesController.text = widget.task!.notes;
      _selectedPriority = widget.task!.priority;
      _selectedTimeOfDay = widget.task!.timeOfDay;
      _selectedDate = widget.task!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _recordingAnimationController.dispose();
    _pulseAnimationController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              color: const Color(0xFFF7F7F7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.dmSans(
                        color: Colors.grey[600],
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text(
                      'Done',
                      style: GoogleFonts.dmSans(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  cupertinoOverrideTheme: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: GoogleFonts.dmSans(
                        color: Colors.grey[700],
                        fontSize: 22,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Colors.grey[600],
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                  onDateTimeChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      return;
    }

    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      priority: _selectedPriority,
      timeOfDay: _selectedTimeOfDay,
      date: _selectedDate,
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      tag: _selectedTag,
    );

    Navigator.pop(context, task);
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
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              if (!widget.isViewMode || _isEditMode)
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
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              if (!widget.isViewMode || _isEditMode)
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

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Task',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.2,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this task?',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[600],
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.grey[600],
                letterSpacing: -0.2,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, 'deleted');
            },
            child: Text(
              'Delete',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
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
          widget.isViewMode ? 'Task Details' : (widget.task != null ? 'Edit Task' : 'New Task'),
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          if (widget.isViewMode && !_isEditMode) ...[
            if (widget.task != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: _deleteTask,
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isEditMode = true;
                });
              },
            ),
          ] else if (_isEditMode || !widget.isViewMode)
            TextButton(
              onPressed: _saveTask,
              child: Text(
                'Save',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.2,
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
                        _titleController.text.isEmpty ? 'Untitled Task' : _titleController.text,
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: -0.2,
                        ),
                      ),
                    )
                  : TextField(
                      controller: _titleController,
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Task title...',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                          letterSpacing: -0.2,
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
                          _notesController.text.isEmpty ? 'No additional details' : _notesController.text,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: _notesController.text.isEmpty ? Colors.grey[500] : Colors.black,
                            letterSpacing: -0.2,
                            height: 1.5,
                          ),
                        ),
                      )
                    : TextField(
                        controller: _notesController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: -0.2,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add details about your task...',
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
                        ...(_voiceNotes.map((note) => _buildAttachmentCard(
                          type: 'voice',
                          name: note,
                          onRemove: () {
                            setState(() {
                              _voiceNotes.remove(note);
                            });
                          },
                        ))),
                        // File attachments
                        ...(_attachments.map((attachment) => _buildAttachmentCard(
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
            
            // Additional options section
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
                children: [
                  // Priority selection (optional)
                  Row(
                    children: [
                      Text(
                        'Priority: ',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (widget.isViewMode && !_isEditMode)
                        _buildPriorityDisplay(_selectedPriority)
                      else ...[
                        _buildPriorityChip('high', 'High', Colors.red),
                        const SizedBox(width: 8),
                        _buildPriorityChip('medium', 'Medium', Colors.grey[600]!),
                        const SizedBox(width: 8),
                        _buildPriorityChip('low', 'Low', Colors.green),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Due date (optional)
                  GestureDetector(
                    onTap: (widget.isViewMode && !_isEditMode) ? null : _showDatePicker,
                    child: Row(
                      children: [
                        Text(
                          'Due: ',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tag selection
                  Row(
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
                  
                  // Voice notes are now handled in the attachments grid above
                  // Removed duplicate blue voice file display
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentCard({
    required String type,
    required String name,
    required VoidCallback onRemove,
  }) {
    return Container(
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
                child: Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String value, String label) {
    final isSelected = _selectedTag == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTag = value;
        });
      },
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

  Widget _buildPriorityChip(String priority, String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _selectedPriority == priority ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedPriority == priority ? color : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _selectedPriority == priority ? color : Colors.grey[600],
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDisplay(String priority) {
    Color color;
    String label;
    switch (priority) {
      case 'high':
        color = Colors.red;
        label = 'High';
        break;
      case 'medium':
        color = Colors.grey[600]!;
        label = 'Medium';
        break;
      case 'low':
        color = Colors.green;
        label = 'Low';
        break;
      default:
        color = Colors.grey;
        label = 'Medium';
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeChip(String value, String label) {
    final isSelected = _selectedTimeOfDay == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeOfDay = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey[700],
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
