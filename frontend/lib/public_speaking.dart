import 'package:flutter/material.dart';
import 'package:wovell_app/scriptsharp.dart';
import 'widgets/side_menu.dart';
import 'motstar_page.dart';
import 'speech_duty_page.dart';

class PublicSpeakingPage extends StatelessWidget {
  const PublicSpeakingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF0D7C7C),
              Color(0xFF1A3A5C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ====== TOP HERO IMAGE SECTION ======
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.asset(
                      'assets/public_speaking_banner.jpg',
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // ====== TOP ICONS ======
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu,
                            color: Colors.white, size: 28),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Row(
                      children: const [
                        Icon(Icons.notifications_none,
                            color: Colors.white, size: 28),
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                              'assets/avatar_male_medium_casual.png'),
                        ),
                      ],
                    ),
                  ),
                  // ====== TITLE TEXT ======
                  const Positioned(
                    bottom: 60,
                    left: 24,
                    child: Text(
                      'Public\nSpeaking',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 32,
                    left: 24,
                    child: Text(
                      'Master your voice\nand stage presence!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ====== BRONZE & LEADERBOARD SECTION ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Bronze progress details coming soon!')),
                          );
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.emoji_events,
                                  color: Colors.brown, size: 28),
                              const SizedBox(width: 10),
                              const Text(
                                'Bronze',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A3A5C),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: 0.4,
                                    color: Colors.orangeAccent,
                                    backgroundColor: Colors.grey.shade300,
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Leaderboard coming soon!')),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bar_chart,
                                  color: Color(0xFF1A3A5C)),
                              SizedBox(width: 8),
                              Text(
                                'Leaderboard',
                                style: TextStyle(
                                  color: Color(0xFF1A3A5C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ====== FEATURE SCROLL SECTION ======
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFeatureCard(
                      icon: Icons.wordpress,
                      title: 'MOTstar',
                      color: Colors.yellow.shade700,
                      onTap: () {
                        // --- FIXED NAVIGATION ---
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const MOTstarPage()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.calendar_month,
                      title: 'SpeechDuty',
                      color: Colors.greenAccent.shade400,
                      onTap: () {
                        // --- FIXED NAVIGATION ---
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const SpeechDutyPage()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.house_rounded,
                      title: 'VozHut',
                      color: Colors.purpleAccent.shade700,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('VozHut feature coming soon!')),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.smart_toy,
                      title: 'AI Audience',
                      color: Colors.blueAccent,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('AI Audience coming soon!')),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.text_fields,
                      title: 'ScriptSharp',
                      color: Colors.orangeAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScriptSharpPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ====== LEVEL UP BUTTON ======
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Level Up feature coming soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Level up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====== Feature Card Builder ======
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: color.withValues(alpha: 0.3),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1A3A5C),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
