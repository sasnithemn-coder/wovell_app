import 'package:flutter/material.dart';

class UserProgress extends ChangeNotifier {
  // Example progress data (0–100)
  Map<String, int> progress = {
    'Public Speaking': 48,
    'Interview Skills': 24,
    'Ethics & Etiquette': 64,
    'Dressing Sense': 90,
  };

  void updateProgress(String category, int value) {
    progress[category] = value.clamp(0, 100);
    notifyListeners(); // Notifies all listening widgets
  }

  int getProgress(String category) {
    return progress[category] ?? 0;
  }
}
