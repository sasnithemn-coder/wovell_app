import 'package:flutter/material.dart';
import 'main_home.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  // Avatar customization state
  String selectedOutfit = 'casual';
  String selectedSkin = 'medium';
  String selectedAccessory = 'none';
  String selectedGender = 'male';

  // You can replace these image paths with your actual asset paths
  String getAvatarImage() {
    return 'assets/avatar_$selectedGender$selectedSkin$selectedOutfit.png';
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
              Color(0xFF0D7C7C), // teal
              Color(0xFF1A3A5C), // dark blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Select your\nAvatar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar display
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      getAvatarImage(),
                      key: ValueKey(getAvatarImage()),
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Customization options
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    _buildOptionRow(
                      label: 'Skin Tone',
                      options: ['light', 'medium', 'dark'],
                      selected: selectedSkin,
                      onChanged: (value) {
                        setState(() => selectedSkin = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOptionRow(
                      label: 'Outfit',
                      options: ['casual', 'formal', 'sport'],
                      selected: selectedOutfit,
                      onChanged: (value) {
                        setState(() => selectedOutfit = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOptionRow(
                      label: 'Accessory',
                      options: ['none', 'glasses', 'hat'],
                      selected: selectedAccessory,
                      onChanged: (value) {
                        setState(() => selectedAccessory = value);
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainHomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8C42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable option builder
  Widget _buildOptionRow({
    required String label,
    required List<String> options,
    required String selected,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1A3A5C),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options.map((option) {
            bool isSelected = option == selected;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0D7C7C) : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option[0].toUpperCase() + option.substring(1),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
