import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'signin.dart';
import 'avatar.dart';
import 'models/user_progress.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Dinura';
  String email = 'dinura@gmail.com';
  final TextEditingController _nameController = TextEditingController();

  void _editName() {
    _nameController.text = userName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Enter your name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userName = _nameController.text.trim();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D7C7C),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = Provider.of<UserProgress>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF0D7C7C), Color(0xFF1A3A5C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 22.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar & Name Section 
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                      topRight: Radius.circular(50.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),

                        // Avatar bust image with edit icon 
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Consumer<UserProgress>(
                              builder: (context, progress, _) {
                                final avatarPath = progress.avatarBustPath;
                                return CircleAvatar(
                                  radius: 60.r,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: avatarPath != null
                                      ? (avatarPath.startsWith('assets/')
                                          ? AssetImage(avatarPath)
                                          : NetworkImage(avatarPath)
                                              as ImageProvider)
                                      : null,
                                  child: avatarPath == null
                                      ? Icon(Icons.person,
                                          size: 60.sp,
                                          color: Colors.grey.shade600)
                                      : null,
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AvatarPage()),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0D7C7C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 18.sp),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // User name + edit 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A3A5C),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: _editName,
                              child: Icon(Icons.edit,
                                  color: const Color(0xFF1A3A5C), size: 20.sp),
                            ),
                          ],
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _StatItem(label: 'Followers', value: '735'),
                            _StatItem(label: 'Following', value: '356'),
                            _StatItem(label: 'Likes', value: '135'),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Progress Chart
                        ...userProgress.progress.entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: _ProgressCard(
                              title: entry.key,
                              progress: entry.value,
                            ),
                          );
                        }),

                        SizedBox(height: 20.h),

                        // Logout Button
                        ElevatedButton.icon(
                          onPressed: _logout,
                          icon: Icon(Icons.logout_rounded,
                              color: const Color(0xFF1A3A5C), size: 20.sp),
                          label: Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFF1A3A5C),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            minimumSize: Size(220.w, 50.h),
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Delete Account Button
                        ElevatedButton.icon(
                          onPressed: _deleteAccount,
                          icon: Icon(Icons.delete_outline,
                              color: Colors.white, size: 20.sp),
                          label: Text(
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            minimumSize: Size(220.w, 50.h),
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stat Display Widget 
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
      ],
    );
  }
}

// Progress Card Widget 
class _ProgressCard extends StatelessWidget {
  final String title;
  final int progress;

  const _ProgressCard({required this.title, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress / 100),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10.h,
                backgroundColor: Colors.grey.shade300,
                color: const Color(0xFFFF8C42),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF1A3A5C),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                '$progress/100',
                style: TextStyle(
                  color: const Color(0xFF1A3A5C),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
