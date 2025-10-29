import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class _SpeechDutyPageState extends State<SpeechDutyPage>
    with TickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String _recordedPath = '';
  int _remainingSeconds = 120;
  Timer? _countdownTimer;
  bool _blink = false;
  Timer? _blinkTimer;

  List<Map<String, dynamic>> history = [];
  List<int> last7Performance = [55, 60, 70, 80, 75, 85, 78];

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
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('perf')) {
      final s = prefs.getString('perf')!;
      final arr = s.split(',').map((e) => int.tryParse(e) ?? 0).toList();
      if (arr.length == 7) last7Performance = arr;
    } else {
      history = [
        {
          'label': 'Yesterday',
          'time': '01:35',
          'score': 78,
          'date': DateTime.now().subtract(const Duration(days: 1))
        },
        {
          'label': '03/10/2025',
          'time': '01:20',
          'score': 95,
          'date': DateTime.now().subtract(const Duration(days: 2))
        },
        {
          'label': '02/10/2025',
          'time': '02:03',
          'score': 30,
          'date': DateTime.now().subtract(const Duration(days: 3))
        },
      ];
    }
    setState(() {});
  }

  void _computeSpeechOfTheDay() {
    final dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    speechOfTheDay = sampleTopics[dayOfYear % sampleTopics.length];
    setState(() {});
  }

  void _startCountdownAndRecord() async {
    _remainingSeconds = 120;
    _startBlinkingIfNeeded();

    bool hasPermission = await _recorder.hasPermission();
    if (!mounted) return;
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission required')));
      return;
    }

    int preCount = 3;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Timer.periodic(const Duration(seconds: 1), (t) {
          if (preCount == 1) {
            t.cancel();
            Navigator.of(ctx).pop();
            _beginRecording();
          } else {
            setState(() => preCount--);
          }
        });
        return AlertDialog(
          backgroundColor: const Color(0xFF003366),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          content: SizedBox(
            height: 120.h,
            child: Center(
              child: Text(
                preCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                ),
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
      final filePath =
          '${directory.path}/speech_${DateTime.now().millisecondsSinceEpoch}.m4a';

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
      if (!mounted) return;
      if (path != null) {
        _recordedPath = path;
        final score = _mockScoreFromAudio();
        final label = DateFormat('dd/MM/yyyy').format(DateTime.now());
        history.insert(0, {
          'label': 'Today',
          'time': _formatDuration(120 - _remainingSeconds),
          'score': score,
          'date': DateTime.now(),
          'path': path
        });
        last7Performance.removeAt(0);
        last7Performance.add(score);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('perf', last7Performance.join(','));
        if (!mounted) return;
        setState(() {});
        _showEvaluationModal(label, score, path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recording failed')));
      }
    } catch (e) {
      debugPrint('stop error: $e');
    }
  }

  int _mockScoreFromAudio() {
    final rand = DateTime.now().millisecond % 60;
    final base = 60 + (rand % 35);
    return base;
  }

  String _formatDuration(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _showEvaluationModal(String label, int score, String? audioPath) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) {
          final feedback = _generateMockFeedback(score);
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
            child: Container(
              padding: EdgeInsets.all(18.w),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Evaluation - $label',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  Text(feedback,
                      style: TextStyle(fontSize: 14.sp),
                      textAlign: TextAlign.left),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Last 7 days',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                      height: 80.h,
                      child: _SevenDayMiniChart(values: last7Performance)),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7B00)),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _generateMockFeedback(int score) {
    if (score >= 85) {
      return 'Excellent delivery. Good pace and strong vocal variety.';
    } else if (score >= 70) {
      return 'Good clarity and confidence. Work on pauses for emphasis.';
    } else if (score >= 50) {
      return 'Average. Watch filler words and pacing.';
    } else {
      return 'Needs improvement. Focus on projection and pitch variation.';
    }
  }

  void _openEvaluationForHistory(Map<String, dynamic> item) {
    final score = item['score'] as int? ?? 0;
    final label = item['label'] ??
        DateFormat('dd/MM/yyyy').format(item['date'] ?? DateTime.now());
    _showEvaluationModal(label, score, item['path']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // 🔹 Top bar
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PublicSpeakingPage()),
                        );
                      },
                      child:
                          Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
                    ),
                    Text('SpeechDuty',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsPage()),
                            );
                          },
                          child:
                              Icon(Icons.notifications_none, color: Colors.white, size: 22.sp),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfilePage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 16.r,
                            backgroundImage:
                                const AssetImage('assets/male_avatar.png'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔹 Banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Image.asset(
                    'assets/speech_duty_banner.png',
                    fit: BoxFit.cover,
                    height: 220.h,
                    width: double.infinity,
                  ),
                ),
              ),

              // 🔹 Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 12.h),
                  child: Column(
                    children: [
                      // ✅ Fixed Today card
                      _buildTodayCard(),
                      SizedBox(height: 12.h),
                      // ✅ History list
                      ...history.map((item) => _buildHistoryCard(item)),
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

  Widget _buildTodayCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18.sp)),
          SizedBox(height: 6.h),
          Text('Topic : $speechOfTheDay',
              style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMicButton(),
              SizedBox(width: 18.w),
              Expanded(child: _buildTimerAndPerformance()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: () {
        if (!_isRecording) {
          _startCountdownAndRecord();
        } else {
          _stopRecordingAndAnalyze();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7B00), Colors.orangeAccent],
              ),
            ),
          ),
          Icon(
            _isRecording ? Icons.mic : Icons.mic_none,
            size: 36.sp,
            color: Colors.white,
          ),
          if (_isRecording && (_remainingSeconds <= 30))
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _blink ? 1.0 : 0.15,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                        blurRadius: 8.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimerAndPerformance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Time',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.sp)),
            SizedBox(width: 16.w),
            Text(_formatDuration(120 - _remainingSeconds),
                style: TextStyle(fontSize: 16.sp)),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                final entry = history.isNotEmpty ? history.first : null;
                if (entry != null) {
                  _openEvaluationForHistory(entry);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No recording yet')));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7B00)),
              child: Text('Evaluation',
                  style: TextStyle(fontSize: 14.sp)),
            ),
            SizedBox(width: 16.w),
            Column(
              children: [
                Container(
                  width: 150.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.orange,
                        Colors.yellow,
                        Colors.green,
                        Colors.blue
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // ✅ Overflow-proof marker
                      Positioned(
                        left: ((last7Performance.last / 100) * 150.w - 6.w)
                            .clamp(0.0, 150.w - 12.w),
                        top: -6.h,
                        child: Column(
                          children: [
                            Icon(Icons.arrow_drop_down,
                                color: Colors.black, size: 18.sp),
                            Text(_perfLabel(last7Performance.last),
                                style: TextStyle(fontSize: 10.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text('Average',
                    style: TextStyle(
                        fontSize: 10.sp, color: Colors.grey[700])),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ✅ History card with same fix
  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final score = item['score'] as int? ?? 0;
    final label = item['label'] ??
        DateFormat('dd/MM/yyyy').format(item['date']);
    final time = item['time'] ?? '01:00';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              ElevatedButton(
                onPressed: () => _openEvaluationForHistory(item),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7B00)),
                child: Text('Evaluation', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
          SizedBox(
            width: 140.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(time,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFF1E6),
                          shape: BoxShape.circle),
                      child: Icon(Icons.mic, size: 16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Stack(
                  children: [
                    Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: ((score / 100) * 140.w - 8.w)
                          .clamp(0.0, 140.w - 14.w),
                      top: -2.h,
                      child: Column(
                        children: [
                          Icon(Icons.arrow_drop_down,
                              color: Colors.black, size: 16.sp),
                          Text(_perfLabel(score),
                              style: TextStyle(fontSize: 10.sp)),
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
  }

  String _perfLabel(int val) {
    if (val >= 85) return 'Perfect';
    if (val >= 70) return 'Good';
    if (val >= 50) return 'Average';
    return 'Bad';
  }
}

class _SevenDayMiniChart extends StatelessWidget {
  final List<int> values;
  const _SevenDayMiniChart({required this.values, super.key});

  @override
  Widget build(BuildContext context) {
    final maxVal = values.reduce((a, b) => a > b ? a : b).clamp(1, 100);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((v) {
        final height = (v / maxVal) * 60.h + 6.h;
        final color = _barColor(v);
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 12.w,
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              height: 12.h,
              child: const Text('', style: TextStyle(fontSize: 8)),
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
