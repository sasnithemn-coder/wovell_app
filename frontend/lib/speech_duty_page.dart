// speech_duty_page.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'public_speaking.dart';
import 'package:intl/intl.dart';

class SpeechDutyPage extends StatefulWidget {
  const SpeechDutyPage({super.key});

  @override
  State<SpeechDutyPage> createState() => _SpeechDutyPageState();
}

class _SpeechDutyPageState extends State<SpeechDutyPage> with TickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String _recordedPath = '';
  int _remainingSeconds = 120; // 2 minutes
  Timer? _countdownTimer;
  bool _blink = false;
  Timer? _blinkTimer;

  // Mock history (would normally load from storage or backend)
  List<Map<String, dynamic>> history = [];

  // Mock 7-day performance values (0..100)
  List<int> last7Performance = [55, 60, 70, 80, 75, 85, 78];

  // Speech-of-the-day candidates
  final List<String> sampleTopics = [
    'Most critical moment in your life',
    'Why should schools teach life skills?',
    'The value of tourism in Sri Lanka',
    'Why teamwork matters',
    'My role model',
    'Climate change and responsibility',
    'Technology and youth',
  ];

  String speechOfTheDay = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _computeSpeechOfTheDay();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // In real app, load history & performance from SharedPreferences or your backend
    final prefs = await SharedPreferences.getInstance();
    // mock load last7Performance if stored
    if (prefs.containsKey('perf')) {
      // expecting a comma-separated string
      final s = prefs.getString('perf')!;
      final arr = s.split(',').map((e) => int.tryParse(e) ?? 0).toList();
      if (arr.length == 7) last7Performance = arr;
    }

    // Load history (mock if none)
    if (prefs.containsKey('history')) {
      // For simplicity not parsing complex types here
    } else {
      history = [
        {'label': 'Yesterday', 'time': '01:35', 'score': 78, 'date': DateTime.now().subtract(const Duration(days: 1))},
        {'label': '03/10/2025', 'time': '01:20', 'score': 95, 'date': DateTime.now().subtract(const Duration(days: 2))},
        {'label': '02/10/2025', 'time': '02:03', 'score': 30, 'date': DateTime.now().subtract(const Duration(days: 3))},
      ];
    }
    setState(() {});
  }

  void _computeSpeechOfTheDay() {
    // Deterministic pick: rotate by day of year. Replace with AI endpoint if you want dynamic topics.
    final dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    speechOfTheDay = sampleTopics[dayOfYear % sampleTopics.length];
    setState(() {});
  }

  void _startCountdownAndRecord() async {
    // countdown view then start recording
    _remainingSeconds = 120;
    _startBlinkingIfNeeded();
    // request permission and start recorder
    bool hasPermission = await _recorder.hasPermission();
    if (!mounted) return;
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone permission required')));
      return;
    }

    // Show countdown modal and start recording when countdown hits 0
    int preCount = 3;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Timer.periodic(const Duration(seconds: 1), (t) {
          if (preCount == 1) {
            t.cancel();
            Navigator.of(ctx).pop(); // close countdown
            _beginRecording(); // start actual recording & 2-min countdown
          } else {
            setState(() => preCount--);
          }
        });
        return AlertDialog(
          backgroundColor: const Color(0xFF003366),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SizedBox(
            height: 120,
            child: Center(
              child: Text(
                preCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  void _beginRecording() async {
  try {
    final directory = Directory.systemTemp;
    final filePath = '${directory.path}/speech_${DateTime.now().millisecondsSinceEpoch}.m4a';

    // ✅ Proper way for record v5.x
    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    );

    await _recorder.start(config, path: filePath);

    setState(() {
      _isRecording = true;
      _recordedPath = filePath;
      _remainingSeconds = 120;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 30) {
        _startBlinkingIfNeeded();
      }

      if (_remainingSeconds <= 0) {
        _stopRecordingAndAnalyze();
      }
    });
  } catch (e) {
    debugPrint('record start error: $e');
  }
}

  void _startBlinkingIfNeeded() {
    _blinkTimer?.cancel();
    if (_remainingSeconds <= 30 && _isRecording) {
      _blink = true;
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 600), (t) {
        setState(() {
          _blink = !_blink;
        });
      });
    } else {
      _blink = false;
      _blinkTimer?.cancel();
    }
  }

  Future<void> _stopRecordingAndAnalyze() async {
    try {
      _countdownTimer?.cancel();
      _blinkTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        _blink = false;
      });

      final path = await _recorder.stop();
      // path could be null on some platforms
      if (!mounted) return;
      if (path != null) {
        _recordedPath = path;
        // Save to history mock
        final score = _mockScoreFromAudio(); // replace with real AI analysis call
        final label = DateFormat('dd/MM/yyyy').format(DateTime.now());
        history.insert(0, {'label': 'Today', 'time': _formatDuration(120 - _remainingSeconds), 'score': score, 'date': DateTime.now(), 'path': path});
        // update last7Performance (rotate)
        last7Performance.removeAt(0);
        last7Performance.add(score);
        // persist performance if desired
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('perf', last7Performance.join(','));
        if (!mounted) return;
        setState(() {});
        // show analysis modal
        _showEvaluationModal(label, score, path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording failed')));
      }
    } catch (e) {
      debugPrint('stop error: $e');
    }
  }

  int _mockScoreFromAudio() {
    // Mock scoring: produce a score between 30..95 based on time left
    final rand = DateTime.now().millisecond % 60;
    final base = 60 + (rand % 35); // 60..94
    return base;
  }

  String _formatDuration(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _showEvaluationModal(String label, int score, String? audioPath) {
    // In real app: send audioPath file to your AI/STT+analysis pipeline (Whisper->GPT)
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (ctx, setState) {
        // we might fetch remote feedback here; currently mocked
        final String feedback = _generateMockFeedback(score);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            padding: const EdgeInsets.all(18),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Evaluation - $label', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(feedback, style: const TextStyle(fontSize: 14), textAlign: TextAlign.left),
                const SizedBox(height: 16),
                const Align(alignment: Alignment.centerLeft, child: Text('Last 7 days', style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                SizedBox(height: 80, child: _SevenDayMiniChart(values: last7Performance)),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7B00)),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _generateMockFeedback(int score) {
    if (score >= 85) {
      return 'Excellent delivery. Good pace, minimal filler words, strong vocal variety. Try to add a short rhetorical question to engage the audience.';
    } else if (score >= 70) {
      return 'Good delivery. Your clarity and confidence are solid. Work on pausing more deliberately between points for emphasis.';
    } else if (score >= 50) {
      return 'Average. Watch for filler words and quick pacing. Record again focusing on slower, clearer sentences.';
    } else {
      return 'Needs improvement. Practice voice projection and vary pitch. Try to rehearse the opening and conclusion more.';
    }
  }

  // Called when user taps evaluation on a past record
  void _openEvaluationForHistory(Map<String, dynamic> item) {
    final score = item['score'] as int? ?? 0;
    final label = item['label'] ?? DateFormat('dd/MM/yyyy').format(item['date'] ?? DateTime.now());
    _showEvaluationModal(label, score, item['path']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Rounded corners and full-screen gradient like wireframe
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF008080), Color(0xFF003366)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PublicSpeakingPage()));
                      },
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const Text('SpeechDuty', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
                          },
                          child: const Icon(Icons.notifications_none, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                          },
                          child: const CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/male_avatar.png')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset('assets/speech_duty_banner.png', fit: BoxFit.cover, height: 220, width: double.infinity),
                ),
              ),

              // "Today" card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: Column(
                    children: [
                      // Today's big card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 6),
                            Text('Topic : $speechOfTheDay', style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // Mic big button center-left
                                GestureDetector(
                                  onTap: () {
                                    if (!_isRecording) {
                                      _startCountdownAndRecord();
                                    } else {
                                      // manual stop
                                      _stopRecordingAndAnalyze();
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 86,
                                        height: 86,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(colors: [Color(0xFFFF7B00), Colors.orangeAccent]),
                                        ),
                                      ),
                                      Icon(_isRecording ? Icons.mic : Icons.mic_none, size: 36, color: Colors.white),
                                      // Blinking red ring when <=30s remaining
                                      if (_isRecording && (_remainingSeconds <= 30))
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 400),
                                            opacity: _blink ? 1.0 : 0.15,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent, boxShadow: [
                                                BoxShadow(color: Colors.redAccent.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2),
                                              ]),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 18),
                                // Time & evaluation controls
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(width: 16),
                                        Text(_formatDuration(120 - _remainingSeconds), style: const TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Evaluate today's (if recorded)
                                            final entry = history.isNotEmpty ? history.first : null;
                                            if (entry != null) {
                                              _openEvaluationForHistory(entry);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No recording yet')));
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7B00)),
                                          child: const Text('Evaluation'),
                                        ),
                                        const SizedBox(width: 16),
                                        // perf indicator (small gradient bar with label)
                                        Column(
                                          children: [
                                            Container(
                                              width: 160,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                gradient: const LinearGradient(colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue]),
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Marker based on last value
                                                  Positioned(
                                                    left: (last7Performance.last / 100) * 160 - 6, // -6 to centre
                                                    top: -6,
                                                    child: Column(
                                                      children: [
                                                        const Icon(Icons.arrow_drop_down, color: Colors.black, size: 18),
                                                        Text(_perfLabel(last7Performance.last), style: const TextStyle(fontSize: 10)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text('Average', style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // History list - each box
                      Column(
                        children: history.map((item) {
                          final score = item['score'] as int? ?? 0;
                          final label = item['label'] ?? DateFormat('dd/MM/yyyy').format(item['date']);
                          final time = item['time'] ?? '01:00';
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // left column
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () => _openEvaluationForHistory(item),
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7B00)),
                                      child: const Text('Evaluation'),
                                    ),
                                  ],
                                ),

                                // middle progress bar & label
                                SizedBox(
                                  width: 140,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              // Play recorded audio if available - placeholder
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Play recording (not implemented)')));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: const Color(0xFFFFF1E6), shape: BoxShape.circle),
                                              child: const Icon(Icons.mic, size: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // small color bar with marker
                                      Stack(
                                        children: [
                                          Container(height: 10, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: const LinearGradient(colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue]))),
                                          Positioned(
                                            left: (score / 100) * 140 - 8,
                                            top: -2,
                                            child: Column(
                                              children: [
                                                const Icon(Icons.arrow_drop_down, color: Colors.black, size: 16),
                                                Text(_perfLabel(score), style: const TextStyle(fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
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

  String _perfLabel(int val) {
    if (val >= 85) return 'Perfect';
    if (val >= 70) return 'Good';
    if (val >= 50) return 'Average';
    return 'Bad';
  }
}

// Small custom widget to draw seven vertical bars representing performance
class _SevenDayMiniChart extends StatelessWidget {
  final List<int> values; // length 7
  const _SevenDayMiniChart({required this.values, super.key});

  @override
  Widget build(BuildContext context) {
    final maxVal = values.reduce((a, b) => a > b ? a : b).clamp(1, 100);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((v) {
        final height = (v / maxVal) * 60 + 6; // min bar height
        final color = _barColor(v);
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(width: 12, height: height, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 6),
            const SizedBox(
              height: 12,
              child: Text('', style: TextStyle(fontSize: 8)),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _barColor(int v) {
    if (v >= 85) return Colors.blue;
    if (v >= 70) return Colors.green;
    if (v >= 50) return Colors.orange;
    return Colors.redAccent;
  }
}
