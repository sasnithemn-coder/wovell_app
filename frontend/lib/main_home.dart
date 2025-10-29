import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'public_speaking.dart';
import 'widgets/side_menu.dart';
import 'interview_skills.dart';
import 'ethics_etiquettes.dart';
import 'dressing_sense.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== TOP NAVBAR ======
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
                            size: 26.sp,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notifications coming soon!'),
                              ),
                            );
                          },
                        ),
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: const AssetImage(
                            'assets/avatar_male_medium_casual.png',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // ====== WELCOME TEXT ======
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Welcome to\nWovell !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                // ====== SKILL CARDS ======
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
                SizedBox(height: 20.h),
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
                SizedBox(height: 20.h),
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
                SizedBox(height: 20.h),
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
            height: 100.h,
            margin: EdgeInsets.only(left: 60.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8.r,
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
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                image,
                width: 120.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
