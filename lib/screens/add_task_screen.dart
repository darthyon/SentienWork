import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedPriority = 'medium';
  String _selectedTimeOfDay = 'morning';
  DateTime _selectedDate = DateTime.now();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    
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
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text(
                      'Done',
                      style: GoogleFonts.dmSans(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
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
    );

    Navigator.pop(context, task);
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
          ),
        ),
        content: Text(
          'Are you sure you want to delete this task?',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.grey[600],
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
            letterSpacing: 0,
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
                        _titleController.text.isEmpty ? 'Untitled Task' : _titleController.text,
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
                        hintText: 'Task title...',
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
                          _notesController.text.isEmpty ? 'No additional details' : _notesController.text,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: _notesController.text.isEmpty ? Colors.grey[500] : Colors.black,
                            letterSpacing: 0,
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
                          letterSpacing: 0,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add details about your task...',
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
            
            // Optional settings at bottom
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
                          letterSpacing: 0,
                        ),
                      ),
                      if (widget.isViewMode && !_isEditMode)
                        _buildPriorityDisplay(_selectedPriority)
                      else ...[
                        _buildPriorityChip('high', 'High', Colors.red),
                        const SizedBox(width: 8),
                        _buildPriorityChip('medium', 'Medium', Colors.orange),
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
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 0,
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
                ],
              ),
            ),
          ],
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
                letterSpacing: 0,
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
        color = Colors.orange;
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
            letterSpacing: 0,
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
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
