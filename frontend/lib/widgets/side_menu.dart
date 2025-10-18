import 'dart:ui';
import 'package:flutter/material.dart';
import '../main_home.dart';
import '../settings.dart';
import '../profile_page.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.72,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      elevation: 0,
      child: Stack(
        children: [
          // 🔹 Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD0D9D8), // Light grey-teal tone
                  Color(0xFF7EC6C3), // Teal-ish blue
                ],
              ),
            ),
          ),

          // 🔹 Glassmorphism Effect Layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              color: Colors.white.withValues(alpha: 0.08), // translucent overlay
            ),
          ),

          // 🔹 Drawer Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🧍‍♂️ Avatar & Welcome Text
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            AssetImage('assets/avatar_male_medium_casual.png'),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 🔹 Menu Items
                  _buildMenuItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainHomePage()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    } 
                  ),

                  _buildMenuItem(
                    icon: Icons.emoji_events_outlined,
                    title: 'Rewards',
                    onTap: () => _showMessage(context, 'Rewards page coming soon!'),
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Favourites',
                    onTap: () => _showMessage(context, 'Favourites page coming soon!'),
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Support',
                    onTap: () => _showMessage(context, 'Support page coming soon!'),
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()
                        ),
                      );
                    }
                  ),
                  const Spacer(),

                  // 🔹 App Footer / Branding
                  Center(
                    child: Column(
                      children: const [
                        Divider(color: Colors.black26),
                        SizedBox(height: 10),
                        Text(
                          'Wovell v1.0',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 26),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
