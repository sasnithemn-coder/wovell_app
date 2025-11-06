import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'public_speaking.dart';

class ScriptSharpPage extends StatefulWidget {
  const ScriptSharpPage({super.key});

  @override
  State<ScriptSharpPage> createState() => _ScriptSharpPageState();
}

class _ScriptSharpPageState extends State<ScriptSharpPage> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF008080),
              Color(0xFF003366),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Bar, Notifications & Profile Avatar
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PublicSpeakingPage()),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsPage()),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 26.sp,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfilePage()),
                              );
                            },
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundImage: const AssetImage(
                                  'assets/male_avatar.png'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    'assets/sharpen_your_speech.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180.h,
                  ),
                ),

                SizedBox(height: 12.h),

                // Title
                Text(
                  'Scriptsharp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20.h),

                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: TextField(
                    controller: topicController,
                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Set your Topic',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7B00),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Body',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                Container(
                  height: 220.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: TextField(
                    controller: bodyController,
                    maxLines: null,
                    expands: true,
                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16.w),
                      border: InputBorder.none,
                      hintText: 'Drop your words here',
                      hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enhancing your speech...'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 60.w, vertical: 14.h),
                    backgroundColor: const Color(0xFFFF7B00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Correction',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
