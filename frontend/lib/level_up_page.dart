import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'task1_page.dart';
import 'widgets/profile_avatar.dart'; 

class LevelUpPage extends StatefulWidget {
  const LevelUpPage({super.key});

  @override
  State<LevelUpPage> createState() => _LevelUpPageState();
}

class _LevelUpPageState extends State<LevelUpPage> {
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
  // Top Bar with Back, Notifications, and Profile Avatar 
  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            // Back Button 
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

            // Notifications & Profile Avatar 
            Row(
              children: [
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  child: const ProfileAvatar(radius: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Level Info 
  Widget _buildLevelInfoCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB47138),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    "Level 1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Text("• Level 1 of Bronze",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            Text("• Start your journey here",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            Text("• Just wake up your voice",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            Text("• Only require your voice",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            Text("• Require complete 25 stars to move to next level",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            Text("• Just follow simple instructions and reach your next level",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }

  // Level Buttons 
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
            width: 70.w,
            height: 70.w,
            decoration: const BoxDecoration(
              color: Color(0xFF008080),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$level",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              bool filled = i < stars;
              return Icon(Icons.star,
                  color: filled ? Colors.amber : Colors.grey, size: 18.sp);
            }),
          ),
        ],
      ),
    );
  }

  //  Roadmap 
  Widget _buildRoadMap() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(10, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: _buildLevelButton(index + 1),
            );
          }),
        ),
      ),
    );
  }

  // Main Page 
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
              SizedBox(height: 20.h),
              _buildLevelInfoCard(),
              SizedBox(height: 20.h),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h),
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
