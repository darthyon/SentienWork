import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';
import '../widgets/ask_ben_button.dart';
import 'add_task_screen.dart';
import 'ben_meeting_suggestion_screen.dart';
import 'ask_ben_screen.dart'; // Import AskBenScreen

class MyDayScreen extends StatefulWidget {
  const MyDayScreen({super.key});

  @override
  State<MyDayScreen> createState() => _MyDayScreenState();
}

class _MyDayScreenState extends State<MyDayScreen> {
  bool _showBenTooltip = true;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentWeekStart = _getWeekStart(DateTime.now());
  Map<String, bool> _benSuggestions = {}; // Track Ben suggestions for tasks
  
  // Sample tasks data - will be replaced with proper data model
  Map<String, List<Map<String, dynamic>>> _tasksByDate = {
    DateTime.now().toIso8601String().split('T')[0]: [
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
        'title': 'Meeting with boss at 11am',
        'notes': 'Quarterly review and goal setting',
        'priority': 'high',
        'timeOfDay': 'morning',
        'date': DateTime.now().toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Team standup meeting',
        'notes': 'Daily sync with development team',
        'priority': 'medium',
        'timeOfDay': 'morning',
        'date': DateTime.now().toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '4',
        'title': 'Finish project proposal',
        'notes': 'Complete final draft and review',
        'priority': 'high',
        'timeOfDay': 'afternoon',
        'date': DateTime.now().toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '5',
        'title': 'Call with client',
        'notes': 'Discuss project timeline and requirements',
        'priority': 'medium',
        'timeOfDay': 'afternoon',
        'date': DateTime.now().toIso8601String(),
        'isCompleted': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '6',
        'title': 'Gym workout',
        'notes': 'Cardio and strength training',
        'priority': 'low',
        'timeOfDay': 'evening',
        'date': DateTime.now().toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ],
    DateTime.now().add(Duration(days: 1)).toIso8601String().split('T')[0]: [], // Tomorrow - empty
  };

  static DateTime _getWeekStart(DateTime date) {
    // Get Sunday as start of week (weekday 7 = Sunday, 1 = Monday)
    int daysFromSunday = date.weekday % 7;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysFromSunday));
  }

  List<Map<String, dynamic>> get _tasks {
    final dateKey = _selectedDate.toIso8601String().split('T')[0];
    return _tasksByDate[dateKey] ?? [];
  }

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      final dateKey = _selectedDate.toIso8601String().split('T')[0];
      final tasks = _tasksByDate[dateKey] ?? [];
      final taskIndex = tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex]['isCompleted'] = !tasks[taskIndex]['isCompleted'];
        
        // Check if this is the boss meeting task and show Ben suggestion
        final task = tasks[taskIndex];
        if (task['title'] == 'Meeting with boss at 11am' && task['isCompleted'] == true) {
          _benSuggestions[taskId] = true;
        }
      }
    });
  }

  void _dismissBenSuggestion(String taskId) {
    setState(() {
      _benSuggestions[taskId] = false;
    });
  }

  void _openBenSuggestion() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BenMeetingSuggestionScreen(),
      ),
    );
    
    // If tasks were created, add them to the task list
    if (result != null && result is List<Task>) {
      setState(() {
        final dateKey = _selectedDate.toIso8601String().split('T')[0];
        _tasksByDate[dateKey] ??= [];
        for (Task task in result) {
          _tasksByDate[dateKey]!.add({
            'id': task.id,
            'title': task.title,
            'notes': task.notes,
            'priority': task.priority,
            'timeOfDay': task.timeOfDay,
            'date': task.date.toIso8601String(),
            'isCompleted': task.isCompleted,
            'createdAt': task.createdAt.toIso8601String(),
          });
        }
      });
    }
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
            GestureDetector(
              onTap: () {
                _showMonthlyCalendar();
              },
              child: Container(
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
            ),
            
            // Calendar strip (horizontal scrolling)
            Container(
              height: 80,
              color: Colors.white,
              child: GestureDetector(
                onPanUpdate: (details) {
                  // Swipe left/right to change week - reduced threshold for better sensitivity
                  if (details.delta.dx > 5) {
                    // Swipe right - previous week
                    setState(() {
                      _currentWeekStart = _currentWeekStart.subtract(Duration(days: 7));
                    });
                  } else if (details.delta.dx < -5) {
                    // Swipe left - next week
                    setState(() {
                      _currentWeekStart = _currentWeekStart.add(Duration(days: 7));
                    });
                  }
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 7, // Show current week
                  itemBuilder: (context, index) {
                    final date = _currentWeekStart.add(Duration(days: index));
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
                            ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday == 7 ? 0 : date.weekday],
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600],
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
            ),
            
            // Divider
            Container(
              height: 1,
              color: const Color(0xFFE5E5E5),
            ),
            
            // To-do list
            Expanded(
              child: _tasks.isEmpty ? _buildEmptyState() : ListView(
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

  Widget _buildEmptyState() {
    final isToday = _isSameDay(_selectedDate, DateTime.now());
    final isTomorrow = _isSameDay(_selectedDate, DateTime.now().add(Duration(days: 1)));
    
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isToday ? 'All tasks completed!' : isTomorrow ? 'Tomorrow is free!' : 'No tasks for this day',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isToday ? 'Great job finishing everything today!' : isTomorrow ? 'You have a clear schedule ahead.' : 'Enjoy your free time!',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (isTomorrow && _hasIncompleteTasks()) ...[
            const SizedBox(height: 24),
            _buildBenTaskSuggestion(),
          ],
        ],
      ),
    );
  }

  bool _hasIncompleteTasks() {
    final todayKey = DateTime.now().toIso8601String().split('T')[0];
    final todayTasks = _tasksByDate[todayKey] ?? [];
    return todayTasks.any((task) => !task['isCompleted']);
  }

  Widget _buildBenTaskSuggestion() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'I\'ve organized your day. Tap any task to get started!',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showTaskMoveModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Yes, help me organize',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskMoveModal() {
    final todayKey = DateTime.now().toIso8601String().split('T')[0];
    final incompleteTasks = (_tasksByDate[todayKey] ?? [])
        .where((task) => !task['isCompleted'])
        .toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TaskMoveModal(
        incompleteTasks: incompleteTasks,
        onTasksSelected: _moveTasksToTomorrow,
      ),
    );
  }

  void _moveTasksToTomorrow(List<Map<String, dynamic>> selectedTasks) {
    setState(() {
      final todayKey = DateTime.now().toIso8601String().split('T')[0];
      final tomorrowKey = DateTime.now().add(Duration(days: 1)).toIso8601String().split('T')[0];
      
      // Remove from today
      final todayTasks = _tasksByDate[todayKey] ?? [];
      for (final task in selectedTasks) {
        todayTasks.removeWhere((t) => t['id'] == task['id']);
      }
      
      // Add to tomorrow
      _tasksByDate[tomorrowKey] ??= [];
      for (final task in selectedTasks) {
        final newTask = Map<String, dynamic>.from(task);
        newTask['date'] = DateTime.now().add(Duration(days: 1)).toIso8601String();
        _tasksByDate[tomorrowKey]!.add(newTask);
      }
    });
  }

  void _showMonthlyCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MonthlyCalendarModal(
        selectedDate: _selectedDate,
        tasksByDate: _tasksByDate,
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
            _currentWeekStart = _getWeekStart(date);
          });
          Navigator.pop(context);
        },
      ),
    );
  }
  
  List<Widget> _buildTasksForTimeOfDay(String timeOfDay) {
    final tasksForTime = _tasks.where((task) => task['timeOfDay'] == timeOfDay).toList();
    
    return tasksForTime.map((task) {
      return Column(
        children: [
          _buildTodoCard(task),
          // Show Ben suggestion card if applicable
          if (_benSuggestions[task['id']] == true) ...[
            const SizedBox(height: 8),
            _buildBenSuggestionCard(task['id']),
          ],
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
        priorityColor = Colors.grey[600]!;
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
                            final dateKey = _selectedDate.toIso8601String().split('T')[0];
                            final tasks = _tasksByDate[dateKey] ?? [];
                            final index = tasks.indexOf(task);
                            if (result == 'deleted') {
                              tasks.removeAt(index);
                            } else if (result is Task) {
                              tasks[index] = result.toMap();
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

  Widget _buildBenSuggestionCard(String taskId) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _openBenSuggestion,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ben avatar
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Message
                Expanded(
                  child: Text(
                    'Can I suggest you something?',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                
                // Dismiss button
                GestureDetector(
                  onTap: () => _dismissBenSuggestion(taskId),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskMoveModal extends StatefulWidget {
  final List<Map<String, dynamic>> incompleteTasks;
  final Function(List<Map<String, dynamic>>) onTasksSelected;

  const _TaskMoveModal({
    required this.incompleteTasks,
    required this.onTasksSelected,
  });

  @override
  State<_TaskMoveModal> createState() => _TaskMoveModalState();
}

class _TaskMoveModalState extends State<_TaskMoveModal> {
  Set<String> selectedTaskIds = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
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
                    Expanded(
                      child: Text(
                        'Which tasks would you like to move to tomorrow?',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Task list
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.incompleteTasks.length,
              itemBuilder: (context, index) {
                final task = widget.incompleteTasks[index];
                final isSelected = selectedTaskIds.contains(task['id']);
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF0F8FF) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTaskIds.remove(task['id']);
                          } else {
                            selectedTaskIds.add(task['id']);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey[400]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                task['title'],
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedTaskIds.isEmpty
                        ? null
                        : () {
                            final selectedTasks = widget.incompleteTasks
                                .where((task) => selectedTaskIds.contains(task['id']))
                                .toList();
                            widget.onTasksSelected(selectedTasks);
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Move ${selectedTaskIds.length} task${selectedTaskIds.length == 1 ? '' : 's'} to tomorrow',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: selectedTaskIds.isEmpty ? Colors.grey[500] : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'No, I\'ll handle them today',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyCalendarModal extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, List<Map<String, dynamic>>> tasksByDate;
  final Function(DateTime) onDateSelected;

  const _MonthlyCalendarModal({
    required this.selectedDate,
    required this.tasksByDate,
    required this.onDateSelected,
  });

  @override
  State<_MonthlyCalendarModal> createState() => _MonthlyCalendarModalState();
}

class _MonthlyCalendarModalState extends State<_MonthlyCalendarModal> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  bool _hasTasksOnDate(DateTime date) {
    final dateKey = date.toIso8601String().split('T')[0];
    final tasks = widget.tasksByDate[dateKey] ?? [];
    return tasks.isNotEmpty;
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startOfWeek = firstDay.subtract(Duration(days: firstDay.weekday % 7));
    
    List<DateTime> days = [];
    DateTime current = startOfWeek;
    
    // Generate 6 weeks to fill the calendar grid
    for (int week = 0; week < 6; week++) {
      for (int day = 0; day < 7; day++) {
        days.add(current);
        current = current.add(Duration(days: 1));
      }
    }
    
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_currentMonth);
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                    });
                  },
                  icon: Icon(Icons.chevron_left, color: Colors.grey[600]),
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                    });
                  },
                  icon: Icon(Icons.chevron_right, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          
          // Days of week header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Calendar grid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final isCurrentMonth = date.month == _currentMonth.month;
                final isToday = _isSameDay(date, DateTime.now());
                final isSelected = _isSameDay(date, widget.selectedDate);
                final hasTasks = _hasTasksOnDate(date);
                
                return GestureDetector(
                  onTap: () => widget.onDateSelected(date),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.black 
                          : isToday 
                              ? Colors.grey[200] 
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: Colors.black, width: 1)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : isCurrentMonth
                                    ? Colors.black
                                    : Colors.grey[400],
                          ),
                        ),
                        if (hasTasks && isCurrentMonth) ...[
                          const SizedBox(height: 2),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
