import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'public_speaking.dart';
import 'widgets/side_menu.dart';
import 'interview_skills.dart';
import 'ethics_etiquettes.dart';
import 'dressing_sense.dart';
import 'widgets/profile_avatar.dart';
import 'profile_page.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar with Menu, Notifications & Profile Avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu, color: Colors.white, size: 30.sp),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notifications coming soon!'),
                              ),
                            );
                          },
                        ),
                        ProfileAvatar(
                          radius: 20, 
                          onTap: () {
                            Navigator.push(
                              context,
                                MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
                // Welcome Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Welcome to\nWovell !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),

                SizedBox(height: 35.h),

                // SKILL CARDS 
                _buildSkillCard(
                  image: 'assets/public_speaking.jpg',
                  title: 'Public Speaking',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PublicSpeakingPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 28.h),

                _buildSkillCard(
                  image: 'assets/interview_skills.jpg',
                  title: 'Interview Skills',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InterviewSkillsPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 28.h),

                _buildSkillCard(
                  image: 'assets/ethics_etiquette.jpg',
                  title: 'Ethics & Etiquette',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EthicsEtiquettesPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 28.h),

                _buildSkillCard(
                  image: 'assets/dressing_sense.jpg',
                  title: 'Dressing Sense',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DressingSensePage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 50.h), 
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
            height: 110.h,
            margin: EdgeInsets.only(left: 65.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10.r,
                  offset: Offset(2.w, 4.h),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A3A5C),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Image.asset(
                image,
                width: 130.w,
                height: 110.h,
                fit: BoxFit.contain, 
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
