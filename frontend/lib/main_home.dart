import 'package:flutter/material.dart';
import 'public_speaking.dart';
import 'widgets/side_menu.dart';
import 'interview_skills.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== TOP NAVBAR ======
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none,
                              color: Colors.white, size: 28),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notifications coming soon!')),
                            );
                          },
                        ),
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/avatar_male_medium_casual.png'),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ====== WELCOME TEXT ======
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Welcome to\nWovell !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ====== SKILL CARDS ======
                _buildSkillCard(
                  image: 'assets/public_speaking.jpg',
                  title: 'Public Speaking',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PublicSpeakingPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildSkillCard(
                  image: 'assets/interview_skills.jpg',
                  title: 'Interview Skills',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InterviewSkillsPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildSkillCard(
                  image: 'assets/ethics_etiquette.jpg',
                  title: 'Ethics & Etiquette',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _buildSkillCard(
                  image: 'assets/dressing_sense.jpg',
                  title: 'Dressing Sense',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Skill card widget
  Widget _buildSkillCard({
    required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            margin: const EdgeInsets.only(left: 60),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A5C),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                width: 120,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
