import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';
import '../widgets/ask_ben_button.dart';
import 'add_task_screen.dart';

class MyDayScreen extends StatefulWidget {
  const MyDayScreen({super.key});

  @override
  State<MyDayScreen> createState() => _MyDayScreenState();
}

class _MyDayScreenState extends State<MyDayScreen> {
  bool _showBenTooltip = true;
  DateTime _selectedDate = DateTime.now();
  
  // Sample tasks data - will be replaced with proper data model
  List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'title': 'Review quarterly goals',
      'notes': 'Prepare for Q4 planning session',
      'priority': 'high',
      'timeOfDay': 'morning',
      'date': DateTime.now().toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'title': 'Team standup meeting',
      'notes': 'Daily sync with development team',
      'priority': 'medium',
      'timeOfDay': 'morning',
      'date': DateTime.now().toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'title': 'Finish project proposal',
      'notes': 'Complete final draft and review',
      'priority': 'high',
      'timeOfDay': 'afternoon',
      'date': DateTime.now().toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '4',
      'title': 'Call with client',
      'notes': 'Discuss project timeline and requirements',
      'priority': 'medium',
      'timeOfDay': 'afternoon',
      'date': DateTime.now().toIso8601String(),
      'isCompleted': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '5',
      'title': 'Gym workout',
      'notes': 'Cardio and strength training',
      'priority': 'low',
      'timeOfDay': 'evening',
      'date': DateTime.now().toIso8601String(),
      'isCompleted': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex]['isCompleted'] = !_tasks[taskIndex]['isCompleted'];
      }
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  String _getDateHeaderText() {
    final now = DateTime.now();
    if (_isSameDay(_selectedDate, now)) {
      return 'Today, ${_getMonthName(_selectedDate.month)} ${_selectedDate.day}';
    } else if (_isSameDay(_selectedDate, now.add(const Duration(days: 1)))) {
      return 'Tomorrow, ${_getMonthName(_selectedDate.month)} ${_selectedDate.day}';
    } else if (_isSameDay(_selectedDate, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday, ${_getMonthName(_selectedDate.month)} ${_selectedDate.day}';
    } else {
      return '${_getMonthName(_selectedDate.month)} ${_selectedDate.day}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header with date and Ben tooltip
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getDateHeaderText(),
                        style: GoogleFonts.dmSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // Ask Ben button
                      const AskBenButton(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Ben tooltip (sticky on first visit)
                  if (_showBenTooltip)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Ben avatar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Ben message
                          Expanded(
                            child: Text(
                              'I\'ve organized your day. Tap any task to get started!',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          
                          // Dismiss button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showBenTooltip = false;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            // Calendar strip (horizontal scrolling)
            Container(
              height: 80,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 14, // Show 2 weeks
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index - 7));
                  final isToday = _isSameDay(date, DateTime.now());
                  final isSelected = _isSameDay(date, _selectedDate);
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7],
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.grey[600],
                              letterSpacing: 0,
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.black : Colors.transparent,
                              shape: BoxShape.circle,
                              border: isToday && !isSelected 
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : Colors.black,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Divider
            Container(
              height: 1,
              color: const Color(0xFFE5E5E5),
            ),
            
            // To-do list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Morning section
                  _buildSectionHeader('Morning'),
                  const SizedBox(height: 12),
                  ..._buildTasksForTimeOfDay('morning'),
                  
                  const SizedBox(height: 24),
                  
                  // Afternoon section
                  _buildSectionHeader('Afternoon'),
                  const SizedBox(height: 12),
                  ..._buildTasksForTimeOfDay('afternoon'),
                  
                  const SizedBox(height: 24),
                  
                  // Evening section
                  _buildSectionHeader('Evening'),
                  const SizedBox(height: 12),
                  ..._buildTasksForTimeOfDay('evening'),
                  
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildTasksForTimeOfDay(String timeOfDay) {
    final tasksForTime = _tasks.where((task) => task['timeOfDay'] == timeOfDay).toList();
    
    return tasksForTime.map((task) {
      return Column(
        children: [
          _buildTodoCard(task),
          const SizedBox(height: 12),
        ],
      );
    }).toList();
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
        letterSpacing: 0,
      ),
    );
  }
  
  Widget _buildTodoCard(Map<String, dynamic> task) {
    final String title = task['title'];
    final String priority = task['priority'];
    final bool isCompleted = task['isCompleted'];
    final String taskId = task['id'];
    
    Color priorityColor;
    switch (priority) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      case 'low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Priority stripe
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () {
                      _toggleTaskCompletion(taskId);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.black : Colors.transparent,
                        border: Border.all(
                          color: isCompleted ? Colors.black : Colors.grey[400]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Task title
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskScreen(
                              task: Task.fromMap(task),
                              isViewMode: true,
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            final index = _tasks.indexOf(task);
                            if (result == 'deleted') {
                              _tasks.removeAt(index);
                            } else if (result is Task) {
                              _tasks[index] = result.toMap();
                            }
                          });
                        }
                      },
                      child: Text(
                        title,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isCompleted ? Colors.grey[500] : Colors.black,
                          letterSpacing: 0,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
