import 'package:flutter/material.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'level_up_page.dart';

class InterviewSkillsPage extends StatelessWidget {
  const InterviewSkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF008080), Color(0xFF003366)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Background image
          Image.asset(
            'assets/3fc84ffa-73ac-41f9-884b-2f4351b02513.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Overlay color for clarity
          Container(color: Colors.black.withValues(alpha: 0.35)),

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const Spacer(),

                      // Notification button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const NotificationsPage()));
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

                      // Profile icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ProfilePage()));
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage('assets/avatar.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Interview Skills",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Get ready to impress at every opportunity!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Leaderboard & Bronze Progress Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Leaderboard page coming soon!')),
                          );
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.leaderboard, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Leaderboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Progress chart coming soon!')),
                          );
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.emoji_events, color: Colors.amber),
                                SizedBox(width: 8),
                                Text(
                                  "Bronze",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Special Features Title
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  "Special Features",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Horizontal scrollable special features
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    _FeatureCard(
                      title: "Mock Room",
                      icon: Icons.meeting_room,
                      color: Colors.green,
                    ),
                    _FeatureCard(
                      title: "Answer Helper",
                      icon: Icons.build,
                      color: Colors.purple,
                    ),
                    _FeatureCard(
                      title: "Situational Quiz",
                      icon: Icons.quiz,
                      color: Colors.redAccent,
                    ),
                    _FeatureCard(
                      title: "CV Analyzer",
                      icon: Icons.description,
                      color: Colors.yellow,
                      textColor: Colors.black,
                    ),
                    _FeatureCard(
                      title: "Body Language",
                      icon: Icons.person,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Bottom illustration image and Level Up button
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/5e3c022d-42b3-45f6-96de-af9134290402.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.15),
                  padding: const EdgeInsets.only(bottom: 30, top: 30),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LevelUpPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Level Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// Feature Card Widget
// ----------------------------------------------------
class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color? textColor;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: textColor ?? color,
            ),
          ),
        ],
      ),
    );
  }
}
