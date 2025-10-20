// lib/notifications.dart
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF0D7C7C),
      ),
      body: const Center(
        child: Text(
          'No notifications yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}