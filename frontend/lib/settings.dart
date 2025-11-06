import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back Button, Notifications & Profile Avatar
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                      size: 22.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C42).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundImage: const AssetImage(
                              'assets/avatar_male_medium_casual.png'),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dinura',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'dinura@gmail.com',
                              style: TextStyle(
                                fontSize: 14.sp,
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

            SizedBox(height: 10.h),

            // Settings
            Expanded(
              child: ListView(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 55.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D7C7C).withValues(alpha: 0.9),
                    const Color(0xFF1A3A5C).withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 26.sp),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white70, size: 18.sp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
