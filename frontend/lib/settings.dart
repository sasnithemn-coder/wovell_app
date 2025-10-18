import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            // ====== TOP BAR ======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black87, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // ====== USER PROFILE CARD ======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C42).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(
                              'assets/avatar_male_medium_casual.png'), // Avatar preview
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Steven Smith',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'iit@gmail.com',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ====== SCROLLABLE SETTINGS LIST ======
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _buildSettingsButton(
                      icon: Icons.favorite,
                      label: 'Favourites',
                      color: Colors.redAccent),
                  _buildSettingsButton(
                      icon: Icons.notifications_active_rounded,
                      label: 'Notifications',
                      color: Colors.amberAccent),
                  _buildSettingsButton(
                      icon: Icons.history,
                      label: 'History',
                      color: Colors.blueGrey),
                  _buildSettingsButton(
                      icon: Icons.lock_outline,
                      label: 'Security',
                      color: Colors.lightBlueAccent),
                  _buildSettingsButton(
                      icon: Icons.brightness_6_rounded,
                      label: 'Display',
                      color: Colors.tealAccent.shade400),
                  _buildSettingsButton(
                      icon: Icons.contact_mail_outlined,
                      label: 'Contact us',
                      color: Colors.cyanAccent),
                  _buildSettingsButton(
                      icon: Icons.help_outline,
                      label: 'Help',
                      color: Colors.blueAccent),
                  _buildSettingsButton(
                      icon: Icons.star_rate_rounded,
                      label: 'Rate us',
                      color: Colors.orangeAccent),
                  _buildSettingsButton(
                      icon: Icons.flag_outlined,
                      label: 'Report',
                      color: Colors.pinkAccent),
                  _buildSettingsButton(
                      icon: Icons.info_outline,
                      label: 'About',
                      color: Colors.lightBlueAccent),
                  _buildSettingsButton(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      color: Colors.deepOrangeAccent),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== REUSABLE SETTINGS BUTTON ======
  Widget _buildSettingsButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: GestureDetector(
            onTap: () {}, 
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D7C7C).withValues(alpha: 0.9),
                    const Color(0xFF1A3A5C).withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white70, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
