import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'models/user_progress.dart'; 
import 'main_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  String selectedGender = 'male';

  // Avatar Preview
  String getAvatarImage() {
    return selectedGender == 'male'
        ? 'assets/avatars/male_avatar.png'
        : 'assets/avatars/female_avatar.png';
  }

  // Returns and save the bust only version of avatar
  String getBustImage() {
    return selectedGender == 'male'
        ? 'assets/avatars/male_bust.png'
        : 'assets/avatars/female_bust.png';
  }

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back & Title 
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Select your\nAvatar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Avatar Preview 
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      getAvatarImage(),
                      key: ValueKey<String>(selectedGender),
                      width: 250.w,
                      height: 340.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const Spacer(),

                // Select gender
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GenderButton(
                        label: 'Male',
                        isSelected: selectedGender == 'male',
                        onTap: () {
                          setState(() {
                            selectedGender = 'male';
                          });
                        },
                      ),
                      SizedBox(width: 20.w),
                      GenderButton(
                        label: 'Female',
                        isSelected: selectedGender == 'female',
                        onTap: () {
                          setState(() {
                            selectedGender = 'female';
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),
                // Select Button
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 90.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        backgroundColor: const Color(0xFFFF7B00),
                      ),
                      onPressed: () async {
                        // Save the bust image path to provider
                        final bustPath = getBustImage();
                        await context
                            .read<UserProgress>()
                            .setAvatarBustPath(bustPath);
                        print('✅ Saved avatar bust path: $bustPath');

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainHomePage(),
                          ),
                        );
                      },

                      child: Text(
                        'Select',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7B00) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7B00) : Colors.white,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
