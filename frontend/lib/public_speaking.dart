import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wovell_app/ai_audience_page.dart';
import 'package:wovell_app/level_up_page.dart';
import 'package:wovell_app/scriptsharp.dart';
import 'package:wovell_app/voz_hut.dart';
import 'widgets/side_menu.dart';
import 'motstar_page.dart';
import 'speech_duty_page.dart';
import 'notifications.dart';
import 'profile_page.dart';

class PublicSpeakingPage extends StatelessWidget {
  const PublicSpeakingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF008080), Color(0xFF003366)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Image.asset(
            'assets/994c8127-2b6d-42b5-999b-e87a32286e7d.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withValues(alpha: 0.35)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar, Notifications & Profile
              SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.menu,
                                color: Colors.white, size: 24.sp),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NotificationsPage()),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfilePage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage: const AssetImage(
                              'assets/avatar_male_medium_casual.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Title
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  "Public\nSpeaking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Subtitle
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  "Master your voice and stage presence!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                    height: 1.3,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Leaderboard & Medals Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Bronze progress details coming soon!'),
                            ),
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
                                  color: Colors.amber, size: 24.sp),
                              SizedBox(width: 8.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bronze",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    width: 100.w,
                                    height: 6.h,
                                    margin: EdgeInsets.only(top: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.6, 
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius:
                                              BorderRadius.circular(3.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                  Text('Leaderboard feature coming soon!'),
                            ),
                          );
                        },
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
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
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              // Speacial Features 
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

              SizedBox(
                height: 120.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    _FeatureCard(
                      title: "MOTstar",
                      icon: Icons.workspace_premium,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const MOTstarPage()),
                        );
                      },
                    ),
                    _FeatureCard(
                      title: "SpeechDuty",
                      icon: Icons.calendar_today,
                      color: Colors.green,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const SpeechDutyPage()),
                        );
                      },
                    ),
                    _FeatureCard(
                      title: "VozHut",
                      icon: Icons.mic,
                      color: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VozHutPage()),
                        );
                      },
                    ),
                    _FeatureCard(
                      title: "AI Audience",
                      icon: Icons.smart_toy,
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AiAudiencePage()),
                        );
                      },
                    ),
                    _FeatureCard(
                      title: "ScriptSharp",
                      icon: Icons.text_fields,
                      color: Colors.deepOrange,
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

              // Level Up Button
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/7be5ae46-3c7b-4906-8f22-f29771b1219f.jpg'),
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
                              builder: (_) => const LevelUpPage()),
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

// Feature Card Widget
class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      splashColor: color.withValues(alpha: 0.3),
      child: Container(
        width: 130.w,
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
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
