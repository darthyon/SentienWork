import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
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
  String _selectedTag = 'work';
  DateTime _selectedDate = DateTime.now();
  bool _isAdditionalSettingsExpanded = false;
  bool _isEditMode = false;
  bool _isRecording = false;
  bool _isTranscribing = false;
  List<String> _attachments = [];
  List<Map<String, String>> _voiceNotes = []; // Enhanced to store audio + transcript
  late AnimationController _recordingAnimationController;
  late AnimationController _pulseAnimationController;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String _selectedTimeOfDay = 'morning';
  final Record _audioRecorder = Record();
  // final stt.SpeechToText _speechToText = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  // bool _speechEnabled = false;
  String _currentTranscript = '';
  String? _currentPlayingPath;
  bool _isPlaying = false;

  // Mock transcription data for testing
  final List<String> _mockTranscripts = [
    "Complete quarterly budget review and submit to finance team.",
    "Schedule one-on-one meetings with all direct reports this week.",
    "Research new project management tools and prepare comparison report.",
    "Follow up with client about contract renewal and pricing discussion.",
    "Prepare presentation slides for next week's board meeting.",
  ];
  int _mockTranscriptIndex = 0;

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

    _initSpeech();
    _setupAudioPlayer();
  }

  void _initSpeech() async {
    // COMMENTED OUT FOR iOS SIMULATOR TESTING
    // Real speech-to-text initialization
    /*
    _speechEnabled = await _speechToText.initialize();
    if (mounted) {
      setState(() {});
    }
    */
    
    // Mock initialization for simulator testing
    print('Mock speech-to-text initialized for simulator testing');
    if (mounted) {
      setState(() {});
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _recordingAnimationController.dispose();
    _pulseAnimationController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
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

  Future<void> _toggleVoiceRecording() async {
    print('Toggle voice recording called. Currently recording: $_isRecording');
    
    if (!_isRecording) {
      await _startRecording();
    } else {
      await _stopRecording();
    }
  }

  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> _startRecording() async {
    try {
      print('Starting recording process...');
      
      // Try to start recording directly - the record package will handle permissions
      final path = await _getRecordingPath();
      print('Recording to path: $path');
      
      await _audioRecorder.start(path: path);
      print('Recording started successfully');
      
      if (mounted) {
        setState(() {
          _isRecording = true;
          _currentTranscript = '';
        });
      }
      
      _recordingAnimationController.forward();
      _pulseAnimationController.repeat();
      
      // COMMENTED OUT FOR iOS SIMULATOR TESTING
      // Real speech-to-text listening
      /*
      // Start speech-to-text
      print('Initializing speech-to-text...');
      final speechAvailable = await _speechToText.initialize();
      print('Speech-to-text available: $speechAvailable');
      
      if (speechAvailable) {
        _speechToText.listen(
          onResult: (result) {
            print('Speech result: ${result.recognizedWords}');
            if (mounted) {
              setState(() {
                _currentTranscript = result.recognizedWords;
              });
            }
          },
        );
      }
      */
      
      // Mock speech-to-text for simulator testing
      print('Mock speech-to-text listening started for simulator testing');
      
      // Simulate real-time transcription updates during recording
      Timer.periodic(const Duration(seconds: 2), (timer) {
        if (!_isRecording) {
          timer.cancel();
          return;
        }
        
        if (mounted) {
          setState(() {
            // Simulate partial transcription updates
            final mockText = _mockTranscripts[_mockTranscriptIndex % _mockTranscripts.length];
            final words = mockText.split(' ');
            final partialLength = (_recordingSeconds / 2).clamp(1, words.length).toInt();
            _currentTranscript = words.take(partialLength).join(' ');
          });
        }
      });
      
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingSeconds++;
          });
          print('Recording seconds: $_recordingSeconds');
        }
      });
      
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording failed: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      if (mounted) {
        setState(() {
          _isRecording = false;
          _isTranscribing = true;
        });
      }

      _recordingAnimationController.reverse();
      _pulseAnimationController.stop();
      _recordingTimer?.cancel();

      // COMMENTED OUT FOR iOS SIMULATOR TESTING
      // Real speech-to-text stop
      /*
      // Stop speech-to-text
      await _speechToText.stop();
      */
      
      // Mock transcription processing
      print('Mock transcription processing started');

      // Simulate transcription processing time
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isTranscribing = false;
          if (path != null) {
            // Use mock transcript data
            final mockTranscript = _mockTranscripts[_mockTranscriptIndex % _mockTranscripts.length];
            _mockTranscriptIndex++;
            
            _voiceNotes.add({
              'audio': path,
              'transcript': mockTranscript,
              'duration': '0:${_recordingSeconds.toString().padLeft(2, '0')}',
            });
            
            // Add mock transcribed text to the notes field
            final currentText = _notesController.text;
            final newText = currentText.isEmpty 
                ? mockTranscript 
                : '$currentText\n\n$mockTranscript';
            _notesController.text = newText;
            
            print('Mock transcript added: $mockTranscript');
          }
          _recordingSeconds = 0;
          _currentTranscript = '';
        });
      }
    } catch (e) {
      print('Error stopping recording: $e');
      if (mounted) {
        setState(() {
          _isRecording = false;
          _isTranscribing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to stop recording: $e')),
        );
      }
    }
  }

  Future<void> _playVoiceNote(String audioPath) async {
    try {
      if (_isPlaying && _currentPlayingPath == audioPath) {
        await _audioPlayer.stop();
        if (mounted) {
          setState(() {
            _currentPlayingPath = null;
            _isPlaying = false;
          });
        }
      } else {
        await _audioPlayer.stop();
        await _audioPlayer.play(DeviceFileSource(audioPath));
        if (mounted) {
          setState(() {
            _currentPlayingPath = audioPath;
          });
        }
      }
    } catch (e) {
      print('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play audio: $e')),
        );
      }
    }
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
        _buildAttachmentCard(
          type: 'voice',
          name: _voiceNotes[i]['audio']!,
          transcript: _voiceNotes[i]['transcript'],
          duration: _voiceNotes[i]['duration'],
          onRemove: () {
            setState(() {
              _voiceNotes.removeAt(i);
            });
          },
          onPlay: () async {
            await _playVoiceNote(_voiceNotes[i]['audio']!);
          },
        ),
      );
    }

    // File attachments
    for (int i = 0; i < _attachments.length; i++) {
      widgets.add(
        _buildAttachmentCard(
          type: 'file',
          name: _attachments[i],
          onRemove: () {
            setState(() {
              _attachments.removeAt(i);
            });
          },
        ),
      );
    }

    return widgets;
  }

  Widget _buildAttachmentCard({
    required String type,
    required String name,
    String? transcript,
    String? duration,
    required VoidCallback onRemove,
    VoidCallback? onPlay,
  }) {
    if (type == 'voice') {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mic, size: 16, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Voice Note (${duration ?? '0:00'})',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onPlay,
                  child: Icon(
                    _isPlaying && _currentPlayingPath == name ? Icons.pause : Icons.play_arrow,
                    size: 16,
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
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
                name,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.grey[600],
                  letterSpacing: 0,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
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
                                  if (_isTranscribing)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: Colors.grey,
                                        ),
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
                      children: _buildAttachmentsList(),
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
                  // Additional Settings Accordion
                  _buildAdditionalSettingsAccordion(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalSettingsAccordion() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accordion Header
          GestureDetector(
            onTap: () {
              setState(() {
                _isAdditionalSettingsExpanded = !_isAdditionalSettingsExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  'Additional Settings',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isAdditionalSettingsExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Accordion Content
          if (_isAdditionalSettingsExpanded) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Priority selection
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

                  const SizedBox(height: 16),

                  // Due date
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

                  const SizedBox(height: 20),

                  // Delete button
                  if (widget.task != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showDeleteConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red[700],
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.red[200]!),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delete Task',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Task',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this task? This action cannot be undone.',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop('deleted'); // Return 'deleted' to parent
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriorityChip(String priority, String label, Color color) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _selectedPriority = priority;
          });
        }
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
}
