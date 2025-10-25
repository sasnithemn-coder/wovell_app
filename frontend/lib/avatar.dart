import 'package:flutter/material.dart';
import 'main_home.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  // Selected gender (default: male)
  String selectedGender = 'male';

  // Get the avatar image based on selected gender
  String getAvatarImage() {
    if (selectedGender == 'male') {
      return 'assets/male_avatar.png'; // replace with your actual asset path
    } else {
      return 'assets/female_avatar.png'; // replace with your actual asset path
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back and Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Select your\nAvatar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Avatar Image Preview
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    getAvatarImage(),
                    key: ValueKey<String>(selectedGender),
                    width: 280,
                    height: 380,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Spacer(),

              // Gender Selection Buttons
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
                    const SizedBox(width: 20),
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

              const SizedBox(height: 30),

              // Select Button
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFFFF7B00),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainHomePage()),
                      );
                    },
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7B00) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7B00) : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
