import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'package:record/record.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
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
  bool _isTranscribing = false;
  List<String> _attachments = [];
  List<Map<String, String>> _voiceNotes = []; // Enhanced to store audio + transcript
  bool _isEditMode = false;
  late AnimationController _recordingAnimationController;
  late AnimationController _pulseAnimationController;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String _selectedTag = 'work';
  
  // Speech-to-text functionality - COMMENTED OUT FOR iOS SIMULATOR TESTING
  final Record _audioRecorder = Record();
  // final stt.SpeechToText _speechToText = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  // bool _speechEnabled = false;
  String _currentTranscript = '';
  String? _currentPlayingPath;
  bool _isPlaying = false;

  // Mock transcription data for testing
  final List<String> _mockTranscripts = [
    "This is a mock transcription for testing purposes.",
    "Here's another sample transcript to simulate speech-to-text functionality.",
    "Meeting notes: Discussed project timeline and deliverables for Q4.",
    "Remember to follow up with the client about the proposal by Friday.",
    "Ideas for the presentation: focus on user experience and key metrics.",
  ];
  int _mockTranscriptIndex = 0;

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
    
    _initSpeech();
    _setupAudioPlayer();
  }

  void _initSpeech() async {
    // COMMENTED OUT FOR iOS SIMULATOR TESTING
    // Real speech-to-text initialization
    /*
    try {
      print('Initializing speech-to-text...');
      _speechEnabled = await _speechToText.initialize(
        onError: (error) => print('Speech init error: $error'),
        onStatus: (status) => print('Speech init status: $status'),
      );
      print('Speech-to-text initialized: $_speechEnabled');
      
      // Check if speech recognition is available
      if (_speechEnabled) {
        final locales = await _speechToText.locales();
        print('Available locales: ${locales.length}');
        final isAvailable = await _speechToText.hasPermission;
        print('Has permission: $isAvailable');
      }
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing speech-to-text: $e');
      _speechEnabled = false;
      if (mounted) {
        setState(() {});
      }
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
    _contentController.dispose();
    _recordingAnimationController.dispose();
    _pulseAnimationController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
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
      // Start speech-to-text if available, but don't fail if it doesn't work
      if (_speechEnabled) {
        print('Starting speech-to-text listening...');
        print('Speech-to-text isListening: ${_speechToText.isListening}');
        print('Speech-to-text isAvailable: ${_speechToText.isAvailable}');
        
        try {
          final started = await _speechToText.listen(
            onResult: (result) {
              print('Speech result received: "${result.recognizedWords}" (confidence: ${result.confidence})');
              if (mounted && result.recognizedWords.isNotEmpty) {
                setState(() {
                  _currentTranscript = result.recognizedWords;
                });
              }
            },
            onSoundLevelChange: (level) {
              print('Sound level: $level');
            },
          );
          print('Speech listening started: $started');
        } catch (e) {
          print('Speech-to-text listen failed: $e');
        }
      } else {
        print('Speech-to-text not available, recording audio only');
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
            
            // Add mock transcribed text to the content field
            final currentText = _contentController.text;
            final newText = currentText.isEmpty 
                ? mockTranscript 
                : '$currentText\n\n$mockTranscript';
            _contentController.text = newText;
            
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
    
    // Voice notes with transcripts
    for (int i = 0; i < _voiceNotes.length; i++) {
      final voiceNote = _voiceNotes[i];
      widgets.add(
        Container(
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
                      'Voice Note ${i + 1} (${voiceNote['duration']})',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[600],
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
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      await _playVoiceNote(voiceNote['audio']!);
                    },
                    child: Icon(
                      _isPlaying && _currentPlayingPath == voiceNote['audio'] ? Icons.pause : Icons.play_arrow,
                      size: 16,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _contentController.text.isEmpty ? 'No content' : _contentController.text,
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: _contentController.text.isEmpty ? Colors.grey[500] : Colors.black,
                                letterSpacing: 0,
                                height: 1.5,
                              ),
                            ),
                            // Transcription indicator
                            if (_isTranscribing) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange[200]!),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]!),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Transcribing...',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: TextField(
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
                          // Transcription indicator for edit mode
                          if (_isTranscribing) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange[200]!),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Transcribing...',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
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
