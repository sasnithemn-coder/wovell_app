import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../main_home.dart';
import '../settings.dart';
import '../profile_page.dart';
import 'profile_avatar.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.72,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      elevation: 0,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD0D9D8), 
                  Color(0xFF7EC6C3), 
                ],
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar & Welcome Text
                  Row(
                    children: [
                      ProfileAvatar(
                          radius: 20, 
                          onTap: () {
                            Navigator.push(
                              context,
                                MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainHomePage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.emoji_events_outlined,
                    title: 'Rewards',
                    onTap: () =>
                        _showMessage(context, 'Rewards page coming soon!'),
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Favourites',
                    onTap: () =>
                        _showMessage(context, 'Favourites page coming soon!'),
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Support',
                    onTap: () =>
                        _showMessage(context, 'Support page coming soon!'),
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // App Version
                  Center(
                    child: Column(
                      children: [
                        Divider(color: Colors.black26, thickness: 1.h),
                        SizedBox(height: 10.h),
                        Text(
                          'Wovell v1.0',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.sp,
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

  // Menu Item Widget
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 26.sp),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Toast Message Helper
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
