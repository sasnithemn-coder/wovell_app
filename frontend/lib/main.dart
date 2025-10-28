import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'signin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WovellApp());
}

class WovellApp extends StatelessWidget {
  const WovellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896), // iPhone 11 base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // You can still access ScreenUtil here if needed, e.g. ScreenUtil().screenWidth
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wovell',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: const SignInScreen(),
        );
      },
    );
  }
}
