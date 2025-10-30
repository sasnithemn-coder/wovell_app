// lib/voz_hut.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'public_speaking.dart';
import 'package:intl/intl.dart';

const String backendBase = 'https://your-backend.example.com';

class VozHutPage extends StatefulWidget {
  const VozHutPage({super.key});
  @override
  State<VozHutPage> createState() => _VozHutPageState();
}

class _VozHutPageState extends State<VozHutPage> {
  final List<Map<String, String>> topics = [
    {'title': 'Effective communication', 'level': 'Easy'},
    {'title': 'Value of tourism in Sri Lanka', 'level': 'Easy'},
    {'title': 'Team sports build strong individuals', 'level': 'Easy'},
    {'title': 'Harmness of pollution', 'level': 'Easy'},
    {'title': 'Social customs are a waste of time', 'level': 'Medium'},
    {'title': 'Don’t judge a book by its cover', 'level': 'Medium'},
    {'title': 'Challenging Gender Bias in Education', 'level': 'Hard'},
    {'title': 'Poverty is a state of mind', 'level': 'Hard'},
  ];

  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final s = prefs.getString('voz_history');
    if (s != null) {
      final arr = jsonDecode(s) as List;
      _history = arr.map((e) => Map<String, dynamic>.from(e)).toList();
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voz_history', jsonEncode(_history));
  }

  void _openPractice(String topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VozHutPracticePage(topic: topic, onSaved: _onPracticeSaved),
      ),
    );
  }

  void _onPracticeSaved(Map<String, dynamic> item) {
    _history.insert(0, item);
    if (_history.length > 50) _history.removeLast();
    _saveHistory();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Ensure ScreenUtil is initialized in main.dart. This file assumes it is.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF008080), Color(0xFF003366)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PublicSpeakingPage()),
                      ),
                      child: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 18.sp),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NotificationsPage()),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Icon(Icons.notifications_none,
                                color: Colors.white, size: 22.sp),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfilePage()),
                          ),
                          child: CircleAvatar(
                            radius: 18.r,
                            backgroundImage:
                                const AssetImage('assets/male_avatar.png'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Image.asset(
                    'assets/voz_hut_banner.png',
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    children: [
                      ...topics.map(
                        (t) => _TopicCard(
                          title: t['title']!,
                          level: t['level']!,
                          onStart: () => _openPractice(t['title']!),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (_history.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text(
                              'Recent',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ..._history.map((h) => _HistoryTile(entry: h)),
                      ],
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final String title;
  final String level;
  final VoidCallback onStart;
  const _TopicCard(
      {required this.title, required this.level, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '“$title”',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  level,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              padding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            child: Text('Start',
                style: TextStyle(color: Colors.black, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final Map<String, dynamic> entry;
  const _HistoryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final date = entry['date'] ?? '';
    final score = entry['score'];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry['topic'] ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.sp)),
                SizedBox(height: 6.h),
                Text(
                  date.toString().split(' ').first,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            children: [
              if (score != null)
                Text('Score: $score',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              SizedBox(height: 6.h),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Evaluation'),
                    content: Text(entry['feedback'] ?? 'No feedback'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'))
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7B00),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r))),
                child: Text('Evaluation', style: TextStyle(fontSize: 13.sp)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Practice page — records, uploads, plays & saves history
class VozHutPracticePage extends StatefulWidget {
  final String topic;
  final ValueChanged<Map<String, dynamic>> onSaved;
  const VozHutPracticePage(
      {required this.topic, required this.onSaved, super.key});
  @override
  State<VozHutPracticePage> createState() => _VozHutPracticePageState();
}

class _VozHutPracticePageState extends State<VozHutPracticePage> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  String _audioPath = '';
  String _transcript = '';
  int _remainingSeconds = 120;
  Timer? _countdownTimer;
  bool _blink = false;
  Timer? _blinkTimer;
  bool _loading = false;
  String _feedback = '';
  int? _score;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _blinkTimer?.cancel();
    _player.dispose();
    _recorder.stop();
    super.dispose();
  }

  Future<void> _preCountdownAndStart() async {
    final has = await _recorder.hasPermission();
    if (!mounted) return;
    if (!has) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission required')));
      return;
    }

    int count = 3;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Timer.periodic(const Duration(seconds: 1), (t) {
          if (!mounted) {
            t.cancel();
            return;
          }
          if (count == 1) {
            t.cancel();
            Navigator.of(ctx).pop();
            _startRecording();
          } else {
            setState(() => count--);
          }
        });
        return AlertDialog(
          backgroundColor: const Color(0xFF003366),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          content: SizedBox(
            height: 120.h,
            child: Center(
              child: Text(
                count.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _startRecording() async {
    try {
      if (!mounted) return;
      final dir = Directory.systemTemp;
      final path =
          '${dir.path}/voz_${DateTime.now().millisecondsSinceEpoch}.m4a';
      const config =
          RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100);
      await _recorder.start(config, path: path);
      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _audioPath = path;
        _remainingSeconds = 120;
      });

      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() {
          _remainingSeconds--;
        });
        if (_remainingSeconds <= 30) _startBlinking();
        if (_remainingSeconds <= 0) {
          t.cancel();
          _stopAndUpload();
        }
      });
    } catch (e) {
      debugPrint('start recording error: $e');
    }
  }

  void _startBlinking() {
    _blinkTimer?.cancel();
    _blink = true;
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _blink = !_blink);
    });
  }

  Future<void> _stopAndUpload() async {
    try {
      _countdownTimer?.cancel();
      _blinkTimer?.cancel();
      if (!mounted) return;
      final path = await _recorder.stop();
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        _blink = false;
      });

      if (path == null || path.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Recording failed')));
        return;
      }

      if (!mounted) return;
      await _player.setFilePath(path);

      if (!mounted) return;
      await _uploadForAnalysis(path);
    } catch (e) {
      debugPrint('stop error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Recording failed')));
    }
  }

  Future<void> _uploadForAnalysis(String filePath) async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final uri = Uri.parse('$backendBase/transcribe-and-eval');
      final request = http.MultipartRequest('POST', uri);
      request.fields['topic'] = widget.topic;
      if (!mounted) return;
      request.files.add(await http.MultipartFile.fromPath(
          'file', filePath,
          filename:
              'voz_${DateTime.now().millisecondsSinceEpoch}.m4a'));
      if (!mounted) return;
      final streamed = await request.send();
      if (!mounted) return;
      final resp = await http.Response.fromStream(streamed);

      if (resp.statusCode != 200) {
        debugPrint('upload failed: ${resp.statusCode} ${resp.body}');
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Upload failed')));
        setState(() => _loading = false);
        return;
      }

      final Map<String, dynamic> resJson = jsonDecode(resp.body);
      final transcript = resJson['transcript'] ?? '';
      final evaluation = resJson['evaluation'] ?? '';
      final score = resJson['score'];

      if (!mounted) return;
      setState(() {
        _feedback = evaluation.toString();
        _transcript = transcript.toString();
        _score = score is int ? score : null;
        _loading = false;
      });

      final entry = {
        'topic': widget.topic,
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'path': filePath,
        'transcript': transcript,
        'feedback': evaluation,
        'score': _score,
      };
      widget.onSaved(entry);

      _showEvaluationDialog(evaluation, transcript, _score);
    } catch (e) {
      debugPrint('upload error: $e');
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Analysis failed')));
    }
  }

  void _showEvaluationDialog(String eval, String transcript, int? score) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Evaluation'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (score != null)
                Text('Score: $score\n', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Transcript:\n$transcript\n\nFeedback:\n$eval'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))
        ],
      ),
    );
  }

  Future<void> _play() async {
    if (!mounted) return;
    if (_audioPath.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No recording to play')));
      return;
    }
    try {
      if (!mounted) return;
      await _player.setFilePath(_audioPath);
      if (!mounted) return;
      _player.play();
    } catch (e) {
      debugPrint('play error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Playback error')));
    }
  }

  String _formatDuration(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final double micBase = 120.w;
    final double micSize = min(micBase, max(72.w, screenW * 0.22));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF008080), Color(0xFF003366)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Icon(Icons.notifications_none, color: Colors.white, size: 22.sp),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                          child: CircleAvatar(radius: 18.r, backgroundImage: const AssetImage('assets/male_avatar.png')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text('“${widget.topic}”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(color: const Color(0xFFFF7B00), borderRadius: BorderRadius.circular(14.r)),
                        child: Text('Guidelines', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 28.h),
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14.r)),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6.h),
                            Text('• What\'s call effective communication', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                            SizedBox(height: 6.h),
                            Text('• Value of effective communication', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                            SizedBox(height: 6.h),
                            Text('• Basics of effective communication', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                            SizedBox(height: 6.h),
                            Text('• How can we improve this skill', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
                  child: Column(
                    children: [
                      SizedBox(height: 6.h),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _isRecording ? _stopAndUpload() : _preCountdownAndStart(),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: micSize,
                                    height: micSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(colors: [Color(0xFFFF7B00), Color(0xFFF57C00)]),
                                    ),
                                  ),
                                  Icon(_isRecording ? Icons.mic : Icons.mic_none, size: (micSize * 0.36).clamp(28.w, 44.w), color: Colors.white),
                                  if (_isRecording && (_remainingSeconds <= 30))
                                    Positioned(
                                      bottom: max(4.h, micSize * 0.04),
                                      right: max(6.w, micSize * 0.05),
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 500),
                                        opacity: _blink ? 1.0 : 0.15,
                                        child: Container(
                                          width: (micSize * 0.14).clamp(12.w, 20.w),
                                          height: (micSize * 0.14).clamp(12.w, 20.w),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(_formatDuration(_remainingSeconds),
                                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold)),
                            SizedBox(height: 12.h),
                            if (_loading) CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: _feedback.isNotEmpty ? () => _showEvaluationDialog(_feedback, _transcript, _score) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7B00),
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            ),
                            child: Text('Evaluation', style: TextStyle(fontSize: 14.sp)),
                          ),
                          ElevatedButton(
                            onPressed: _audioPath.isNotEmpty ? _play : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7B00),
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            ),
                            child: Text('Play', style: TextStyle(fontSize: 14.sp)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
