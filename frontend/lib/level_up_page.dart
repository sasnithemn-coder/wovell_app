import 'package:flutter/material.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'task1_page.dart'; // the task page (recording logic reused from voz_hut)

class LevelUpPage extends StatefulWidget {
  const LevelUpPage({super.key});

  @override
  State<LevelUpPage> createState() => _LevelUpPageState();
}

class _LevelUpPageState extends State<LevelUpPage> {
  // Dummy star data
  final Map<int, int> starsEarned = {
    1: 3,
    2: 2,
    3: 0,
    4: 4,
    5: 1,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
    10: 0,
  };

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
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
              ),
            ),
            const Spacer(),
            Row(
              children: [
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLevelInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  "Level 1",
                  style: TextStyle(
                    backgroundColor: Color(0xFFB47138),
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text("• Level 1 of Bronze",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("• Start your journey here",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("• Just wake up your voice",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("• Only require your voice",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("• Require complete 25 stars to move to next level",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Text(
                "• Just follow the simple instructions and reach your next level",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelButton(int level) {
    int stars = starsEarned[level] ?? 0;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Task1Page()),
        );
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF008080),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$level",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              bool filled = i < stars;
              return Icon(Icons.star,
                  color: filled ? Colors.amber : Colors.grey, size: 18);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadMap() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _buildLevelButton(index + 1),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/94d36935-ead7-42da-95df-094b7543db71.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withValues(alpha: 0.3)),
          Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildLevelInfoCard(),
              const SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: _buildRoadMap(),
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
