// lib/ai_audience_page.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'notifications.dart';
import 'profile_page.dart';

class AiAudiencePage extends StatefulWidget {
  const AiAudiencePage({super.key});

  @override
  State<AiAudiencePage> createState() => _AiAudiencePageState();
}

class _AiAudiencePageState extends State<AiAudiencePage>
    with TickerProviderStateMixin {
  bool _showRecordingSection = false;
  bool _isRecording = false;
  bool _isLoadingFeedback = false;

  String? _recordFilePath;
  Duration _recordDuration = Duration.zero;

  List<String> _feedbackList = [];

  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission required')),
      );
      return;
    }

    final appDir = Directory.systemTemp.path;
    final path =
        '$appDir/ai_audience_${DateTime.now().millisecondsSinceEpoch}.m4a';

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    );

    await _recorder.start(config, path: path);

    setState(() {
      _isRecording = true;
      _recordFilePath = path;
      _recordDuration = Duration.zero;
      _feedbackList.clear();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _recordDuration = Duration(seconds: _recordDuration.inSeconds + 1);
      });
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stop();

    if (path == null) return;

    setState(() {
      _isRecording = false;
      _recordFilePath = path;
    });

    await _sendAudioToAI(File(path));
  }

  Future<void> _sendAudioToAI(File audioFile) async {
    setState(() {
      _isLoadingFeedback = true;
      _feedbackList.clear();
    });

    try {
      final uri = Uri.parse("https://yourserver.com/api/analyze_speech");

      final request = http.MultipartRequest("POST", uri)
        ..files.add(await http.MultipartFile.fromPath('file', audioFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final jsonData = jsonDecode(body);

        if (jsonData["feedback"] != null) {
          setState(() {
            _feedbackList = List<String>.from(jsonData["feedback"]);
          });
        } else {
          setState(() {
            _feedbackList = ["No feedback received from AI."];
          });
        }
      } else {
        setState(() {
          _feedbackList = ["Error: ${response.statusCode} from server"];
        });
      }
    } catch (e) {
      setState(() {
        _feedbackList = ["Error sending audio: $e"];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFeedback = false;
        });
      }
    }
  }

  String _formatDuration(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20.sp),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsPage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.notifications_none, color: Colors.white, size: 22.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18.r,
                    backgroundImage: const AssetImage('assets/avatar.png'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _optionCard(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFFF),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: Offset(0, 4.h),
              blurRadius: 8.r,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF008080), Color(0xFF003366)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
              child: Image.asset(
                'assets/b31d5472-09aa-4349-a81d-3ac90220f0d9.jpg',
                height: 300.h,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildTopBar(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                "Welcome to AI\nAudience Platform !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              _optionCard("Diversity Simulation"),
              _optionCard("Dynamic Reaction"),
              _optionCard("Feedback Generator"),
              _optionCard("Challenge Mode"),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {
                  setState(() => _showRecordingSection = true);
                  _fadeController.forward(from: 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                  padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r)),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feedbackBubble(String text) {
    final isPositive =
        text.toLowerCase().contains('good') || text.toLowerCase().contains('well');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle,
              color: isPositive ? Colors.green : Colors.red, size: 26.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingSection() {
    final screenW = MediaQuery.of(context).size.width;
    final micBase = 110.w;
    final micSize = micBase.clamp(72.w, screenW * 0.26);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF008080), Color(0xFF003366)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/15bdd0c5-17cb-46df-8a82-f52a980232fc.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withValues(alpha: 0.4)),
          _buildTopBar(),
          Column(
            children: [
              SizedBox(height: 120.h),
              Expanded(
                child: _isLoadingFeedback
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        itemCount: _feedbackList.length,
                        itemBuilder: (context, index) =>
                            _feedbackBubble(_feedbackList[index]),
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isRecording ? _stopRecording : _startRecording,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF914D), Color(0xFFFF6D1A)],
                          ),
                        ),
                        width: micSize,
                        height: micSize,
                        alignment: Alignment.center,
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: (micSize * 0.38).clamp(28.w, 48.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      _formatDuration(_recordDuration),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (_, __) => Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: _showRecordingSection
              ? _buildRecordingSection()
              : _buildIntroSection(),
        ),
      ),
    );
  }
}
