import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_progress.dart'; 

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.radius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarPath = context.watch<UserProgress>().avatarBustPath;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        backgroundImage: avatarPath != null
            ? (avatarPath.startsWith('assets/')
                ? AssetImage(avatarPath)
                : NetworkImage(avatarPath) as ImageProvider)
            : null,
        child: avatarPath == null
            ? const Icon(Icons.person, color: Colors.black54)
            : null,
      ),
    );
  }
}
