import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
  // State variables
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

  // ---------------------------------------------------------------------------
  // AUDIO RECORDING LOGIC
  // ---------------------------------------------------------------------------
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

    // RecordConfig (correct for record v5+)
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

  // ---------------------------------------------------------------------------
  // AI FEEDBACK LOGIC
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // UI SECTION: TOP BAR
  // ---------------------------------------------------------------------------
  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none,
                        color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI SECTION: INTRO PAGE
  // ---------------------------------------------------------------------------
  Widget _buildIntroSection() {
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.asset(
                'assets/b31d5472-09aa-4349-a81d-3ac90220f0d9.jpg',
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildTopBar(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "Welcome to AI\nAudience Platform !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _optionCard("Diversity Simulation"),
              _optionCard("Dynamic Reaction"),
              _optionCard("Feedback Generator"),
              _optionCard("Challenge Mode"),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() => _showRecordingSection = true);
                  _fadeController.forward(from: 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _optionCard(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: const Offset(0, 4),
              blurRadius: 8,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI SECTION: RECORDING PAGE
  // ---------------------------------------------------------------------------
  Widget _buildRecordingSection() {
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
              const SizedBox(height: 120),
              Expanded(
                child: _isLoadingFeedback
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _feedbackList.length,
                        itemBuilder: (context, index) =>
                            _feedbackBubble(_feedbackList[index]),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
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
                        padding: const EdgeInsets.all(25),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatDuration(_recordDuration),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle,
              color: isPositive ? Colors.green : Colors.red, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: _showRecordingSection
            ? _buildRecordingSection()
            : _buildIntroSection(),
      ),
    );
  }
}
