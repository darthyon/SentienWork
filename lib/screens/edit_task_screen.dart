import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late String _selectedPriority;
  late String _selectedTimeOfDay;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _notesController = TextEditingController(text: widget.task.notes);
    _selectedPriority = widget.task.priority;
    _selectedTimeOfDay = widget.task.timeOfDay;
    _selectedDate = widget.task.date;
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

    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      priority: _selectedPriority,
      timeOfDay: _selectedTimeOfDay,
      date: _selectedDate,
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, updatedTask);
  }

  void _deleteTask() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'Delete Task',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this task?',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(
              'Delete',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, 'delete'); // Return delete action
            },
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
          'Edit Task',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteTask,
          ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Title',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter task title...',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.grey[500],
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Priority Selection
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Priority',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildPriorityChip('high', 'High', Colors.red),
                      const SizedBox(width: 8),
                      _buildPriorityChip('medium', 'Medium', Colors.orange),
                      const SizedBox(width: 8),
                      _buildPriorityChip('low', 'Low', Colors.green),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Time of Day
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time of Day',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTimeChip('morning', 'Morning'),
                      const SizedBox(width: 8),
                      _buildTimeChip('afternoon', 'Afternoon'),
                      const SizedBox(width: 8),
                      _buildTimeChip('evening', 'Evening'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Date Selection
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: Colors.grey[600],
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes (Optional)',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add any additional notes...',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.grey[500],
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
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

  Widget _buildPriorityChip(String value, String label, Color color) {
    final isSelected = _selectedPriority == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 1.5,
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
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey[700],
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
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
