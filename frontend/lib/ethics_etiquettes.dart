import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'level_up_page.dart';
import 'models/user_progress.dart';
import 'widgets/profile_avatar.dart'; // ✅ Reusable avatar component

class EthicsEtiquettesPage extends StatelessWidget {
  const EthicsEtiquettesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===== Background Gradient =====
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF008080), Color(0xFF003366)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ===== Background Image =====
          Image.asset(
            'assets/6be12f30-77ad-4317-b1bc-b8c1fce3d3cb.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // ===== Overlay Shade =====
          Container(color: Colors.black.withValues(alpha: 0.35)),

          // ===== Page Content =====
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Row(
                    children: [
                      // ===== Back Button =====
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20.sp),
                        ),
                      ),

                      const Spacer(),

                      // ===== Notification Button =====
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.notifications_none,
                              color: Colors.white, size: 22.sp),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // ===== Dynamic Profile Avatar (bust) =====
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                        child: const ProfileAvatar(radius: 18), // ✅ updated here
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ===== Header Title =====
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  "Ethics &\nEtiquette",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // ===== Subtitle =====
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  "Learn the right way to act in every situation",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                    height: 1.3,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // ===== Leaderboard + Medal Buttons =====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Leaderboard page coming soon!')),
                          );
                        },
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.leaderboard,
                                  color: Colors.white, size: 22.sp),
                              SizedBox(width: 8.w),
                              Text(
                                "Leaderboard",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Progress chart coming soon!')),
                          );
                        },
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emoji_events,
                                  color: Colors.amber, size: 22.sp),
                              SizedBox(width: 8.w),
                              Text(
                                "Bronze",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
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

              SizedBox(height: 25.h),

              // ===== Special Features =====
              Padding(
                padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
                child: Text(
                  "Special Features",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // ===== Features List =====
              SizedBox(
                height: 120.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: const [
                    _FeatureCard(
                      title: "Scenario-Based Learning",
                      icon: Icons.school,
                      color: Colors.grey,
                    ),
                    _FeatureCard(
                      title: "Politeness Meter",
                      icon: Icons.speed,
                      color: Colors.orange,
                    ),
                    _FeatureCard(
                      title: "Common Mistake Quiz",
                      icon: Icons.help_outline,
                      color: Colors.black,
                    ),
                    _FeatureCard(
                      title: "AR Etiquette Simulator",
                      icon: Icons.face_retouching_natural,
                      color: Colors.green,
                    ),
                    _FeatureCard(
                      title: "Daily Etiquette Tips",
                      icon: Icons.lightbulb_outline,
                      color: Colors.amber,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ===== Level Up Button Section =====
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/2bfa6cac-d189-4ded-a6e9-37c12c40c745.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.1),
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LevelUpPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        padding: EdgeInsets.symmetric(
                          horizontal: 80.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        "Level Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
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

// ===== Feature Card =====
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
      width: 150.w,
      margin: EdgeInsets.only(right: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: color, width: 2.w),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 10.r,
            offset: Offset(0, 6.h),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30.sp),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: textColor ?? color,
            ),
          ),
        ],
      ),
    );
  }
}
