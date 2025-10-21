import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'notifications.dart';
import 'profile_page.dart';

class SpeechDutyPage extends StatefulWidget {
  const SpeechDutyPage({super.key});

  @override
  State<SpeechDutyPage> createState() => _SpeechDutyPageState();
}

class _SpeechDutyPageState extends State<SpeechDutyPage> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _timeExceeded = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  final List<SpeechEvaluation> _evaluations = [];

  final List<String> _topics = [
    "A time you helped someone",
    "A proud moment in your life",
    "A challenge you overcame",
    "Describe your dream job",
    "A time you learned something new",
    "A place you want to visit",
    "A book that changed you",
    "A goal you set and achieved",
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _topicOfTheDay {
    final today = DateTime.now();
    final index = (today.year + today.month + today.day) % _topics.length;
    return _topics[index];
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();

    if (!mounted) return;

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
      return;
    }

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: 'speech_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    setState(() {
      _isRecording = true;
      _recordingDuration = Duration.zero;
      _timeExceeded = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _recordingDuration =
            Duration(seconds: _recordingDuration.inSeconds + 1);
        if (_recordingDuration.inSeconds >= 120) {
          _timeExceeded = true;
        }
      });
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stop();

    if (!mounted) return;
    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      _evaluateSpeech(path);
    }
  }

  void _evaluateSpeech(String path) {
    final seconds = _recordingDuration.inSeconds;
    int score;
    String remark;
    String description;

    if (seconds >= 115) {
      score = 95;
      remark = "Perfect";
      description = "Great pacing and confident delivery!";
    } else if (seconds >= 90) {
      score = 80;
      remark = "Good";
      description = "Good clarity and structure, slight improvement possible.";
    } else if (seconds >= 60) {
      score = 60;
      remark = "Average";
      description = "Average delivery, work on timing and confidence.";
    } else {
      score = 40;
      remark = "Needs improvement";
      description = "Too short or hesitant. Try speaking more freely.";
    }

    setState(() {
      _evaluations.insert(
        0,
        SpeechEvaluation(
          date: DateTime.now(),
          duration: _recordingDuration,
          score: score,
          remark: remark,
          description: description,
        ),
      );
      if (_evaluations.length > 7) _evaluations.removeLast();
    });
  }

  void _showEvaluationDetail(SpeechEvaluation eval) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("${eval.remark} · ${eval.score}/100"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Duration: ${_formatDuration(eval.duration)}"),
            const SizedBox(height: 12),
            Text(eval.description),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  Color _colorForRemark(String remark) {
    switch (remark) {
      case "Perfect":
        return Colors.green;
      case "Good":
        return Colors.teal;
      case "Average":
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF0D7C7C), Color(0xFF1A3A5C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== MOTSTAR-STYLE HEADER =====
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF0D7C7C), Color(0xFF1A3A5C)],
                  ),
                  border: Border(
                    bottom:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button + title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "SpeechDuty",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Notification + Avatar
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none,
                              color: Colors.white, size: 26),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const NotificationsPage()),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProfilePage()),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(
                                'assets/avatar_male_medium_casual.png'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== TODAY CARD =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Today",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        "Topic : $_topicOfTheDay",
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black54),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _isRecording
                                ? _stopRecording
                                : _startRecording,
                            child: Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isRecording
                                    ? (_timeExceeded
                                        ? Colors.redAccent
                                        : Colors.orangeAccent)
                                    : Colors.orange,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 8,
                                  )
                                ],
                              ),
                              child: const Icon(Icons.mic,
                                  color: Colors.white, size: 36),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Time',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 6),
                              Text(
                                _formatDuration(_recordingDuration),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              if (_timeExceeded) ...[
                                const SizedBox(height: 6),
                                const Text(
                                  "⚠ 2 min limit exceeded",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (_evaluations.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('No evaluation yet. Record first.')),
                                );
                              } else {
                                _showEvaluationDetail(_evaluations.first);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Evaluate",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ===== EVALUATION HISTORY =====
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: _evaluations.isEmpty
                      ? const Center(
                          child: Text(
                            'No evaluations yet. Record a speech to see results.',
                            style: TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _evaluations.length,
                          itemBuilder: (context, index) {
                            final eval = _evaluations[index];
                            return _buildEvaluationCard(eval);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvaluationCard(SpeechEvaluation eval) {
    final color = _colorForRemark(eval.remark);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat('dd/MM/yyyy').format(eval.date),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.mic, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text(_formatDuration(eval.duration),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Text(eval.remark,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: eval.score / 100,
            color: color,
            backgroundColor: Colors.grey.shade300,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showEvaluationDetail(eval),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Evaluation',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class SpeechEvaluation {
  final DateTime date;
  final Duration duration;
  final int score;
  final String remark;
  final String description;

  SpeechEvaluation({
    required this.date,
    required this.duration,
    required this.score,
    required this.remark,
    required this.description,
  });
}
