import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'signup.dart';
import 'main_home.dart'; // ✅ direct redirect here

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _scrollController = ScrollController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_scrollToField);
    _passwordFocus.addListener(_scrollToField);
  }

  void _scrollToField() {
    if (_emailFocus.hasFocus || _passwordFocus.hasFocus) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _signIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }
    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email');
      return;
    }

    // ✅ Redirect directly to MainHomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainHomePage()),
    );
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  void _showMessage(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity, // 🩵 ensures full gradient coverage
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF0D7C7C), Color(0xFF1A3A5C)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height, // 🩵 fixes gap
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60.h),
                      Text(
                        'Welcome \nBack !',
                        style: TextStyle(
                          fontSize: 44.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Sign in to continue your journey.',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              label: 'Email',
                              hint: 'Enter your email',
                              controller: _emailController,
                              focusNode: _emailFocus,
                              isEmail: true,
                            ),
                            SizedBox(height: 20.h),
                            _buildPasswordField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _passwordController,
                              obscure: _obscurePassword,
                              toggle: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              focusNode: _passwordFocus,
                            ),
                            SizedBox(height: 30.h),
                            SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: ElevatedButton(
                                onPressed: _signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF8C42),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.r),
                                  ),
                                ),
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14.sp),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SignUpScreen()),
                                  ),
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: const Color(0xFF1A3A5C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool isEmail = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A3A5C))),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
            border: const UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
    required FocusNode focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A3A5C))),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
            border: const UnderlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
                size: 20.sp,
              ),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}
