import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'notifications.dart';
import 'profile_page.dart';
import 'public_speaking.dart';

class VozHutPage extends StatefulWidget {
  const VozHutPage({super.key});

  @override
  State<VozHutPage> createState() => _VozHutPageState();
}

class _VozHutPageState extends State<VozHutPage> {
  final recorder = AudioRecorder();
  bool isRecording = false;
  String audioPath = '';
  String aiFeedback = '';
  bool loadingFeedback = false;

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

  // 🎤 Start Recording
  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      final path = '/storage/emulated/0/Download/speech_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await recorder.start(const RecordConfig(), path: path);
      setState(() {
        isRecording = true;
        audioPath = path;
      });
    }
  }

  // 🛑 Stop Recording
  Future<void> stopRecording(String topic) async {
    await recorder.stop();
    setState(() {
      isRecording = false;
    });
    _analyzeSpeech(topic);
  }

  // 🤖 Send to AI (Mocked endpoint example)
  Future<void> _analyzeSpeech(String topic) async {
    setState(() {
      loadingFeedback = true;
    });

    // Replace this with your AI endpoint or Gemini/OpenAI logic
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      loadingFeedback = false;
      aiFeedback = '''
✅ Topic: $topic
🎯 Pronunciation: Clear and confident  
🧠 Vocabulary: Strong and varied  
🗣️ Fluency: Excellent pace with minimal filler words  
💡 Suggestion: Add a more emotional tone for better audience connection.
      ''';
    });

    _showFeedbackDialog(topic);
  }

  // 📊 Show Feedback Dialog
  void _showFeedbackDialog(String topic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF003366),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'AI Feedback - $topic',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          aiFeedback,
          style: const TextStyle(color: Colors.white70, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  // 🕐 Countdown before recording
  void _showSpeechModal(String topic) {
    int countdown = 3;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Timer.periodic(const Duration(seconds: 1), (t) {
          if (countdown == 1) {
            t.cancel();
            Navigator.pop(context);
            startRecording();
          } else {
            setState(() => countdown--);
          }
        });

        return AlertDialog(
          backgroundColor: const Color(0xFF003366),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Starting in $countdown...',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 4), () {
      _showRecordingDialog(topic);
    });
  }

  // 🎤 Recording UI
  void _showRecordingDialog(String topic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF003366),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mic, color: Colors.redAccent, size: 60),
                const SizedBox(height: 10),
                Text(
                  isRecording ? 'Recording your speech...' : 'Stopped',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    stopRecording(topic);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7B00),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Stop', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
              // 🔹 Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const PublicSpeakingPage()),
                        );
                      },
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                    ),
                    const Text(
                      'VozHut',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationsPage()),
                            );
                          },
                          child: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage('assets/male_avatar.png'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔹 Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/voz_hut_banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 🔹 Topics List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: topics.map((topic) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '"${topic['title']}"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  topic['level']!,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => _showSpeechModal(topic['title']!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Start',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
