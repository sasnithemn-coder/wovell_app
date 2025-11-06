import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'models/user_progress.dart';
import 'landing.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProgress(),
      child: const WovellApp(),
    ),
  );
}

class WovellApp extends StatelessWidget {
  const WovellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Wovell',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),
          home: const SplashScreen(), 
        );
      },
    );
  }
}
