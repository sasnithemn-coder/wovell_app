import 'dart:async';
import 'package:flutter/material.dart';

class SpeechDutyPage extends StatefulWidget {
  const SpeechDutyPage({super.key});

  @override
  State<SpeechDutyPage> createState() => _SpeechDutyPageState();
}

// --- MODEL CLASS ---------------------------------------------------

class SpeechLog {
  final String id;
  final String label;
  final String topic;
  final Duration duration;
  final Evaluation evaluation;
  final DateTime date;

  SpeechLog({
    required this.id,
    required this.label,
    required this.topic,
    required this.duration,
    required this.evaluation,
    required this.date,
  });
}

enum Evaluation { bad, average, good, perfect }

extension EvaluationExt on Evaluation {
  String get label {
    switch (this) {
      case Evaluation.bad:
        return 'Bad';
      case Evaluation.average:
        return 'Average';
      case Evaluation.good:
        return 'Good';
      case Evaluation.perfect:
        return 'Perfect';
    }
  }

  double get progress {
    switch (this) {
      case Evaluation.bad:
        return 0.25;
      case Evaluation.average:
        return 0.5;
      case Evaluation.good:
        return 0.75;
      case Evaluation.perfect:
        return 1.0;
    }
  }

  Color get color {
    switch (this) {
      case Evaluation.bad:
        return Colors.red;
      case Evaluation.average:
        return Colors.orange;
      case Evaluation.good:
        return Colors.green;
      case Evaluation.perfect:
        return Colors.blue;
    }
  }
}

// --- MAIN PAGE -----------------------------------------------------

class _SpeechDutyPageState extends State<SpeechDutyPage>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  int elapsedSeconds = 0;
  Timer? _timer;
  late AnimationController _blinkController;
  static const int maxSeconds = 120;
  late List<SpeechLog> logs;

  @override
  void initState() {
    super.initState();
    logs = _dummyLogs();
    _blinkController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  List<SpeechLog> _dummyLogs() {
    final now = DateTime.now();
    return [
      SpeechLog(
        id: 'today',
        label: 'Today',
        topic: _dailyTopic(),
        duration: const Duration(minutes: 1, seconds: 54),
        evaluation: Evaluation.average,
        date: now,
      ),
      SpeechLog(
        id: 'yesterday',
        label: 'Yesterday',
        topic: 'Preparing for an unexpected interview',
        duration: const Duration(minutes: 1, seconds: 35),
        evaluation: Evaluation.good,
        date: now.subtract(const Duration(days: 1)),
      ),
      SpeechLog(
        id: '03/10/2025',
        label: '03/10/2025',
        topic: 'The loudest lesson I learned',
        duration: const Duration(minutes: 1, seconds: 20),
        evaluation: Evaluation.perfect,
        date: now.subtract(const Duration(days: 2)),
      ),
      SpeechLog(
        id: '02/10/2025',
        label: '02/10/2025',
        topic: 'A challenging teamwork moment',
        duration: const Duration(minutes: 2, seconds: 3),
        evaluation: Evaluation.bad,
        date: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  String _dailyTopic() {
    final topics = [
      'Most critical moment in your life',
      'A time you failed and learned',
      'Your proudest achievement',
      'A habit you would like to change',
      'A person who inspired you',
    ];
    final idx = DateTime.now().day % topics.length;
    return topics[idx];
  }

  void _toggleRecording() {
    if (isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _startRecording() {
    setState(() {
      isRecording = true;
      elapsedSeconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => elapsedSeconds++);
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() {
      isRecording = false;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showEvaluation(SpeechLog log) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${log.label} - ${log.evaluation.label}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Topic: ${log.topic}',
                style: const TextStyle(fontSize: 15, color: Colors.black54)),
            const SizedBox(height: 12),
            const Text(
              'Your speech pace was consistent. Try improving clarity and emphasis.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              child: const Text('Close'),
            )
          ]),
        );
      },
    );
  }

  // ---------- UI PARTS ----------

  Widget _buildHeader() {
    return Positioned(
      top: 16,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: const [
              Icon(Icons.notifications_none, color: Colors.white),
              SizedBox(width: 10),
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/avatar_male_medium_casual.png'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _todayCard() {
    final log = logs.first;
    final overLimit = elapsedSeconds > maxSeconds;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Topic : ${log.topic}',
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
            const SizedBox(height: 16),
            Row(children: [
              GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedBuilder(
                  animation: _blinkController,
                  builder: (context, _) {
                    final blink = _blinkController.value;
                    return Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange]),
                        border: Border.all(
                            color: overLimit
                                ? Colors.red.withValues(alpha: 0.5 + blink * 0.5)
                                : Colors.orange.shade900,
                            width: overLimit ? 4 : 2),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2)
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(isRecording ? Icons.stop : Icons.mic,
                                color: Colors.white, size: 32),
                            const SizedBox(height: 5),
                            Text(
                              _formatTime(elapsedSeconds),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showEvaluation(log),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange),
                        child: const Text('Evaluation'),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: log.evaluation.progress,
                        backgroundColor: Colors.grey.shade300,
                        color: log.evaluation.color,
                        minHeight: 10,
                      ),
                      const SizedBox(height: 4),
                      Text(log.evaluation.label,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      if (overLimit)
                        const Text('Time limit exceeded!',
                            style: TextStyle(color: Colors.red))
                    ]),
              )
            ])
          ],
        ),
      ),
    );
  }

  Widget _logCard(SpeechLog log) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () => _showEvaluation(log),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange),
                    child: const Text('Evaluation'),
                  )
                ]),
            Column(
              children: [
                Text(
                  '${log.duration.inMinutes.toString().padLeft(2, '0')}:${(log.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: log.evaluation.progress,
                  backgroundColor: Colors.grey.shade300,
                  color: log.evaluation.color,
                  minHeight: 8,
                ),
                const SizedBox(height: 4),
                Text(log.evaluation.label,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[800],
      body: SafeArea(
        child: Column(children: [
          // HEADER SECTION
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Image.asset(
                  'assets/speech_duty_banner.jpg',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              _buildHeader(),
              const Positioned(
                bottom: 50,
                left: 24,
                child: Text(
                  'WARM UP YOUR VOICE\nAND SPEAK CONFIDENT',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2),
                ),
              ),
              const Positioned(
                bottom: 12,
                left: 24,
                child: Text(
                  'SpeechDuty',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),

          // CONTENT BELOW
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade800, Colors.blue.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  _todayCard(),
                  for (int i = 1; i < logs.length; i++) _logCard(logs[i]),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
