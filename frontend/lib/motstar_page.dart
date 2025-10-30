import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';
import 'notifications.dart';

class MOTstarPage extends StatefulWidget {
  const MOTstarPage({super.key});

  @override
  State<MOTstarPage> createState() => _MOTstarPageState();
}

class _MOTstarPageState extends State<MOTstarPage> {
  final List<Map<String, String>> _words = [
    {
      'word': 'Criticize',
      'explanation':
          'indicate the faults of someone or something in a disapproving way',
      'example':
          'The opposition criticized the government\'s failure to consult adequately.'
    },
    {
      'word': 'Ephemeral',
      'explanation': 'lasting for a very short time',
      'example': 'Fame in the world of social media is often ephemeral.'
    },
    {
      'word': 'Diffuse',
      'explanation': 'spread over a wide area or among many people',
      'example': 'The campaign aims to diffuse information on climate change.'
    },
    {
      'word': 'Assonance',
      'explanation': 'resemblance of sound between syllables of nearby words',
      'example': 'The poet uses assonance to create musical effects.'
    },
    {
      'word': 'Gossamer',
      'explanation': 'something light, thin, and delicate',
      'example': 'She wore a gossamer scarf that fluttered in the breeze.'
    },
  ];

  bool _loading = true;
  late SharedPreferences _prefs;
  static const String _prefsKeyHistory = 'mot_history_v1';
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    _prefs = await SharedPreferences.getInstance();

    final String? raw = _prefs.getString(_prefsKeyHistory);
    if (raw == null) {
      _seedInitialHistory();
      await _saveHistory();
    } else {
      try {
        _history = List<Map<String, dynamic>>.from(jsonDecode(raw));
      } catch (e) {
        _seedInitialHistory();
        await _saveHistory();
      }
    }

    final String todayKey = _dateKey(DateTime.now());
    if (_history.isEmpty || _history.first['dateKey'] != todayKey) {
      _addTodayToHistory();
      await _saveHistory();
    }

    await _checkExpiredClaims();

    setState(() {
      _loading = false;
    });
  }

  void _seedInitialHistory() {
    _history = [];
    DateTime now = DateTime.now();
    final rand = Random();
    for (int i = 0; i < 7; i++) {
      DateTime d = now.subtract(Duration(days: i));
      _history.add({
        'dateKey': _dateKey(d),
        'dateLabel': _formatDate(d),
        'wordIndex': i % _words.length,
        'progress': rand.nextInt(21),
        'claimed': i == 0 ? false : rand.nextBool(),
        'missed': false,
      });
    }
  }

  void _addTodayToHistory() {
    final DateTime today = DateTime.now();
    final int nextIndex =
        (_history.isEmpty ? 0 : (_history.first['wordIndex'] + 1) % _words.length);
    _history.insert(0, {
      'dateKey': _dateKey(today),
      'dateLabel': _formatDate(today),
      'wordIndex': nextIndex,
      'progress': 0,
      'claimed': false,
      'missed': false,
    });
    if (_history.length > 7) _history = _history.sublist(0, 7);
  }

  Future<void> _checkExpiredClaims() async {
    DateTime now = DateTime.now();
    for (var entry in _history) {
      DateTime entryDate = DateTime.parse(entry['dateKey']);
      bool isPast = entryDate.isBefore(DateTime(now.year, now.month, now.day));
      entry['missed'] = isPast && !(entry['claimed'] as bool);
    }
    await _saveHistory();
  }

  Future<void> _saveHistory() async {
    await _prefs.setString(_prefsKeyHistory, jsonEncode(_history));
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _claimToday() async {
    setState(() {
      _history[0]['claimed'] = true;
      _history[0]['progress'] = 20;
    });
    await _saveHistory();
  }

  bool _isClaimAvailable(Map<String, dynamic> entry) {
    DateTime now = DateTime.now();
    DateTime entryDate = DateTime.parse(entry['dateKey']);
    bool isToday = entryDate.year == now.year &&
        entryDate.month == now.month &&
        entryDate.day == now.day;
    return isToday && !(entry['claimed'] as bool);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final today = _history.first;
    final wordData = _words[today['wordIndex'] as int];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF007A7C), Color(0xFF1B3A5D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== Top Bar =====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 22.sp),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'MOTstar',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                    Row(children: [
                      IconButton(
                        icon: Icon(Icons.notifications_none_rounded,
                            color: Colors.white, size: 22.sp),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const NotificationsPage()),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const ProfilePage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundImage: const AssetImage(
                              'assets/avatar_male_medium_casual.png'),
                        ),
                      ),
                    ])
                  ],
                ),
              ),

              // ===== Golden Header =====
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6A84B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80.r),
                    bottomRight: Radius.circular(80.r),
                  ),
                ),
                child: Column(
                  children: [
                    Text('THE GOLDEN',
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.brown)),
                    Text('WORD',
                        style: TextStyle(
                            fontSize: 46.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                            height: 0.9)),
                    Text('OF THE DAY',
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown)),
                  ],
                ),
              ),

              // ===== Scrollable Section =====
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildMOTCard(
                        title: 'MOT Today',
                        word: wordData['word']!,
                        explanation: wordData['explanation']!,
                        example: wordData['example']!,
                        progress: today['progress'],
                        claimed: today['claimed'],
                        onClaim: _claimToday,
                      ),
                      SizedBox(height: 12.h),
                      ..._history.skip(1).map((h) => _buildHistoryCard(h)),
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

  // ===== WIDGETS =====
  Widget _buildMOTCard({
    required String title,
    required String word,
    required String explanation,
    required String example,
    required int progress,
    required bool claimed,
    required VoidCallback onClaim,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
          SizedBox(height: 6.h),
          Center(
            child: Text(
              '"$word"',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text("Explanation : $explanation",
              style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 4.h),
          Text("Example : $example", style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 10.h),
          LinearProgressIndicator(
            value: progress / 20,
            minHeight: 8.h,
            backgroundColor: Colors.grey.shade300,
            color: Colors.amber,
            borderRadius: BorderRadius.circular(5.r),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.star, color: Colors.amber, size: 20.sp),
                SizedBox(width: 4.w),
                Text(
                  "$progress/20",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
              ]),
              if (claimed)
                _statusButton('Claimed', Colors.green)
              else if (_isClaimAvailable(_history[0]))
                _claimButton(onClaim)
              else
                _statusButton('Missed', Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> data) {
    final word = _words[data['wordIndex']]['word']!;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(data['dateLabel'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.sp)),
            Text('"$word"',
                style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp)),
          ]),
          SizedBox(height: 6.h),
          LinearProgressIndicator(
            value: (data['progress'] / 20).clamp(0.0, 1.0),
            minHeight: 8.h,
            backgroundColor: Colors.grey.shade300,
            color: Colors.amber,
          ),
          SizedBox(height: 8.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Icon(Icons.star, color: Colors.amber, size: 20.sp),
              SizedBox(width: 4.w),
              Text("${data['progress']}/20",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15.sp)),
            ]),
            if (data['claimed'])
              _statusButton('Claimed', Colors.green)
            else
              _statusButton('Missed', Colors.redAccent),
          ])
        ],
      ),
    );
  }

  Widget _claimButton(VoidCallback onClaim) {
    return GestureDetector(
      onTap: () async {
        onClaim();
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 5.r,
              offset: Offset(0, 3.h),
            )
          ],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          'Claim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }

  Widget _statusButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}
