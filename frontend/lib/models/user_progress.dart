import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgress extends ChangeNotifier {
  // Sample progress data (0–100)
  Map<String, int> progress = {
    'Public Speaking': 48,
    'Interview Skills': 24,
    'Ethics & Etiquette': 64,
    'Dressing Sense': 90,
  };

  // Avatar path 
  String? _avatarBustPath;
  String? get avatarBustPath => _avatarBustPath;

  void updateProgress(String category, int value) {
    progress[category] = value.clamp(0, 100);
    notifyListeners();
  }

  int getProgress(String category) {
    return progress[category] ?? 0;
  }

  // Save selected avatar 
  Future<void> setAvatarBustPath(String path) async {
    _avatarBustPath = path;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarBustPath', path);
  }

  // Load avatar at app start 
  Future<void> loadAvatarBustPath() async {
    final prefs = await SharedPreferences.getInstance();
    _avatarBustPath = prefs.getString('avatarBustPath');
    notifyListeners();
  }
}
